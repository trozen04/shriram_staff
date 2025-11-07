import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shree_ram_staff/utils/app_colors.dart';
import 'package:shree_ram_staff/utils/flutter_font_styles.dart';
import 'package:shree_ram_staff/Constants/app_dimensions.dart';
import 'package:shree_ram_staff/widgets/primary_and_outlined_button.dart';
import 'package:shree_ram_staff/widgets/reusable_appbar.dart';
import '../../../widgets/reusable_functions.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../Bloc/FactoryBloc/factory_bloc.dart';
import '../../../Bloc/SalesBloc/sales_bloc.dart';

class CreateSalesLeadScreen extends StatefulWidget {
  const CreateSalesLeadScreen({super.key});

  @override
  State<CreateSalesLeadScreen> createState() => _CreateSalesLeadScreenState();
}

class ItemField {
  final TextEditingController nameController;
  final TextEditingController bagsController;
  final TextEditingController qtyController;

  ItemField({
    required this.nameController,
    required this.bagsController,
    required this.qtyController,
  });

  void dispose() {
    nameController.dispose();
    bagsController.dispose();
    qtyController.dispose();
  }
}

class _CreateSalesLeadScreenState extends State<CreateSalesLeadScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  List<Map<String, String>> factoryList = [];
  String? _selectedFactory;
  bool isLoadingFactory = false;

  /// ✅ Item fields (each item has name, bags, qty)
  final List<ItemField> _items = [
    ItemField(
      nameController: TextEditingController(),
      bagsController: TextEditingController(),
      qtyController: TextEditingController(),
    ),
  ];

  /// Add another item (creates name + bags + qty)
  void _addNewItem() {
    setState(() {
      _items.add(
        ItemField(
          nameController: TextEditingController(),
          bagsController: TextEditingController(),
          qtyController: TextEditingController(),
        ),
      );
    });
  }

  /// Remove item field
  void _removeItem(int index) {
    setState(() {
      _items[index].dispose();
      _items.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<FactoryBloc>().add(FactoryEventHandler());
  }

  @override
  void dispose() {
    for (var item in _items) item.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return MultiBlocListener(
      listeners: [
        BlocListener<FactoryBloc, FactoryState>(
          listener: (context, state) {
            if (state is FactoryLoadingState) {
              setState(() => isLoadingFactory = true);
            } else {
              setState(() => isLoadingFactory = false);
            }

            if (state is FactorySuccessState) {
              final dataList = state.factoryData['data'] as List;
              factoryList = dataList
                  .map((e) => {
                '_id': e['_id'].toString(),
                'name': e['factoryname'].toString(),
              })
                  .toList();
              _selectedFactory = null;
              setState(() {});
            }

            if (state is FactoryErrorState) {
              CustomSnackBar.show(context,
                  message: state.message, isError: true);
            }
          },
        ),

        /// SalesBloc listener for create
        BlocListener<SalesBloc, SalesState>(
          listener: (context, state) {
            if (state is SalesCreateSuccess) {
              Navigator.pop(context, true); // pop with true on success
            }
            if (state is SalesError) {
              CustomSnackBar.show(context,
                  message: state.message, isError: true);
            }
          },
        ),
      ],
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: ReusableAppBar(title: 'Create Sales Lead'),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.035,
              vertical: height * 0.015,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReusableTextField(
                    label: 'Customer Name',
                    hint: 'Enter Name',
                    controller: _nameController,
                    validator: (val) =>
                    val == null || val.isEmpty ? 'Customer name is required' : null,
                  ),
                  AppDimensions.h10(context),
                  ReusableTextField(
                    label: 'Phone Number',
                    hint: 'Enter Phone Number',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Enter phone number';
                      if (val.length < 10) return 'Enter valid number';
                      return null;
                    },
                  ),
                  AppDimensions.h10(context),
                  ReusableTextField(
                    label: 'Address',
                    hint: 'Enter Address',
                    controller: _addressController,
                    validator: (val) => val == null || val.isEmpty ? 'Enter address' : null,
                  ),
                  AppDimensions.h10(context),
                  ReusableTextField(
                    label: 'City/Town',
                    hint: 'Enter City/Town',
                    controller: _cityController,
                    validator: (val) => val == null || val.isEmpty ? 'Enter city/town' : null,
                  ),
                  AppDimensions.h10(context),

                  /// Factory Dropdown
                  /// Factory Dropdown
                  Text('Factory', style: AppTextStyles.label),
                  AppDimensions.h5(context),
                  isLoadingFactory
                      ? const SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.borderColor, width: 1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedFactory,
                      hint: Text('Select Factory', style: AppTextStyles.bodyText),
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down),
                      style: AppTextStyles.bodyText,
                      items: factoryList
                          .map(
                            (f) => DropdownMenuItem<String>(
                          value: f['_id'], // store _id as value
                          child: Text(f['name']!, style: AppTextStyles.bodyText),
                        ),
                      )
                          .toList(),
                      onChanged: (val) {
                        setState(() => _selectedFactory = val);
                      },
                      validator: (val) =>
                      val == null || val.isEmpty ? 'Select factory' : null,
                      decoration: const InputDecoration(
                        border: InputBorder.none, // remove default underline
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),

                  AppDimensions.h10(context),

                  /// Items (name + bags + qty)
                  ..._items.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReusableTextField(
                          label: index == 0 ? 'Item' : 'Item ${index + 1}',
                          hint: 'Enter Item',
                          controller: item.nameController,
                          validator: (val) =>
                          val == null || val.isEmpty ? 'Enter item' : null,
                          actionLabel: index == 0 ? 'Add another item' : null,
                          onActionTap: index == 0 ? _addNewItem : null,
                          actionIcon:
                          index != 0 ? Icons.remove_circle_outline : null,
                          onIconTap: index != 0 ? () => _removeItem(index) : null,
                        ),
                        AppDimensions.h10(context),
                        ReusableTextField(
                          label: 'Bags',
                          hint: 'Enter No. of bags',
                          controller: item.bagsController,
                          keyboardType: TextInputType.number,
                          validator: (val) =>
                          val == null || val.isEmpty ? 'Enter number of bags' : null,
                        ),
                        AppDimensions.h10(context),
                        ReusableTextField(
                          label: 'QTY',
                          hint: 'Enter Quantity',
                          controller: item.qtyController,
                          keyboardType: TextInputType.number,
                          validator: (val) =>
                          val == null || val.isEmpty ? 'Enter quantity' : null,
                        ),
                        AppDimensions.h20(context),
                      ],
                    );
                  }),

                  AppDimensions.h30(context),

                  PrimaryButton(
                    text: 'Submit',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final finalQCItems = [
                          {
                            'finalQCId': '', // replace with actual QC Id if needed
                            'items': _items.map((item) {
                              return {
                                'item': item.nameController.text,
                                'bags': int.tryParse(item.bagsController.text) ?? 0,
                                'weight': int.tryParse(item.qtyController.text) ?? 0,
                              };
                            }).toList(),
                          }
                        ];

                        context.read<SalesBloc>().add(
                          CreateSalesLeadEvent(
                            customerName: _nameController.text,
                            phoneNo: _phoneController.text,
                            address: _addressController.text,
                            city: _cityController.text,
                            factoryId: _selectedFactory ?? '',
                            finalQCItems: finalQCItems,
                          ),
                        );
                      }
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
