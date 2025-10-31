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
  DateTimeRange? selectedDateRange;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final reportData = [
      {
        'item': 'Paddy',
        'qtyIn': '33 Qntl',
        'qtyOut': '13 Qntl',
        'stockLeft': '20 Qntl',
      },
      {
        'item': 'Paddy',
        'qtyIn': '33 Qntl',
        'qtyOut': '13 Qntl',
        'stockLeft': '20 Qntl',
      },
      {
        'item': 'Paddy',
        'qtyIn': '33 Qntl',
        'qtyOut': '13 Qntl',
        'stockLeft': '20 Qntl',
      },
      {
        'item': 'Paddy',
        'qtyIn': '33 Qntl',
        'qtyOut': '13 Qntl',
        'stockLeft': '20 Qntl',
      },
      {
        'item': 'Paddy',
        'qtyIn': '33 Qntl',
        'qtyOut': '13 Qntl',
        'stockLeft': '20 Qntl',
      },
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

    return Scaffold(
      appBar: CustomAppBar(
        isHomePage: true,
        title: 'Home',
        superUser: true,
        preferredHeight: height * 0.15,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.035,
          vertical: height * 0.02,
        ),
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
                    Navigator.pushNamed(
                      context,
                      AppRoutes.purchaseRequestScreen,
                    );
                  },
                ),
                ActionButton(
                  title: 'Initial QC',
                  imagePath: ImageAssets.qc,
                  ontap: () {
                    Navigator.pushNamed(context, AppRoutes.initialQcScreen);
                  },
                ),
                ActionButton(
                  title: 'Attendance',
                  imagePath: ImageAssets.attendance,
                  ontap: () {
                    Navigator.pushNamed(context, AppRoutes.attendanceScreen);
                  },
                ),
                ActionButton(
                  title: 'Sales',
                  imagePath: ImageAssets.sales,
                  ontap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.salesScreen,
                      arguments: true,
                    );
                  },
                ),
                ActionButton(
                  title: 'Factory',
                  imagePath: ImageAssets.factory,
                  ontap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.factoryScreen,
                      arguments: null,
                    );
                  },
                ),
                ActionButton(
                  title: 'Expense',
                  imagePath: ImageAssets.expense,
                  ontap: () {
                    Navigator.pushNamed(context, AppRoutes.expenseScreen);
                  },
                ),
                ActionButton(
                  title: 'Billing',
                  imagePath: ImageAssets.billing,
                  ontap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.billingScreen,
                      arguments: true,
                    );
                  },
                ),

                ActionButton(
                  title: 'Salary',
                  imagePath: ImageAssets.salary,
                  ontap: () {
                    Navigator.pushNamed(context, AppRoutes.salaryScreen);
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
                        'reportData':
                            null, // e.g. fetched data or empty list/map
                        'isSuperUser': true, // or false depending on user type
                      },
                    );
                  },
                ),
                ActionButton(
                  title: 'Broker',
                  imagePath: ImageAssets.broker,
                  ontap: () {
                    Navigator.pushNamed(context, AppRoutes.brokerScreen);
                  },
                ),
                ActionButton(
                  title: 'Labour',
                  imagePath: ImageAssets.labour,
                  ontap: () {
                    Navigator.pushNamed(context, AppRoutes.labourScreen);
                  },
                ),
                ActionButton(
                  title: 'Products',
                  imagePath: ImageAssets.broker,
                  ontap: () {
                    Navigator.pushNamed(context, AppRoutes.productMasterScreen);
                  },
                ),
              ],
            ),
            AppDimensions.h20(context),
            Text('Report', style: AppTextStyles.appbarTitle),
            AppDimensions.h10(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomIconButton(
                  text: formatDateRange(selectedDateRange),
                  imagePath: ImageAssets.calender,
                  width: width,
                  height: height,
                  onTap: () => _pickDate(),
                ),
                CustomIconButton(
                  text: 'Factory',
                  imagePath: ImageAssets.factoryPNG,
                  onTap: () {},
                  showIconOnRight: true,
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
