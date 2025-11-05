import 'package:flutter/material.dart';
import 'package:shree_ram_staff/widgets/custom_app_bar.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../Utils/image_assets.dart';
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
  DateTimeRange? selectedDateRange;

  // ✅ Example dynamic expense data list
  final dynamic expenses = [
    {'reason': 'Money Lend', 'amount': 2200},
    {'reason': 'Money Lend', 'amount': 2200},
    {'reason': 'Office Supplies', 'amount': 1500},
    {'reason': 'Fuel Expense', 'amount': 800},
  ];

  void _pickDate() async {
    final DateTimeRange? picked = await pickDateRange(
      context: context,
      initialRange: selectedDateRange,
    );

    if (picked != null) {
      setState(() {
        selectedDateRange = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(title: 'Expense', preferredHeight: height * 0.12),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.035,
          vertical: height * 0.015,
        ),
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
                    // 🔹 Date and Factory buttons
                    CustomIconButton(
                      text: formatDateRange(selectedDateRange),
                      imagePath: ImageAssets.calender,
                      width: width,
                      height: height,
                      onTap: () => _pickDate(),
                    ),

                    AppDimensions.w20(context),
                    CustomIconButton(
                      text: 'Factory',
                      imagePath: ImageAssets.factoryPNG,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.factoryScreen,
                          arguments: null,
                        );
                      },
                      showIconOnRight: true,
                    ),
                  ],
                ),

                AppDimensions.h20(context),

                // 🔹 Date Heading
                if (selectedDateRange != null)
                  Text(
                    formatDateRange(selectedDateRange),
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
                            Text(
                              item['reason'],
                              style: AppTextStyles.profileDataText,
                            ),
                            Text(
                              formatAmount(item['amount']),
                              style: AppTextStyles.profileDataText,
                            ),
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
