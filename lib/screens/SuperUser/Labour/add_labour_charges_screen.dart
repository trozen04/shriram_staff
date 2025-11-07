import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shree_ram_staff/widgets/custom_app_bar.dart';
import 'package:shree_ram_staff/Constants/app_dimensions.dart';
import 'package:shree_ram_staff/widgets/primary_and_outlined_button.dart';
import 'package:shree_ram_staff/widgets/reusable_functions.dart';
import '../../../Bloc/LabourBloc/labour_bloc.dart';
import '../../../Constants/ApiConstants.dart';
import '../../../utils/pref_utils.dart';
import '../../../widgets/custom_snackbar.dart';

class AddLabourChargesScreen extends StatefulWidget {
  const AddLabourChargesScreen({super.key});

  @override
  State<AddLabourChargesScreen> createState() => _AddLabourChargesScreenState();
}

class _AddLabourChargesScreenState extends State<AddLabourChargesScreen> {
  List<Map<String, TextEditingController>> items = [];

  @override
  void initState() {
    super.initState();
    _addNewItem(); // Start with one item
  }

  void _addNewItem() {
    setState(() {
      items.add({
        'name': TextEditingController(),
        'unit': TextEditingController(),
        'price': TextEditingController(),
        'amount': TextEditingController(text: '0.00'),
        'extra': TextEditingController(),
      });
    });
  }

  void _removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  void _calculateAmount(int index) {
    final unit = double.tryParse(items[index]['unit']!.text) ?? 0;
    final price = double.tryParse(items[index]['price']!.text) ?? 0;
    final total = unit * price;
    items[index]['amount']!.text = total.toStringAsFixed(2);
  }

  void _submit() {
    final labourItems = items.map((item) {
      return {
        "itemname": item['name']!.text.trim(),
        "unit": int.tryParse(item['unit']!.text) ?? 0,
        "price": int.tryParse(item['price']!.text) ?? 0,
        "amount": double.tryParse(item['amount']!.text) ?? 0.0,
        "extra": double.tryParse(item['extra']!.text) ?? 0.0,
      };
    }).toList();

    developer.log("📤 Create Labour Request: ${json.encode({"labourItems": labourItems})}");

    context.read<LabourBloc>().add(CreateLabourEvent(labourItems: labourItems));
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return BlocListener<LabourBloc, LabourState>(
      listener: (context, state) {
        if (state is LabourCreateSuccessState) {
          CustomSnackBar.show(
            context,
            message: "Labour items created successfully!",
          );
          // Clear all items after success
          Navigator.pop(context, true);
        } else if (state is LabourErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            isHomePage: false,
            title: 'Labour Charges',
            preferredHeight: height * 0.12,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.035,
              vertical: height * 0.015,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (int i = 0; i < items.length; i++) ...[
                    ReusableTextField(
                      label: 'Name',
                      hint: 'Enter Name',
                      controller: items[i]['name'],
                      actionLabel: i == 0 ? 'Add another Item' : null,
                      onActionTap: i == 0 ? _addNewItem : null,
                      actionIcon:
                      i != 0 ? Icons.remove_circle_outline : null,
                      onIconTap: i != 0 ? () => _removeItem(i) : null,
                    ),
                    AppDimensions.h10(context),

                    ReusableTextField(
                      label: 'Unit',
                      hint: 'Enter Unit',
                      controller: items[i]['unit'],
                      keyboardType: TextInputType.number,
                      onChanged: (_) => _calculateAmount(i),
                    ),
                    AppDimensions.h10(context),

                    ReusableTextField(
                      label: 'Price per unit',
                      hint: 'Enter Price',
                      controller: items[i]['price'],
                      keyboardType: TextInputType.number,
                      onChanged: (_) => _calculateAmount(i),
                    ),
                    AppDimensions.h10(context),

                    ReusableTextField(
                      label: 'Amount',
                      hint: 'Amount',
                      controller: items[i]['amount'],
                      readOnly: true,
                    ),
                    AppDimensions.h10(context),

                    ReusableTextField(
                      label: 'Extra',
                      hint: 'Enter Amount',
                      controller: items[i]['extra'],
                      keyboardType: TextInputType.number,
                    ),

                    if (i != items.length - 1) AppDimensions.h30(context),
                  ],

                  AppDimensions.h30(context),

                  BlocBuilder<LabourBloc, LabourState>(
                    builder: (context, state) {
                      if (state is LabourLoadingState) {
                        return const CircularProgressIndicator();
                      }
                      return PrimaryButton(text: 'Submit', onPressed: _submit);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
