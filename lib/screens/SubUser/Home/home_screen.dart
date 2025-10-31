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
                    Navigator.pushNamed(
                      context,
                      AppRoutes.deliveryPage,
                      arguments: true,
                    );
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
                    Navigator.pushNamed(
                      context,
                      AppRoutes.factoryScreen,
                      arguments: null,
                    );
                  },
                ),
                ActionButton(
                  title: 'Sales',
                  imagePath: ImageAssets.sales,
                  ontap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.salesScreen,
                      arguments: false,
                    );
                  },
                ),
                ActionButton(
                  title: 'Report',
                  imagePath: ImageAssets.report,
                  ontap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.reportScreen,
                      arguments: {'reportData': null},
                    );
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
                SizedBox.shrink()
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
