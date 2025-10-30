import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shree_ram_staff/utils/image_assets.dart';
import 'package:shree_ram_staff/widgets/CustomCards/sales_card.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_routes.dart';
import '../../../widgets/CustomCards/homeInfoCard.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/reusable_functions.dart';
import '../../../utils/flutter_font_styles.dart';

class SalesScreen extends StatefulWidget {
  final bool? isSuperUser;
  const SalesScreen({super.key, this.isSuperUser = false});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  TextEditingController searchController = TextEditingController();
  DateTime? selectedDate;
  dynamic salesData = [
    {
      'name': 'Suresh Kumar',
      'date': '21-09-25',
      'location': 'Lucknow, UP',
      'quantity': '30 Qntl',
      'item': 'Wheat',
      'price': '15,000',
      'vehicleNumber': 'DL 12 AB 2198',
      'driverName': 'Sunil Pal',
    },
    {
      'name': 'Suresh Kumar',
      'date': '21-09-25',
      'location': 'Lucknow, UP',
      'quantity': '30 Qntl',
      'item': 'Wheat',
      'price': '15,000',
      'vehicleNumber': 'DL 12 AB 2198',
      'driverName': 'Sunil Pal',
    },
  ];
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        isHomePage: false,
        title: 'Sales',
        preferredHeight: height * 0.12,
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.035, vertical: height * 0.015),
            child: Column(
              children: [
                // Custom search field
                ReusableSearchField(
                  controller: searchController,
                  hintText: 'Search by Truck No./Farmer/Broker',
                  onChanged: (value) {
                    // handle search logic
                  },
                ),
                AppDimensions.h20(context),

                // Date picker and Add New Leads button
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width - (width * 0.07), // subtract total horizontal padding
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Date Button
                        CustomRoundedButton(
                          onTap: _pickDate,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                formatDate(selectedDate),
                                style: AppTextStyles.dateText,
                              ),
                              const SizedBox(width: 8),
                              Image.asset(ImageAssets.calender, height: height * 0.025),                            ],
                          ),
                        ),

                        if (widget.isSuperUser!) ...[
                          SizedBox(width: width * 0.045),

                          CustomRoundedButton(
                            onTap: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Factory', style: AppTextStyles.dateText),
                                const SizedBox(width: 8),
                                Image.asset(ImageAssets.factoryPNG, height: 20),
                              ],
                            ),
                          ),
                          SizedBox(width: width * 0.045),

                        ],

                        CustomRoundedButton(
                          onTap: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Filter', style: AppTextStyles.dateText),
                              AppDimensions.w10(context),
                              Icon(Icons.tune, color: AppColors.primaryColor),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                AppDimensions.h20(context),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 10),
                    itemCount: salesData.length,
                    itemBuilder: (context, index) {
                      final data = salesData[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          onTap: widget.isSuperUser!
                              ? () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.salesDetailScreen,
                              arguments: null,
                            );
                          }
                              : () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.loadingProductScreen,
                              arguments: null,
                            );
                          },
                          child: SalesCard(
                            name: data!['name'],
                            date: data['date']!,
                            address: '112/22, Ram Colony',
                            city: 'Gorakhpur',
                            height: height,
                            width: width,
                            staffName: 'Ram',
                            isPending: true,
                          ),
                        ),
                      );
                    },
                  ),
                )



              ],
            ),
          ),
          if(widget.isSuperUser!)
            CustomFAB(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.createSalesLeadScreen);
              },
            ),
        ],
      ),
    );
  }
}
