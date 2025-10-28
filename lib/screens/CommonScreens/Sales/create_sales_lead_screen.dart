import 'package:flutter/material.dart';
import 'package:shree_ram_staff/utils/app_colors.dart';
import 'package:shree_ram_staff/utils/flutter_font_styles.dart';
import 'package:shree_ram_staff/Constants/app_dimensions.dart';
import 'package:shree_ram_staff/widgets/primary_and_outlined_button.dart';
import 'package:shree_ram_staff/widgets/reusable_appbar.dart';
import '../../../widgets/reusable_functions.dart';

class CreateSalesLeadScreen extends StatefulWidget {
  const CreateSalesLeadScreen({super.key});

  @override
  State<CreateSalesLeadScreen> createState() => _CreateSalesLeadScreenState();
}

class _CreateSalesLeadScreenState extends State<CreateSalesLeadScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  String? _selectedFactory;
  final List<String> factoryList = ['Factory A', 'Factory B', 'Factory C'];

  /// Dynamic item controllers
  final List<TextEditingController> _itemControllers = [TextEditingController()];

  final TextEditingController _bagsController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();

  /// Add new item field
  void _addNewItemField() {
    setState(() {
      _itemControllers.add(TextEditingController());
    });
  }

  /// Remove item field (except first)
  void _removeItemField(int index) {
    setState(() {
      _itemControllers.removeAt(index);
    });
  }

  @override
  void dispose() {
    for (var c in _itemControllers) {
      c.dispose();
    }
    _bagsController.dispose();
    _qtyController.dispose();
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

    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: ReusableAppBar(title: 'Create Sales Lead'),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: width * 0.035, vertical: height * 0.015),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Customer Name
                ReusableTextField(
                  label: 'Customer Name',
                  hint: 'Enter Name',
                  controller: _nameController,
                  validator: (val) => val == null || val.isEmpty ? 'Customer name is required' : null,
                ),
                AppDimensions.h10(context),

                /// Phone Number
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

                /// Address
                ReusableTextField(
                  label: 'Address',
                  hint: 'Enter Address',
                  controller: _addressController,
                  validator: (val) => val == null || val.isEmpty ? 'Enter address' : null,
                ),
                AppDimensions.h10(context),

                /// City/Town
                ReusableTextField(
                  label: 'City/Town',
                  hint: 'Enter City/Town',
                  controller: _cityController,
                  validator: (val) => val == null || val.isEmpty ? 'Enter city/town' : null,
                ),
                AppDimensions.h10(context),

                /// Factory Dropdown
                Text('Factory', style: AppTextStyles.label),
                AppDimensions.h5(context),
                ReusableDropdown(
                  items: factoryList,
                  value: _selectedFactory,
                  hintText: 'Select Factory',
                  onChanged: (val) => setState(() => _selectedFactory = val),
                  validator: (val) => val == null || val.isEmpty ? 'Select factory' : null,
                ),
                AppDimensions.h10(context),

                /// ✅ Dynamic Item fields
                ..._itemControllers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final controller = entry.value;

                  return Padding(
                    padding: EdgeInsets.only(bottom: height * 0.012),
                    child: ReusableTextField(
                      label: index == 0 ? 'Item' : 'Item ${index + 1}',
                      hint: 'Enter Item',
                      controller: controller,
                      validator: (val) => val == null || val.isEmpty ? 'Enter item' : null,
                      // Show Add button on first only
                      actionLabel: index == 0 ? 'Add another item' : null,
                      onActionTap: index == 0 ? _addNewItemField : null,
                      // Show Remove button on all except first
                      actionIcon: index != 0 ? Icons.remove_circle_outline : null,
                      onIconTap: index != 0 ? () => _removeItemField(index) : null,
                    ),
                  );
                }),
                AppDimensions.h10(context),

                /// Stock Left label
                Text('Stock left', style: AppTextStyles.bodyText),
                AppDimensions.h10(context),

                /// Bags
                ReusableTextField(
                  label: 'Bags',
                  hint: 'Enter No. of bags',
                  controller: _bagsController,
                  keyboardType: TextInputType.number,
                  validator: (val) => val == null || val.isEmpty ? 'Enter number of bags' : null,
                ),
                AppDimensions.h10(context),

                /// Quantity
                ReusableTextField(
                  label: 'QTY',
                  hint: 'Enter Quantity',
                  controller: _qtyController,
                  keyboardType: TextInputType.number,
                  validator: (val) => val == null || val.isEmpty ? 'Enter quantity' : null,
                ),
                AppDimensions.h30(context),

                /// Submit Button
                PrimaryButton(
                  text: 'Submit',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Form Submitted')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
