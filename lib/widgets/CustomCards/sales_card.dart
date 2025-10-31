import 'package:flutter/material.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/flutter_font_styles.dart';
import '../../Constants/app_dimensions.dart';

class SalesCard extends StatelessWidget {
  final String name;
  final String date;
  final String? address;
  final String? city;
  final String? staffName;
  final double height;
  final double width;
  final bool? isPending;

  const SalesCard({
    super.key,
    required this.name,
    required this.date,
    this.address,
    this.city,
    this.staffName,
    required this.height,
    required this.width,
    this.isPending = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.05,
        vertical: height * 0.015,
      ),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      name,
                      style: AppTextStyles.cardHeading,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    AppDimensions.w10(context),
                    _buildStatusTag(isPending!),
                  ],
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
              _buildInfoRow(text: 'Address', value: address!),
              AppDimensions.h10(context),
              _buildInfoRow(text: 'City/Town', value: city!),
              if ((staffName!.isNotEmpty || staffName != null) &&
                  !isPending!) ...[
                AppDimensions.h10(context),
                _buildInfoRow(text: 'Staff', value: staffName!),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // Info row helper
  Widget _buildInfoRow({required String text, required String value}) {
    return Row(
      children: [
        Text(
          '$text:',
          style: AppTextStyles.bodyText,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: AppTextStyles.cardText,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

Widget _buildStatusTag(bool isPending) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: isPending
          ? AppColors.pendingColor.withOpacity(0.21)
          : AppColors.successColor.withOpacity(0.21),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      isPending ? 'Loading Pending' : 'Dispatched',
      style: AppTextStyles.statusFont.copyWith(
        color: isPending ? AppColors.pendingColor : AppColors.successColor,
      ),
      maxLines: 1,
    ),
  );
}
