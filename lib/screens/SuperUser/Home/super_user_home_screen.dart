import 'package:flutter/material.dart';
import 'package:shree_ram_staff/utils/app_colors.dart';
import 'package:shree_ram_staff/utils/flutter_font_styles.dart';
import 'package:shree_ram_staff/utils/image_assets.dart';
import 'package:shree_ram_staff/widgets/custom_app_bar.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../utils/app_routes.dart';
import '../../../widgets/reusable_functions.dart';

class SuperUserHomeScreen extends StatefulWidget {
  const SuperUserHomeScreen({super.key});

  @override
  State<SuperUserHomeScreen> createState() => _SuperUserHomeScreenState();
}

class _SuperUserHomeScreenState extends State<SuperUserHomeScreen> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final reportData = [
      {'item': 'Paddy', 'qtyIn': '33 Qntl', 'qtyOut': '13 Qntl', 'stockLeft': '20 Qntl'},
      {'item': 'Paddy', 'qtyIn': '33 Qntl', 'qtyOut': '13 Qntl', 'stockLeft': '20 Qntl'},
      {'item': 'Paddy', 'qtyIn': '33 Qntl', 'qtyOut': '13 Qntl', 'stockLeft': '20 Qntl'},
      {'item': 'Paddy', 'qtyIn': '33 Qntl', 'qtyOut': '13 Qntl', 'stockLeft': '20 Qntl'},
      {'item': 'Paddy', 'qtyIn': '33 Qntl', 'qtyOut': '13 Qntl', 'stockLeft': '20 Qntl'},
    ];

    return Scaffold(
      appBar: CustomAppBar(
        isHomePage: true,
        title: 'Home',
        superUser: true,
        preferredHeight: height * 0.15,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: width * 0.035, vertical: height * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: width * 0.02,
              mainAxisSpacing: height * 0.02,
              childAspectRatio: 1.25,
              children: [
                ActionButton(
                  title: 'Sub Users',
                  imagePath: ImageAssets.subUsers,
                  ontap: () {
                    Navigator.pushNamed(context, AppRoutes.subUsersList);
                  },
                ),
                ActionButton(
                  title: 'Purchase Request',
                  imagePath: ImageAssets.purchaseRequest,
                  ontap: () {
                    //Navigator.pushNamed(context, AppRoutes.deliveryPage);
                  },
                ),
                ActionButton(
                  title: 'Initial QC',
                  imagePath: ImageAssets.qc,
                  ontap: () {
                    //Navigator.pushNamed(context, AppRoutes.deliveryPage, arguments: true);
                  },
                ),
                ActionButton(
                  title: 'Attendance',
                  imagePath: ImageAssets.attendance,
                  ontap: () {
                    //Navigator.pushNamed(context, AppRoutes.deliveryPage, arguments: true);
                  },
                ),
                ActionButton(
                  title: 'Sales',
                  imagePath: ImageAssets.sales,
                  ontap: () {
                    Navigator.pushNamed(context, AppRoutes.salesScreen, arguments: null);
                  },
                ),
                ActionButton(
                  title: 'Factory',
                  imagePath: ImageAssets.factory,
                  ontap: () {
                    Navigator.pushNamed(context, AppRoutes.factoryScreen, arguments: null);
                  },
                ),
                ActionButton(
                  title: 'Expense',
                  imagePath: ImageAssets.expense,
                  ontap: () {
                    Navigator.pushNamed(context, AppRoutes.factoryScreen, arguments: null);
                  },
                ),
                ActionButton(
                  title: 'Billing',
                  imagePath: ImageAssets.billing,
                  ontap: () {
                    Navigator.pushNamed(context, AppRoutes.billingScreen);
                  },
                ),

                ActionButton(
                  title: 'Salary',
                  imagePath: ImageAssets.salary,
                  ontap: () {
                    Navigator.pushNamed(context, AppRoutes.deliveryPage);
                  },
                ),

                ActionButton(
                  title: 'Report',
                  imagePath: ImageAssets.report,
                  ontap: () {
                    // Navigator.pushNamed(context, AppRoutes.salesScreen, arguments: null);
                  },
                ),
                ActionButton(
                  title: 'Broker',
                  imagePath: ImageAssets.broker,
                  ontap: () {
                    Navigator.pushNamed(context, AppRoutes.reportScreen, arguments: null);
                  },
                ),
                ActionButton(
                  title: 'Labour',
                  imagePath: ImageAssets.labour,
                  ontap: () {
                    Navigator.pushNamed(context, AppRoutes.reportScreen, arguments: null);
                  },
                ),
                ActionButton(
                  title: 'Products',
                  imagePath: ImageAssets.broker,
                  ontap: () {
                    Navigator.pushNamed(context, AppRoutes.reportScreen, arguments: null);
                  },
                ),

              ],
            ),
            AppDimensions.h20(context),
            Text(
              'Report',
              style: AppTextStyles.appbarTitle,
            ),
            AppDimensions.h10(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) setState(() => selectedDate = pickedDate);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.015),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.16),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          selectedDate == null
                              ? 'Date'
                              : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                          style: AppTextStyles.dateText,
                        ),
                        AppDimensions.w10(context),
                        Icon(Icons.calendar_month_outlined, color: AppColors.primaryColor, size: 16),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: height * 0.05,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.055),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Factory', style: AppTextStyles.dateText),
                      AppDimensions.w10(context),
                      Image.asset(ImageAssets.factoryPNG, height: height * 0.02)
                    ],
                  ),
                ),
              ],
            ),
            AppDimensions.h20(context),
            ReportTable(data: reportData),
            AppDimensions.h20(context),
          ],
        ),
      ),
    );
  }
}
