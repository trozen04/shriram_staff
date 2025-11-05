import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../Utils/image_assets.dart';
import '../../../utils/app_routes.dart';
import '../../../utils/flutter_font_styles.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/reusable_functions.dart';

class LabourScreen extends StatefulWidget {
  const LabourScreen({super.key});

  @override
  State<LabourScreen> createState() => _LabourScreenState();
}

class _LabourScreenState extends State<LabourScreen> {
  TextEditingController searchController = TextEditingController();
  DateTimeRange? selectedDateRange;

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

  // Fixed formatAmount function
  String formatAmount(dynamic amount) {
    if (amount == null) return '';
    try {
      final number = amount is String
          ? double.parse(amount)
          : amount.toDouble();
      final formatter = NumberFormat('#,##0', 'en_IN');
      return '₹ ${formatter.format(number)}';
    } catch (e) {
      return '₹ ${amount.toString()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(
        isHomePage: false,
        title: 'Labour',
        preferredHeight: height * 0.12,
      ),
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
                ReusableSearchField(
                  controller: searchController,
                  hintText: 'Search by Labour',
                  onChanged: (value) {},
                ),
                AppDimensions.h20(context),

                // Date picker + Filter row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      CustomIconButton(
                        text: formatDateRange(selectedDateRange),
                        imagePath: ImageAssets.calender,
                        width: width,
                        height: height,
                        onTap: () => _pickDate(),
                      ),
                      AppDimensions.w10(context),
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
                      AppDimensions.w10(context),
                      CustomIconButton(
                        text: 'Filter',
                        iconData: Icons.tune,
                        onTap: () {},
                        showIconOnRight: true,
                      ),
                    ],
                  ),
                ),

                if (selectedDateRange != null) ...[
                  AppDimensions.h20(context),
                  Text(
                    formatDateRange(selectedDateRange),
                    style: AppTextStyles.appbarTitle,
                  ),
                ],

                AppDimensions.h20(context),

                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width:
                          width * 1.2, // allows horizontal overflow for columns
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Row
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'Item Name',
                                  style: AppTextStyles.bodyText,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Unit',
                                  style: AppTextStyles.bodyText,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Price/U',
                                  style: AppTextStyles.bodyText,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'Amount',
                                  style: AppTextStyles.bodyText,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Extra',
                                  style: AppTextStyles.bodyText,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'Total',
                                  style: AppTextStyles.bodyText,
                                ),
                              ),
                            ],
                          ),

                          AppDimensions.h10(context),

                          // The vertical scrolling list (safe to use Expanded here)
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // List of items
                                  ...List.generate(5, (index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8.0,
                                      ),
                                      child: Row(
                                        children: [
                                          const Expanded(
                                            flex: 3,
                                            child: Text('Rice'),
                                          ),
                                          const Expanded(
                                            flex: 2,
                                            child: Text('21'),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(formatAmount(2.5)),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(formatAmount(7500)),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(formatAmount(175)),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(formatAmount(7675)),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                  AppDimensions.h10(context),

                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width -
                                          (width *
                                              0.07), // subtract total horizontal padding
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Grand Total',
                                          style: AppTextStyles.grandTotalText,
                                        ),
                                        Text(
                                          formatAmount(17500),
                                          style: AppTextStyles.bodyText,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                AppDimensions.h20(context),
              ],
            ),

            // FAB (floating button) positioned above the Column
            CustomFAB(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.addLabourChargesScreen);
              },
            ),
          ],
        ),
      ),
    );
  }
}
