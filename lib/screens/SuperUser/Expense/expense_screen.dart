import 'package:flutter/material.dart';
import 'package:shree_ram_staff/widgets/custom_app_bar.dart';
import 'package:intl/intl.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../Utils/image_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_routes.dart';
import '../../../utils/flutter_font_styles.dart';
import '../../../widgets/expensePopUp.dart';
import '../../../widgets/reusable_functions.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  DateTime? _fromDate;
  DateTime? _toDate;
  DateTime? selectedDate  = DateTime.now();

  // ✅ Example dynamic expense data list
  final dynamic expenses = [
    {'reason': 'Money Lend', 'amount': 2200},
    {'reason': 'Money Lend', 'amount': 2200},
    {'reason': 'Office Supplies', 'amount': 1500},
    {'reason': 'Fuel Expense', 'amount': 800},
  ];

  void _pickDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDateRange: selectedDate != null
          ? DateTimeRange(start: selectedDate!, end: selectedDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor, // header & selection color
              onPrimary: Colors.white, // text on selected color
              onSurface: Colors.black, // default text color
            ),
            dialogBackgroundColor: Colors.white, // ✅ make dialog white
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked.start;
        _fromDate = picked.start;
        _toDate = picked.end;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Expense', preferredHeight: height * 0.12),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.035, vertical: height * 0.015),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Date and Factory buttons
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomRoundedButton(
                      onTap: _pickDateRange,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _fromDate != null && _toDate != null
                                ? '${DateFormat('dd-MM-yy').format(_fromDate!)} → ${DateFormat('dd-MM-yy').format(_toDate!)}'
                                : 'Select Dates',
                            style: AppTextStyles.dateText,
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.calendar_month_outlined,
                            color: AppColors.primaryColor,
                            size: height * 0.02,
                          ),
                        ],
                      ),
                    ),

                    AppDimensions.w20(context),
                    CustomRoundedButton(
                      onTap: () {},
                      child: Row(
                        children: [
                          Text('Factory', style: AppTextStyles.dateText),
                          const SizedBox(width: 8),
                          Image.asset(ImageAssets.factoryPNG, height: height * 0.02),
                        ],
                      ),
                    ),
                  ],
                ),

                AppDimensions.h20(context),

                // 🔹 Date Heading
                if(_fromDate != null && _toDate != null)
                Text(
                  '${DateFormat('dd MMM yyyy').format(_fromDate!)}  →  ${DateFormat('dd MMM yyyy').format(_toDate!)}',
                  style: AppTextStyles.appbarTitle,
                ),

                // 🔹 Header Row
                ProfileRow(label: 'Reason', value: 'Amount'),

                // 🔹 Dynamic Expense List
                Expanded(
                  child: ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final item = expenses[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item['reason'], style: AppTextStyles.profileDataText),
                            Text(formatAmount(item['amount']), style: AppTextStyles.profileDataText),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            CustomFAB(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => ExpensePopup(
                    onSubmit: (amount, reason) {
                      print('Amount: $amount, Reason: $reason');
                      // Add to list or API call
                    },
                  ),
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}
