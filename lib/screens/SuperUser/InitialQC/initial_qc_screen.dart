import 'package:flutter/material.dart';
import 'package:shree_ram_staff/widgets/custom_app_bar.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../Utils/image_assets.dart';
import '../../../utils/app_routes.dart';
import '../../../widgets/CustomCards/homeInfoCard.dart';
import '../../../widgets/reusable_functions.dart';

class InitialQcScreen extends StatefulWidget {
  const InitialQcScreen({super.key});

  @override
  State<InitialQcScreen> createState() => _InitialQcScreenState();
}

class _InitialQcScreenState extends State<InitialQcScreen> {
  TextEditingController searchController = TextEditingController();
  DateTimeRange? selectedDateRange;

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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(title: 'Initial QC', preferredHeight: height * 0.12),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.035,
          vertical: height * 0.015,
        ),
        child: Column(
          children: [
            ReusableSearchField(
              controller: searchController,
              hintText: 'Search by Truck No./Farmer/Broker',
              onChanged: (value) {
                // handle search logic
              },
            ),

            AppDimensions.h20(context),
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
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 10),
                itemCount: homeCardsData.length,
                itemBuilder: (context, index) {
                  final data = homeCardsData[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.billingFillDetailsScreen,
                          arguments: null,
                        );
                      },
                      child: HomeInfoCard(
                        cardType: CardType.initialQC,
                        farmerName: data!['name'],
                        date: data['date']!,
                        vehicleNumber: data['vehicleNumber'],
                        brokerName: data['driverName'],
                        staffName: 'Ram',
                        height: height,
                        width: width,
                        status: '',
                        isSuperUser: true,
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.initialQcApprovalScreen,
                            arguments: null,
                          );
                        },
                      ),
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
