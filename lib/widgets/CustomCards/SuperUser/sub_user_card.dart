import 'package:flutter/material.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/flutter_font_styles.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../Utils/image_assets.dart';

class SubUserCard extends StatelessWidget {
  final String name;
  final String date;
  final String? position;
  final String? phone;
  final String? qcType;
  final double height;
  final double width;

  const SubUserCard({
    super.key,
    required this.name,
    required this.date,
    this.position,
    this.phone,
    this.qcType,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.015),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Name and Date
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: AppTextStyles.cardHeading,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),

              // Right: Date
              Text(
                date,
                style: AppTextStyles.priceTitle,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
              ),
            ],
          ),

            AppDimensions.h10(context),

          // Main content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(imagePath: ImageAssets.work, value: position!),
                AppDimensions.h10(context),
              _buildInfoRow(imagePath: ImageAssets.call, value: phone!),
              AppDimensions.h10(context),
              _buildInfoRow(imagePath: ImageAssets.qcPng, value: qcType!),
            ],
          ),

        ],
      ),
    );
  }

  // Info row helper
  Widget _buildInfoRow({
    IconData? icon,
    String? imagePath,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null)
          Icon(icon, color: AppColors.primaryColor, size: 18)
        else if (imagePath != null)
          Image.asset(imagePath, height: 18, width: 18, fit: BoxFit.contain),

        if (icon != null || imagePath != null)
          const SizedBox(width: 6),

        Expanded(
          child: Text(
            value,
            style: AppTextStyles.cardText,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
