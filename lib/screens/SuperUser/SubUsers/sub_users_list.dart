import 'package:flutter/material.dart';
import 'package:shree_ram_staff/Utils/image_assets.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_routes.dart';
import '../../../widgets/CustomCards/SuperUser/sub_user_card.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../utils/flutter_font_styles.dart';

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
  ];

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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.035, vertical: height * 0.015),
        child: Stack(
          children: [
            Column(
              children: [
                // Custom search field
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search by name',
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
                    ),
                    AppDimensions.w10(context),
                    Container(
                      height: height * 0.05,
                      padding: EdgeInsets.symmetric(horizontal: width * 0.055),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.16),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Text('Factory', style: AppTextStyles.dateText),
                          AppDimensions.w10(context),
                          Image.asset(ImageAssets.factoryPNG, height: height * 0.02,)
                        ],
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
                          Navigator.pushNamed(context, AppRoutes.staffDetails, arguments: null);
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
                  }),
                )
            
            
              ],
            ),
            Positioned(
              bottom: width * 0.05,
                right: width * 0.05,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.createSubUserPage, arguments: null);
                  },
                  child: Container(
                    padding: EdgeInsets.all(width * 0.04),
                                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle
                                ),
                    child: Icon(Icons.add, color: Colors.white,),
                              ),
                ))
          ],
        ),
      ),
    );
  }
}
