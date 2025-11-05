import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:shree_ram_staff/widgets/CustomCards/SuperUser/purchase_request_card.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../Utils/image_assets.dart';
import '../../../utils/app_routes.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/reusable_functions.dart';

class PurchaseRequestScreen extends StatefulWidget {
  const PurchaseRequestScreen({super.key});

  @override
  State<PurchaseRequestScreen> createState() => _PurchaseRequestScreenState();
}

class _PurchaseRequestScreenState extends State<PurchaseRequestScreen> {
  TextEditingController searchController = TextEditingController();
  DateTimeRange? selectedDateRange;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  dynamic purchaseRequestData = [
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
        title: 'Purchase Request',
        preferredHeight: height * 0.12,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.035,
          vertical: height * 0.015,
        ),
        child: Column(
          children: [
            // Search Field
            ReusableSearchField(
              controller: searchController,
              hintText: 'Search by Truck No./Farmer/Broker',
              onChanged: (value) {
                // handle search logic
              },
            ),

            AppDimensions.h20(context),

            // Date / Factory / Filter buttons
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
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
                  CustomIconButton(
                    text: 'Filter',
                    iconData: Icons.tune,
                    onTap: () {},
                    showIconOnRight: true,
                  ),
                ],
              ),
            ),

            AppDimensions.h20(context),

            // ✅ Only this part scrolls
            Expanded(
              child: ListView.builder(
                itemCount: purchaseRequestData.length,
                padding: const EdgeInsets.only(bottom: 10),
                itemBuilder: (context, index) {
                  final data = purchaseRequestData[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: PurchaseRequestCard(
                      farmerName: data['name'],
                      brokerName: data['brokerName'],
                      date: data['date'],
                      paddy: data['paddy'],
                      height: height,
                      width: width,
                      isPending: true,
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.purchaseRequestDetail,
                        );
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
