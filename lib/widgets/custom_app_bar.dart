import 'package:flutter/material.dart';
import '../Constants/app_dimensions.dart';
import '../Utils/image_assets.dart';
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';
import '../utils/flutter_font_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isHomePage;
  final bool? superUser;
  final double preferredHeight;

  const CustomAppBar({
    super.key,
    required this.title,
    this.isHomePage = false,
    this.superUser = false,
    required this.preferredHeight,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return PreferredSize(
      preferredSize: Size.fromHeight(preferredHeight),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(screenHeight * 0.035),
          bottomRight: Radius.circular(screenHeight * 0.035),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: AppGradients.purpleGradient,
          ),
          padding: EdgeInsets.only(
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            bottom: screenHeight * 0.03,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end, // sticks content to bottom
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isHomePage)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left side: icon + greeting
                    Row(
                      children: [
                        Image.asset(
                          ImageAssets.homeScreenIcon,
                          width: screenWidth * 0.09,
                          height: screenWidth * 0.09,
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if(!superUser!)
                            Text(
                              'Good Morning',
                              style: AppTextStyles.bodyText.copyWith(
                                color: Colors.white
                              ),
                            ),
                            Text(
                              'Rahul Sharma',
                              style: AppTextStyles.appbarName
                            ),
                            if(superUser!)
                              Text(
                                  'Worker',
                                  style: AppTextStyles.appbarName
                              ),
                          ],
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.notificationScreen);
                          },
                          child: Image.asset(
                            ImageAssets.homeScreenNotificationIcon,
                            width: screenWidth * 0.1,
                            height: screenWidth * 0.1,
                          ),
                        ),
                        AppDimensions.w10(context),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.profileScreen, arguments: superUser);
                          },
                          child: Image.asset(
                            ImageAssets.profileImage,
                            width: screenWidth * 0.1,
                            height: screenWidth * 0.1,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              else
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Image.asset(
                      ImageAssets.backButton,
                      color: Colors.white,
                      width: screenWidth * 0.1,
                    ),
                  ),

                  // Spacer to center the title
                  Expanded(
                    child: Center(
                      child: Text(
                        title,
                        style: AppTextStyles.buttonText,
                      ),
                    ),
                  ),

                  // Optional: if you want right side empty to keep title centered
                  const SizedBox(width: 48), // same width as IconButton
                ],
              )

            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(preferredHeight);
}
