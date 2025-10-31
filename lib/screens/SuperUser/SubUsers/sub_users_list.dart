import 'package:flutter/material.dart';
import 'package:shree_ram_staff/Utils/image_assets.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../utils/app_routes.dart';
import '../../../widgets/CustomCards/SuperUser/sub_user_card.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/reusable_functions.dart';

class SubUsersList extends StatefulWidget {
  const SubUsersList({super.key});

  @override
  State<SubUsersList> createState() => _SubUsersListState();
}

class _SubUsersListState extends State<SubUsersList> {
  TextEditingController searchController = TextEditingController();
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
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(
        isHomePage: false,
        title: 'Sub User',
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
              children: [
                // Custom search field
                Row(
                  children: [
                    Expanded(
                      child: ReusableSearchField(
                        controller: searchController,
                        hintText: 'Search by name',
                        onChanged: (value) {
                          // handle search logic
                        },
                      ),
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
                  ],
                ),
                AppDimensions.h20(context),

                Expanded(
                  child: ListView.builder(
                    itemCount: homeCardsData.length,
                    itemBuilder: (context, index) {
                      final data = homeCardsData[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.staffDetails,
                              arguments: null,
                            );
                          },
                          child: SubUserCard(
                            name: data!['name'],
                            date: data['date']!,
                            position: 'Manager',
                            phone: '+91 9829891143',
                            qcType: 'initialQC',
                            height: height,
                            width: width,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            CustomFAB(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.createSubUserPage,
                  arguments: null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
