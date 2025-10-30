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

class DeliveryQcPage extends StatefulWidget {
  final bool isQCPage;
  const DeliveryQcPage({super.key, this.isQCPage = false});

  @override
  State<DeliveryQcPage> createState() => _DeliveryQcPageState();
}

class _DeliveryQcPageState extends State<DeliveryQcPage> {
  TextEditingController searchController = TextEditingController();
  DateTime? selectedDate;

  final dynamic deliveryData = [
    {
      'name': 'Suresh Kumar',
      'date': '21-09-25',
      'location': 'Lucknow, UP',
      'quantity': '30 Qntl',
      'item': 'Wheat',
      'price': '15000', // number only
      'vehicleNumber': 'DL 12 AB 2198',
      'driverName': 'Sunil Pal',
    },
    {
      'name': 'Ramesh Patel',
      'date': '21-09-25',
      'location': 'Kanpur, UP',
      'quantity': '25 Qntl',
      'item': 'Rice',
      'price': '12000', // number only
      'vehicleNumber': 'UP 32 MN 5678',
      'driverName': 'Amit Yadav',
    },
  ];
  final dynamic qcData = [

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
        title: widget.isQCPage ? 'Final Quality Check' : 'Deliveries',
        preferredHeight: height * 0.12,
      ),
      body: Padding(
        padding:
        EdgeInsets.symmetric(horizontal: width * 0.035, vertical: height * 0.015),
        child: Column(
          children: [
            // 🔍 Search field
            ReusableSearchField(
              controller: searchController,
              hintText: widget.isQCPage
                  ? 'Search Sample No./Farmer/Broker'
                  : 'Search by Truck No./Farmer/Broker',
              onChanged: (value) {},
            ),
            AppDimensions.h20(context),

            // 📅 Date picker & Filter
            Row(
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
                CustomRoundedButton(
                  onTap: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Filter',
                        style: AppTextStyles.dateText,
                      ),
                      AppDimensions.w10(context),
                      Icon(Icons.tune, color: AppColors.primaryColor),
                    ],
                  ),
                ),
              ],
            ),
            AppDimensions.h20(context),

            // 📋 List of Cards (scrollable)
            Expanded(
              child: ListView.builder(
                itemCount: deliveryData.length,
                itemBuilder: (context, index) {
                  final data = deliveryData[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: HomeInfoCard(
                      cardType:
                      widget.isQCPage ? CardType.qc : CardType.delivery,
                      farmerName: data['name'] ?? '',
                      date: data['date'] ?? '',
                      vehicleNumber: data['vehicleNumber'] ?? '',
                      brokerName: data['driverName'] ?? '',
                      height: height,
                      width: width,
                      isPending: true,
                      onPressed: () {
                        if (widget.isQCPage) {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.deliveryDetailPage,
                            arguments: {
                              'data': data,
                              'isPendingQC': true,
                            },
                          );
                        } else {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.deliveryDetailPage,
                            arguments: {
                              'data': data,
                              'isAfterQC': false,
                            },
                          );
                        }
                      },
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
