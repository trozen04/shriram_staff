import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../Utils/image_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_routes.dart';
import '../../../widgets/CustomCards/homeInfoCard.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/reusable_functions.dart';
import '../../../utils/flutter_font_styles.dart';

class BillingScreen extends StatefulWidget {
  final bool? isSuperUser;
  const BillingScreen({super.key, this.isSuperUser = false});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  TextEditingController searchController = TextEditingController();
  DateTime? selectedDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    developer.log('issuperUser: ${widget.isSuperUser}');
  }

  dynamic homeCardsData = [
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
        title: 'Billing',
        preferredHeight: height * 0.12,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.035, vertical: height * 0.015),
        child: Column(
          children: [
            // Custom search field
            ReusableSearchField(
              controller: searchController,
              hintText: 'Search Sample No./Farmer/Broker',
              onChanged: (value) {

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
                    CustomRoundedButton(
                      onTap: _pickDate,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            formatDate(selectedDate),
                            style: AppTextStyles.dateText,
                          ),
                          const SizedBox(width: 8),
                          Image.asset(ImageAssets.calender, height: height * 0.025),
                        ],
                      ),
                    ),
                    if (widget.isSuperUser!) ...[
                      SizedBox(width: width * 0.045),
                      CustomRoundedButton(
                        onTap: () {},
                        child: Row(
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
                itemCount: homeCardsData.length,
                itemBuilder: (context, index) {
                  final data = homeCardsData[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: HomeInfoCard(
                      cardType: CardType.billing,
                      farmerName: data!['name'],
                      date: data['date']!,
                      vehicleNumber: data['vehicleNumber'],
                      brokerName: data['driverName'],
                      height: height,
                      width: width,
                      onPressed: () {
                        widget.isSuperUser!
                            ?
                            //if pending then fill details else another (maybe)
                        Navigator.pushNamed(
                          context,
                          AppRoutes.billingFillDetailsSuperUser,
                        )
                        // Navigator.pushNamed(
                        //   context,
                        //   AppRoutes.billingDetailScreenSuperUser,
                        // )
                            : Navigator.pushNamed(
                          context,
                          AppRoutes.billingFillDetailsScreen,
                          arguments: null,
                        );
                        //if pending is false
                        // Navigator.pushNamed(
                        //   context,
                        //   AppRoutes.billingDetailsScreen,
                        //   arguments: null,
                        // );
                      },
                      isPending: true,
                      isSuperUser: widget.isSuperUser ?? false,
                    ),
                  );
                },
              ),
            )


          ],
        ),
      ),
    );
  }
}
