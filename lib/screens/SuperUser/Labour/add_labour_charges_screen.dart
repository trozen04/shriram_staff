import 'package:flutter/material.dart';
import 'package:shree_ram_staff/widgets/custom_app_bar.dart';
import 'package:shree_ram_staff/Constants/app_dimensions.dart';
import 'package:shree_ram_staff/widgets/primary_and_outlined_button.dart';
import 'package:shree_ram_staff/widgets/reusable_functions.dart';

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
    _addNewItem(); // start with one
  }

  void _addNewItem() {
    setState(() {
      items.add({
        'name': TextEditingController(),
        'unit': TextEditingController(),
        'price': TextEditingController(),
        'amount': TextEditingController(text: 'Amount'),
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
    for (var i = 0; i < items.length; i++) {
      debugPrint("Item ${i + 1}: ${items[i]['name']!.text}");
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Items submitted successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
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
                // Loop through each item section
                for (int i = 0; i < items.length; i++) ...[
                  ReusableTextField(
                    label: 'Name',
                    hint: 'Enter Name',
                    controller: items[i]['name'],
                    actionLabel: i == 0 ? 'Add another Item' : null,
                    onActionTap: i == 0 ? _addNewItem : null,
                    actionIcon: i != 0 ? Icons.remove_circle_outline : null,
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

                // Save Button
                ReusableOutlinedButton(text: 'Save', onPressed: () {}),
                AppDimensions.h50(context),

                // Submit Button
                PrimaryButton(text: 'Submit', onPressed: _submit),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
