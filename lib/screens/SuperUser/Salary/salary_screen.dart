import 'package:flutter/material.dart';

import '../../../Constants/app_dimensions.dart';
import '../../../Utils/image_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_routes.dart';
import '../../../utils/flutter_font_styles.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/reusable_functions.dart';

class SalaryScreen extends StatefulWidget {
  const SalaryScreen({super.key});

  @override
  State<SalaryScreen> createState() => _SalaryScreenState();
}

class _SalaryScreenState extends State<SalaryScreen> {
  DateTime? selectedDate = DateTime.now();
  void _pickDate() async {
    final DateTime? picked = await pickDate(
      context: context,
      initialDate: selectedDate,
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
  final dynamic expenses = [
    {'reason': 'Money Lend', 'amount': 2200},
    {'reason': 'Money Lend', 'amount': 2200},
    {'reason': 'Office Supplies', 'amount': 1500},
    {'reason': 'Fuel Expense', 'amount': 800},
  ];
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        isHomePage: false,
        title: 'Salary',
        preferredHeight: height * 0.12,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.035, vertical: height * 0.015),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.035, vertical: height * 0.015),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.16),
                borderRadius: BorderRadius.circular(60)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Select Factory', style: AppTextStyles.dateText),
                  Image.asset(ImageAssets.factoryPNG, height: height * 0.025)
                ],
              ),
            ),
            AppDimensions.h10(context),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildIconContainer(Icons.filter_list, width, height, (){}),
                  SizedBox(width: width * 0.045),

                  _buildIconContainer(Icons.calendar_month_outlined, width, height, () => _pickDate),

                  SizedBox(width: width * 0.045),

                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.salaryRolloutScreen);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.065, vertical: height * 0.015),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.16),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Text('Rollout Salary', style: AppTextStyles.dateText),
                          AppDimensions.w10(context),
                          Image.asset(ImageAssets.salaryPng, height: height * 0.02),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppDimensions.h30(context),
            Text(formatReadableDate(selectedDate), style: AppTextStyles.appbarTitle),
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
      ),
    );
  }
  Widget _buildIconContainer(IconData icon, double width, double height, final VoidCallback onTap) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.065, vertical: height * 0.015),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.16),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Icon(icon, color: AppColors.primaryColor),
    );
  }
}
