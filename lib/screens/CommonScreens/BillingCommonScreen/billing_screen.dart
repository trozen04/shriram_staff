import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../Utils/image_assets.dart';
import '../../../utils/app_routes.dart';
import '../../../widgets/CustomCards/homeInfoCard.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/reusable_functions.dart';

class BillingScreen extends StatefulWidget {
  final bool? isSuperUser;
  const BillingScreen({super.key, this.isSuperUser = false});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  TextEditingController searchController = TextEditingController();
  DateTimeRange? selectedDateRange;

  @override
  void initState() {
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(
        isHomePage: false,
        title: 'Billing',
        preferredHeight: height * 0.12,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.035,
          vertical: height * 0.015,
        ),
        child: Column(
          children: [
            // Custom search field
            ReusableSearchField(
              controller: searchController,
              hintText: 'Search Sample No./Farmer/Broker',
              onChanged: (value) {},
            ),

            AppDimensions.h20(context),

            // Date picker and Add New Leads button
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth:
                      MediaQuery.of(context).size.width -
                      (width * 0.07), // subtract total horizontal padding
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIconButton(
                      text: formatDateRange(selectedDateRange),
                      imagePath: ImageAssets.calender,
                      width: width,
                      height: height,
                      onTap: () => _pickDate(),
                    ),
                    if (widget.isSuperUser!) ...[
                      SizedBox(width: width * 0.045),
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
                      SizedBox(width: width * 0.045),
                    ],
                    CustomIconButton(
                      text: 'Filter',
                      iconData: Icons.tune,
                      onTap: () {},
                      showIconOnRight: true,
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
            ),
          ],
        ),
      ),
    );
  }
}
