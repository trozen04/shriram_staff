import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shree_ram_staff/widgets/primary_and_outlined_button.dart';
import 'package:shree_ram_staff/widgets/reusable_appbar.dart';

import '../../../Constants/app_dimensions.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/flutter_font_styles.dart';
import '../../../widgets/reusable_functions.dart';

class BillingFillDetailsSuperUser extends StatefulWidget {
  const BillingFillDetailsSuperUser({super.key});

  @override
  State<BillingFillDetailsSuperUser> createState() =>
      _BillingFillDetailsSuperUserState();
}

class _BillingFillDetailsSuperUserState
    extends State<BillingFillDetailsSuperUser> {
  List<Map<String, dynamic>> billingItems = [
    {'item': '', 'weight': '', 'bags': '', 'price': '', 'amount': ''},
  ];

  List<Map<String, dynamic>> deductions = [
    {'label': 'Labor Charge', 'value': ''},
    {'label': 'Brokerage', 'value': ''},
  ];

  final TextEditingController totalAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: ReusableAppBar(title: '#22311'),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.035,
            vertical: height * 0.015,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProfileRow(label: 'Unit ID', value: '#221212'),
              const ProfileRow(label: 'Name', value: 'Ramesh Yadav'),
              const ProfileRow(label: 'Broker', value: 'Rahul'),
              const ProfileRow(label: 'Initial Weight', value: '511 Qntl'),
              const ProfileRow(label: 'Net Weight', value: '112 Qntl'),
              AppDimensions.h10(context),

              Text('Enter Billing Details', style: AppTextStyles.appbarTitle),
              AppDimensions.h10(context),

              ..._buildBillingItems(),

              AppDimensions.h20(context),
              ReusableOutlinedButton(text: 'Save', onPressed: () {}),

              AppDimensions.h20(context),

              _buildSummaryCard(height, width),

              AppDimensions.h20(context),
              Text(
                'Extra Charges to be deduct',
                style: AppTextStyles.appbarTitle,
              ),
              AppDimensions.h10(context),

              ..._buildDeductionFields(),

              GestureDetector(
                onTap: _addDeduction,
                child: Text(
                  '+ Add another deductions',
                  style: AppTextStyles.underlineText,
                ),
              ),

              AppDimensions.h20(context),
              ReusableTextField(
                label: 'Total Amount',
                hint: 'Total Amount',
                controller: totalAmountController,
                readOnly: true,
              ),

              AppDimensions.h30(context),
              PrimaryButton(text: 'Submit', onPressed: () {}),
              AppDimensions.h20(context),
            ],
          ),
        ),
      ),
    );
  }

  /// --- Helpers ---
  List<Widget> _buildBillingItems() {
    return List.generate(billingItems.length, (index) {
      final item = billingItems[index];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableTextField(
            label: 'Item Name',
            hint: 'Select Item',
            actionLabel: index == 0 ? 'Add another item' : null,
            onActionTap: index == 0 ? _addBillingItem : null,
            actionIcon: index != 0 ? Icons.remove_circle_outline : null,
            onIconTap: index != 0 ? () => _removeItemField(index) : null,
          ),
          AppDimensions.h10(context),
          ReusableTextField(label: 'Weight', hint: 'Enter Weight'),
          AppDimensions.h10(context),
          ReusableTextField(label: 'Bags', hint: 'Bags', readOnly: true),
          AppDimensions.h10(context),
          ReusableTextField(label: 'Price', hint: 'Enter Price'),
          AppDimensions.h10(context),
          ReusableTextField(
            label: 'Amount',
            hint: 'Amount (auto calculate)',
            readOnly: true,
          ),
          if (index != billingItems.length - 1) AppDimensions.h20(context),
        ],
      );
    });
  }

  void _addBillingItem() {
    setState(() {
      billingItems.add({
        'item': '',
        'weight': '',
        'bags': '',
        'price': '',
        'amount': '',
      });
    });
  }

  void _removeItemField(int index) {
    setState(() {
      billingItems.removeAt(index);
    });
  }

  Widget _buildSummaryCard(double height, double width) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.035,
        vertical: height * 0.015,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Paddy Type: A', style: AppTextStyles.bodyText),
              Text('₹ 20,000', style: AppTextStyles.bodyText),
            ],
          ),
          AppDimensions.h10(context),
          Text('Weight: 22 Qntl', style: AppTextStyles.bodyText),
          AppDimensions.h10(context),
          Text('Bags: 2', style: AppTextStyles.bodyText),
          AppDimensions.h10(context),
          Text('Price: ₹ 200', style: AppTextStyles.bodyText),
          AppDimensions.h10(context),
        ],
      ),
    );
  }

  List<Widget> _buildDeductionFields() {
    return List.generate(deductions.length, (index) {
      final deduction = deductions[index];
      final isReadOnly = deduction['readOnly'] ?? true;

      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: ReusableTextField(
          label: deduction['label'] ?? 'Deduction',
          hint: deduction['label'] ?? 'Enter Deduction',
          readOnly: isReadOnly,
          actionIcon: !isReadOnly ? Icons.remove_circle_outline : null,
          onIconTap: !isReadOnly ? () => _removeDeduction(index) : null,
        ),
      );
    });
  }

  void _addDeduction() {
    setState(() {
      deductions.add({
        'label': 'New Deduction',
        'value': '',
        'readOnly': false,
      });
    });
  }

  void _removeDeduction(int index) {
    setState(() {
      deductions.removeAt(index);
    });
  }
}
