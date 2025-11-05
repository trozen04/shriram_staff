import 'package:flutter/material.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/flutter_font_styles.dart';
import '../../Constants/app_dimensions.dart';
import '../reusable_functions.dart';

enum CardType { delivery, qc, billing, initialQC }

class HomeInfoCard extends StatelessWidget {
  final CardType cardType;
  final String farmerName;
  final String? id;
  final String date;
  final String? vehicleNumber;
  final String? brokerName;
  final String? staffName;
  final String? weight;
  final double height;
  final double width;
  final VoidCallback onPressed;
  final String status;
  final bool isSuperUser;

  const HomeInfoCard({
    super.key,
    required this.cardType,
    this.id,
    required this.farmerName,
    required this.date,
    this.vehicleNumber,
    this.brokerName,
    this.staffName,
    this.weight,
    required this.height,
    required this.width,
    required this.onPressed,
    required this.status,
    this.isSuperUser = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
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
                        cardType == CardType.qc || cardType == CardType.billing
                            ? _formatId(id)
                            : vehicleNumber!,
                        style: AppTextStyles.cardHeading,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),

                      // Optional Transportation tag
                      const SizedBox(width: 4),

                      // ✅ Call _buildStatusTag with a boolean
                      _buildStatusTag(cardType, status),

                      const SizedBox(width: 4),
                    ],
                  ),
                ),

                // Right: Date
                Text(
                  formatToISTFull(date),
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
                    _buildInfoRow(text: 'Farmer', value: farmerName),
                    AppDimensions.w20(context),

                    if (staffName == null || staffName!.isEmpty) ...[
                      Icon(
                        Icons.shopping_cart,
                        color: AppColors.bodyTextColor,
                        size: 16,
                      ),
                      AppDimensions.w10(context),
                      Text(
                        weight ?? '~',
                        style: AppTextStyles.cardText,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ] else ...[
                      _buildInfoRow(text: 'Staff', value: staffName!),
                    ],
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
                        Icon(
                          Icons.shopping_cart,
                          color: AppColors.bodyTextColor,
                          size: 16,
                        ),
                        AppDimensions.w10(context),
                        Text(
                          weight ?? '~',
                          style: AppTextStyles.cardText,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
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

Widget _buildStatusTag(CardType cardType, String status) {
  late final String text;
  late final Color color;

  switch (status.toLowerCase()) {
    case 'pending':
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
      color = AppColors.pendingColor;
      break;

    case 'dispatched':
      text = 'Dispatched';
      color = AppColors.successColor;
      break;

    case 'approve':
      text = 'Approved';
      color = AppColors.successColor;
      break;

    case 'rejected':
      text = 'Rejected';
      color = AppColors.errorColor;
      break;

    default:
      text = status;
      color = AppColors.successColor;
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.21),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: AppTextStyles.statusFont.copyWith(color: color),
      maxLines: 1,
    ),
  );
}

String _formatId(String? id) {
  if (id == null || id.isEmpty) return '#------'; // fallback if null
  // show only last 6 characters, prefix with '#'
  return '#${id.length > 6 ? id.substring(id.length - 6) : id}';
}
