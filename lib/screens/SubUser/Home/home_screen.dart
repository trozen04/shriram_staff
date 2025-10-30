import 'package:flutter/material.dart';
import 'package:shree_ram_staff/utils/app_colors.dart';
import 'package:shree_ram_staff/utils/flutter_font_styles.dart';
import 'package:shree_ram_staff/utils/image_assets.dart';
import 'package:shree_ram_staff/widgets/custom_app_bar.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../utils/app_routes.dart';
import '../../../widgets/reusable_functions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? selectedDate  = DateTime.now();

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
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        isHomePage: true,
        title: 'Home',
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
                  title: 'Delivery',
                  imagePath: ImageAssets.deliveryImage,
                  ontap: () {
                    Navigator.pushNamed(context, AppRoutes.deliveryPage);
                  },
                ),
                ActionButton(
                  title: 'Final QC',
                  imagePath: ImageAssets.qc,
                  ontap: () {
                    Navigator.pushNamed(context, AppRoutes.deliveryPage, arguments: true);
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
                  title: 'Factory',
                  imagePath: ImageAssets.factory,
                  ontap: () {
                    Navigator.pushNamed(context, AppRoutes.factoryScreen, arguments: null);
                  },
                ),
                ActionButton(
                  title: 'Sales',
                  imagePath: ImageAssets.sales,
                  ontap: () {
                    Navigator.pushNamed(context, AppRoutes.salesScreen, arguments: false);
                  },
                ),
                ActionButton(
                  title: 'Report',
                  imagePath: ImageAssets.report,
                  ontap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.reportScreen,
                      arguments: {
                        'reportData': null,
                      },
                    );                  },
                ),
              ],
            ),
            AppDimensions.h20(context),
            Text(
              'Report',
              style: AppTextStyles.appbarTitle,
            ),
            AppDimensions.h10(context),
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
            AppDimensions.h20(context),
            ReportTable(data: reportData),
            AppDimensions.h20(context),
          ],
        ),
      ),
    );
  }
}
