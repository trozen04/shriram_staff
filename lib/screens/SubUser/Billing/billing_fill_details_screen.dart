import 'package:flutter/material.dart';
import 'package:shree_ram_staff/utils/app_colors.dart';
import 'package:shree_ram_staff/utils/flutter_font_styles.dart';
import 'package:shree_ram_staff/widgets/reusable_appbar.dart';
import 'package:shree_ram_staff/widgets/reusable_functions.dart';
import 'package:shree_ram_staff/Constants/app_dimensions.dart';

import '../../../utils/app_routes.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/primary_and_outlined_button.dart';

class BillingFillDetailsScreen extends StatefulWidget {
  final dynamic billingData;
  const BillingFillDetailsScreen({super.key, this.billingData});

  @override
  State<BillingFillDetailsScreen> createState() => _BillingFillDetailsScreenState();
}

class _BillingFillDetailsScreenState extends State<BillingFillDetailsScreen> {
  final TextEditingController finalWeightController = TextEditingController();
  final TextEditingController laborChargeController = TextEditingController();
  final TextEditingController brokerageController = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();

  final List<String> paddyTypes = ['Basmati', 'Sona Masoori', 'IR64'];

  /// dynamic paddy entries: each item = {type, weightController, amountController}
  final List<Map<String, dynamic>> paddyEntries = [];

  /// dynamic deductions: each item = {label, controller}
  final List<Map<String, dynamic>> deductions = [];

  @override
  void initState() {
    super.initState();
    // start with one default paddy entry
    _addPaddyEntry();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: const ReusableAppBar(title: '#22311'),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: width * 0.035, vertical: height * 0.015),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === BASIC INFO ===
              const ProfileRow(label: 'Unit ID', value: '#221212'),
              const ProfileRow(label: 'Name', value: 'Ramesh Yadav'),
              const ProfileRow(label: 'Broker', value: 'Rahul'),
              const ProfileRow(label: 'Initial Weight', value: '511 Qntl'),

              AppDimensions.h10(context),
              Text('Final Weight', style: AppTextStyles.label),
              AppDimensions.h5(context),
              CustomTextFormField(
                controller: finalWeightController,
                hintText: 'Enter Final weight',
                validator: (value) => value == null || value.isEmpty ? 'Final weight is required' : null,
              ),

              AppDimensions.h10(context),
              const ProfileRow(label: 'Net Weight', value: '112 Qntl'),
              AppDimensions.h20(context),

              _buildSectionTitle('Enter Billing Details'),
              AppDimensions.h10(context),

              // === Dynamic Paddy Entries ===
              ..._buildPaddyEntries(),



              AppDimensions.h20(context),
              _buildSectionTitle('Extra Charges to be deduct'),

              AppDimensions.h10(context),
              Text('Labor Charge', style: AppTextStyles.label),
              AppDimensions.h5(context),
              CustomTextFormField(
                controller: laborChargeController,
                hintText: 'Labor Charge',
                isReadOnly: true,
              ),

              AppDimensions.h10(context),
              Text('Brokerage', style: AppTextStyles.label),
              AppDimensions.h5(context),
              CustomTextFormField(
                controller: brokerageController,
                hintText: 'Brokerage',
                isReadOnly: true,
              ),

              // === Dynamic Deductions ===
              ..._buildDynamicDeductions(),

              AppDimensions.h10(context),
              InkWell(
                onTap: _addDeductionField,
                child: Text(
                  '+ Add another deduction',
                  style: AppTextStyles.underlineText,
                ),
              ),

              AppDimensions.h20(context),
              Text('Total Amount', style: AppTextStyles.label),
              AppDimensions.h5(context),
              CustomTextFormField(
                controller: totalAmountController,
                hintText: 'Total Amount',
                isReadOnly: true,
              ),

              AppDimensions.h30(context),
              PrimaryButton(
                text: 'Submit',
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.billingDetailsScreen, arguments: null);
                },
              ),
              AppDimensions.h20(context),
            ],
          ),
        ),
      ),
    );
  }

  // --- SECTION TITLE ---
  Widget _buildSectionTitle(String title) =>
      Text(title, style: AppTextStyles.appbarTitle);

  // --- ADD NEW PADDY ENTRY ---
  void _addPaddyEntry() {
    setState(() {
      paddyEntries.add({
        'type': null,
        'weightController': TextEditingController(),
        'amountController': TextEditingController(),
      });
    });
  }

  // --- REMOVE PADDY ENTRY ---
  void _removePaddyEntry(int index) {
    setState(() {
      paddyEntries.removeAt(index);
    });
  }

  // --- BUILD PADDY ENTRY WIDGETS ---
  List<Widget> _buildPaddyEntries() {
    return paddyEntries.asMap().entries.map((entry) {
      int index = entry.key;
      var paddy = entry.value;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Paddy Type ${index + 1}', style: AppTextStyles.label),
                if (index == paddyEntries.length-1)
                  Row(
                    children: [
                      InkWell(
                        onTap: _addPaddyEntry,
                        child: Text('Add another type', style: AppTextStyles.underlineText),
                      ),
                      AppDimensions.w10(context),
                      if (paddyEntries.length > 1)
                        IconButton(
                          onPressed: () => _removePaddyEntry(index),
                          icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
                        ),
                    ],
                  ),

              ],
            ),
            _buildDropdown(
              selectedValue: paddy['type'],
              onChanged: (val) {
                setState(() => paddy['type'] = val);
              },
            ),
            AppDimensions.h10(context),
            Text('Weight', style: AppTextStyles.label),
            AppDimensions.h5(context),
            CustomTextFormField(
              controller: paddy['weightController'],
              hintText: 'Enter weight',
            ),
            AppDimensions.h10(context),
            Text('Amount', style: AppTextStyles.label),
            AppDimensions.h5(context),
            CustomTextFormField(
              controller: paddy['amountController'],
              hintText: 'Amount (auto calculate)',
              isReadOnly: true,
            ),
            AppDimensions.h10(context),
            Container(height: 1, color: AppColors.borderColor.withOpacity(0.5)),
          ],
        ),
      );
    }).toList();
  }

  // --- REUSABLE DROPDOWN ---
  Widget _buildDropdown({String? selectedValue, required ValueChanged<String?> onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          hint: Text('Select Paddy Type', style: AppTextStyles.hintText),
          items: paddyTypes
              .map((type) => DropdownMenuItem<String>(
            value: type,
            child: Text(type, style: AppTextStyles.hintText),
          ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // --- ADD NEW DEDUCTION FIELD ---
  void _addDeductionField() {
    setState(() {
      deductions.add({
        'label': 'Deduction ${deductions.length + 1}',
        'controller': TextEditingController(),
      });
    });
  }

  // --- REMOVE DEDUCTION FIELD ---
  void _removeDeduction(int index) {
    setState(() {
      deductions.removeAt(index);
    });
  }

  // --- BUILD DEDUCTIONS ---
  List<Widget> _buildDynamicDeductions() {
    return deductions.asMap().entries.map((entry) {
      int index = entry.key;
      var deduction = entry.value;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: CustomTextFormField(
                hintText: deduction['label'],
                controller: deduction['controller'],
              ),
            ),
            AppDimensions.w10(context),
            IconButton(
              icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
              onPressed: () => _removeDeduction(index),
            ),
          ],
        ),
      );
    }).toList();
  }
}
