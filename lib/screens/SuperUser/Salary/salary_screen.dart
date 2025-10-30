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
  final salaryDetails = [
    {
      'Staff Name': 'Mohan',
      'Present': '26 Days',
      'Total Salary': 20000,
      'Salary Paid': 15000,
      'Salary Left': 5000,
    },
    {
      'Staff Name': 'Ramesh',
      'Present': '24 Days',
      'Total Salary': 18000,
      'Salary Paid': 10000,
      'Salary Left': 8000,
    },
    {
      'Staff Name': 'Suresh',
      'Present': '28 Days',
      'Total Salary': 22000,
      'Salary Paid': 20000,
      'Salary Left': 2000,
    },
    {
      'Staff Name': 'Rajesh',
      'Present': '20 Days',
      'Total Salary': 16000,
      'Salary Paid': 12000,
      'Salary Left': 4000,
    },
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

                  _buildIconContainer(Icons.calendar_month_outlined, width, height, _pickDate),

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

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: width * 1.1), // ensures proper width
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(1.8),
                    1: FlexColumnWidth(1.2),
                    2: FlexColumnWidth(1.6),
                    3: FlexColumnWidth(1.6),
                    4: FlexColumnWidth(1.6),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    // ✅ Header Row
                    TableRow(
                      children: [
                        _headerCell('Staff Name'),
                        _headerCell('Present'),
                        _headerCell('Total Salary'),
                        _headerCell('Salary Paid'),
                        _headerCell('Salary Left'),
                      ],
                    ),

                    // ✅ Data Rows
                    ...salaryDetails.map((row) => TableRow(
                      children: [
                        _cell(row['Staff Name'].toString()),
                        _cell(row['Present'].toString()),
                        _cell(row['Total Salary'].toString()),
                        _cell(row['Salary Paid'].toString()),
                        _cell(row['Salary Left'].toString()),
                      ],
                    )),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
  Widget _buildIconContainer(IconData icon, double width, double height, final VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.065, vertical: height * 0.015),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.16),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(icon, color: AppColors.primaryColor),
      ),
    );
  }


  Widget _headerCell(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
    child: Text(text, style: AppTextStyles.bodyText),
  );

  Widget _cell(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
    child: Text(
      text,
      style: AppTextStyles.bodyText.copyWith(color: AppColors.opacityColorBlack),
      overflow: TextOverflow.ellipsis,
    ),
  );

}
