import 'package:flutter/material.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/flutter_font_styles.dart';
import '../../../Constants/app_dimensions.dart';

class BrokerCard extends StatelessWidget {
  final String? brokerName;
  final String? contactNumber;
  final String date;
  final double height;
  final double width;
  final VoidCallback onPressed;
  final String status; // NEW: status string from API

  const BrokerCard({
    super.key,
    this.brokerName,
    this.contactNumber,
    required this.date,
    required this.height,
    required this.width,
    required this.onPressed,
    required this.status, // required now
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
            // Top row: Broker name + status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (brokerName != null && brokerName!.isNotEmpty)
                  _buildInfoRow(
                    text: 'Broker',
                    value: brokerName!,
                    context: context,
                  ),
                _buildStatusTag(status: status),
              ],
            ),
            AppDimensions.h10(context),

            // Contact & Date row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (contactNumber != null && contactNumber!.isNotEmpty)
                  _buildInfoRow(
                    text: 'Contact No',
                    value: contactNumber!,
                    context: context,
                  ),
                Text(
                  date,
                  style: AppTextStyles.priceTitle,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                ),
              ],
            ),
            AppDimensions.h5(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required String text,
    required String value,
    required BuildContext context,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$text:', style: AppTextStyles.bodyText),
        AppDimensions.w10(context),
        Flexible(
          child: Text(
            value,
            style: AppTextStyles.cardText,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusTag({required String status}) {
    Color bgColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'approve':
        bgColor = AppColors.successColor.withOpacity(0.21);
        textColor = AppColors.successColor;
        break;
      case 'pending':
        bgColor = AppColors.pendingColor.withOpacity(0.21);
        textColor = AppColors.pendingColor;
        break;
      case 'cancel':
        bgColor = AppColors.errorColor.withOpacity(0.21);
        textColor = AppColors.errorColor;
        break;
      default:
        bgColor = AppColors.primaryColor.withOpacity(0.21);
        textColor = AppColors.primaryColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: AppTextStyles.statusFont.copyWith(color: textColor),
        maxLines: 1,
      ),
    );
  }

}
