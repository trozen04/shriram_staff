import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shree_ram_staff/widgets/CustomCards/sales_card.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_routes.dart';
import '../../../widgets/CustomCards/homeInfoCard.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/reusable_functions.dart';
import '../../../utils/flutter_font_styles.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  TextEditingController searchController = TextEditingController();
  DateTime? selectedDate;
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
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _addNewLead() {
    // Navigator.pushNamed(context, AppRoutes.addNewPurchaseRequestPage);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(
        isHomePage: false,
        title: 'Sales',
        preferredHeight: height * 0.12,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: width * 0.035, vertical: height * 0.015),
        child: Column(
          children: [
            // Custom search field
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search by Farmer Name/City/Town',
                hintStyle: AppTextStyles.searchFieldFont,
                prefixIcon: const Icon(Icons.search, color: AppColors.primaryColor,),
                filled: true,
                fillColor: AppColors.primaryColor.withOpacity(0.16),
                contentPadding: EdgeInsets.symmetric(horizontal: width * 0.035, vertical: height * 0.01),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(61),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            AppDimensions.h20(context),

            // Date picker and Add New Leads button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Date button
                CustomRoundedButton(
                  onTap: _pickDate,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        selectedDate != null
                            ? DateFormat('dd-MM-yy').format(selectedDate!)
                            : 'Date',
                        style: AppTextStyles.dateText,
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.calendar_month_outlined, color: AppColors.primaryColor),
                    ],
                  ),
                ),

                // Add New Leads button
                CustomRoundedButton(
                  onTap: _addNewLead,
                  child: Text(
                    'Add New Leads',
                    style: AppTextStyles.dateText,
                  ),
                ),
              ],
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
                      Navigator.pushNamed(context, AppRoutes.loadingProductScreen, arguments: null);
                    },
                    child: SalesCard(
                      name: data!['name'],
                      date: data['date']!,
                      address: '112/22, Ram Colony',
                      city: 'Gorakhpur',
                      height: height,
                      width: width,
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
}
