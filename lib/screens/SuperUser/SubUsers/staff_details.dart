import 'package:flutter/material.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../Utils/image_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_routes.dart';
import '../../../utils/flutter_font_styles.dart';
import '../../../widgets/reusable_appbar.dart';
import '../../../widgets/reusable_functions.dart';

class StaffDetails extends StatelessWidget {
  final dynamic subUserData;
  const StaffDetails({super.key, required this.subUserData});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: ReusableAppBar(title: 'Ram'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.035,
          vertical: height * 0.015,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FittedBox(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.createSubUserPage,
                    arguments: null,
                  );
                },
                child: Container(
                  height: height * 0.05,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.055),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withAlpha((0.16 * 255).toInt()),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: [
                      Text('Edit', style: AppTextStyles.dateText),
                      AppDimensions.w10(context),
                      Image.asset(ImageAssets.editImage, height: height * 0.02),
                    ],
                  ),
                ),
              ),
            ),
            AppDimensions.h10(context),
            ProfileRow(label: 'Name', value: 'Ram'),
            ProfileRow(label: 'Contact No.', value: '+91 9128918291'),
            ProfileRow(label: 'Role', value: 'Worker'),
            ProfileRow(label: 'Factory', value: 'Factory 1'),
            ProfileRow(label: 'Authority', value: 'Initial QC'),
            ProfileRow(label: 'Password', value: 'qq09193p'),
          ],
        ),
      ),
    );
  }
}

// Extension to capitalize first letter
extension StringCasingExtension on String {
  String capitalize() =>
      isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';
}
