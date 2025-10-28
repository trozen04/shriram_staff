import 'package:flutter/material.dart';
import 'package:shree_ram_staff/widgets/custom_app_bar.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../Utils/image_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_routes.dart';
import '../../../utils/flutter_font_styles.dart';
import '../../../widgets/CustomCards/homeInfoCard.dart';
import '../../../widgets/reusable_functions.dart';

class InitialQcScreen extends StatefulWidget {
  const InitialQcScreen({super.key});

  @override
  State<InitialQcScreen> createState() => _InitialQcScreenState();
}

class _InitialQcScreenState extends State<InitialQcScreen> {
  TextEditingController searchController = TextEditingController();
  DateTime? selectedDate = DateTime.now();


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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(title: 'Initial QC', preferredHeight: height * 0.12),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.035, vertical: height * 0.015),
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
                  _buildIconContainer(
                    text: 'Date',
                    imagePath: ImageAssets.calender,
                    width: width,
                    height: height,
                    onTap: () => _pickDate(),
                  ),

                  SizedBox(width: width * 0.045),

                  _buildIconContainer(
                    text: 'Factory',
                    imagePath: ImageAssets.factoryPNG,
                    width: width,
                    height: height,
                    onTap: () {},
                  ),

                  SizedBox(width: width * 0.045),

                  _buildIconContainer(
                    text: 'Filter',
                    iconData: Icons.tune,
                    width: width,
                    height: height,
                    onTap: () {},
                  ),


                ],
              ),

            ),
            AppDimensions.h20(context),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(homeCardsData.length, (index) {
                final data = homeCardsData[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.billingFillDetailsScreen, arguments: null);
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
                      isPending: false,
                      isSuperUser: true,
                      onPressed: (){
                        Navigator.pushNamed(context, AppRoutes.initialQcApprovalScreen, arguments: null);
                      },
                    ),

                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
  Widget _buildIconContainer({
    required String text,
    String? imagePath,
    IconData? iconData,
    required double width,
    required double height,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.065,
          vertical: height * 0.015,
        ),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.16),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Text(text, style: AppTextStyles.dateText),
            AppDimensions.w10(context),
            if (imagePath != null)
              Image.asset(
                imagePath,
                height: height * 0.02,
              )
            else if (iconData != null)
              Icon(
                iconData,
                size: height * 0.022,
                color: AppColors.primaryColor,
              ),
          ],
        ),
      ),
    );
  }
}
