import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shree_ram_staff/widgets/CustomCards/SuperUser/purchase_request_card.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../Utils/image_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_routes.dart';
import '../../../widgets/CustomCards/SuperUser/broker_card.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/reusable_functions.dart';
import '../../../utils/flutter_font_styles.dart';

class BrokerScreen extends StatefulWidget {
  const BrokerScreen({super.key});

  @override
  State<BrokerScreen> createState() => _BrokerScreenState();
}

class _BrokerScreenState extends State<BrokerScreen> {
  TextEditingController searchController = TextEditingController();
  DateTime? selectedDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  dynamic brokerData = [
    {
      'name': 'Suresh Kumar',
      'brokerName': 'Sunil Pal',
      'paddy': 'Basmati',
      'date': '21-09-25',
      'location': 'Lucknow, UP',
      'quantity': '30 Qntl',
      'item': 'Wheat',
      'price': '15,000',
      'vehicleNumber': 'DL 12 AB 2198',
    },
    {
      'name': 'Suresh Kumar',
      'brokerName': 'Sunil Pal',
      'paddy': 'Basmati',
      'date': '21-09-25',
      'location': 'Lucknow, UP',
      'quantity': '30 Qntl',
      'item': 'Wheat',
      'price': '15,000',
      'vehicleNumber': 'DL 12 AB 2198',
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
      appBar: CustomAppBar(
        isHomePage: false,
        title: 'Broker',
        preferredHeight: height * 0.12,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.035, vertical: height * 0.015),
        child: Column(
          children: [
            // Custom search field
            ReusableSearchField(
              controller: searchController,
              hintText: 'Search by Broker',
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
                    CustomRoundedButton(
                      onTap: _pickDate,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            selectedDate != null
                                ? DateFormat('dd-MM-yy').format(selectedDate!)
                                : 'Date',
                            style: AppTextStyles.dateText,
                          ),
                          const SizedBox(width: 8),
                          Image.asset(ImageAssets.calender, height: height * 0.025),
                        ],
                      ),
                    ),
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(brokerData.length, (index) {
                    final data = brokerData[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: BrokerCard(
                        brokerName: 'Suresh Traders',
                        contactNumber: '+91 9828821922',
                        date: '28-09-2025',
                        paddy: 'Basmati 1121',
                        height: height,
                        width: width,
                        isPending: true,
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.brokerDetailScreen);
                        },
                      ),
                    );

                  }),
                ),
              ),
            )


          ],
        ),
      ),
    );
  }
}
