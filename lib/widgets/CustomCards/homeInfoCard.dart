import 'package:flutter/material.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/flutter_font_styles.dart';
import '../../Constants/app_dimensions.dart';

enum CardType { delivery, qc, billing, initialQC }

class HomeInfoCard extends StatelessWidget {
  final CardType cardType;
  final String farmerName;
  final String date;
  final String? vehicleNumber;
  final String? brokerName;
  final String? staffName;
  final double height;
  final double width;
  final VoidCallback onPressed;
  final bool isPending;
  final bool isSuperUser;

  const HomeInfoCard({
    super.key,
    required this.cardType,
    required this.farmerName,
    required this.date,
    this.vehicleNumber,
    this.brokerName,
    this.staffName,
    required this.height,
    required this.width,
    required this.onPressed,
    required this.isPending,
    this.isSuperUser = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        cardType == CardType.qc
                            ? '#22311'
                        : vehicleNumber!,
                        style: AppTextStyles.cardHeading,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),

                      // Optional Transportation tag
                      const SizedBox(width: 4),

                      // ✅ Call _buildStatusTag with a boolean
                      _buildStatusTag(cardType, isPending),


                      const SizedBox(width: 4),

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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildInfoRow(text: 'Farmer', value: farmerName ?? ''),
                    AppDimensions.w20(context),

                    if (staffName == null || staffName!.isEmpty) ...[
                      Icon(Icons.shopping_cart, color: AppColors.bodyTextColor, size: 16),
                      AppDimensions.w10(context),
                      Text(
                        '50',
                        style: AppTextStyles.cardText,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ] else ...[
                      _buildInfoRow(text: 'Staff', value: staffName!),
                    ]


                  ],
                ),
                  AppDimensions.h10(context),
                Row(
                  children: [
                    _buildInfoRow(text: 'Broker', value: brokerName!),
                    if (isSuperUser) ...[
                      if (staffName != null && staffName!.isNotEmpty) ...[
                        AppDimensions.w40(context),
                        AppDimensions.w20(context),
                        Icon(Icons.shopping_cart, color: AppColors.bodyTextColor, size: 16),
                        AppDimensions.w10(context),
                        Text(
                          '50',
                          style: AppTextStyles.cardText,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ]

                  ],
                ),
              ],
            ),

          ],
        ),
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
          value ?? '',
          style: AppTextStyles.cardText,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

Widget _buildStatusTag(CardType cardType, bool isPending) {
  late final String text;

  if (isPending) {
    switch (cardType) {
      case CardType.delivery:
        text = 'Approval Pending';
        break;
      case CardType.qc:
        text = 'Final QC Pending';
        break;
      case CardType.billing:
        text = 'Billing Pending';
        break;
      default:
        text = 'Pending';
    }
  } else {
    text = 'Dispatched';
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: isPending
          ? AppColors.pendingColor.withOpacity(0.21)
          : AppColors.successColor.withOpacity(0.21),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: AppTextStyles.statusFont.copyWith(
        color: isPending
            ? AppColors.pendingColor
            : AppColors.successColor,
      ),
      maxLines: 1,
    ),
  );
}
