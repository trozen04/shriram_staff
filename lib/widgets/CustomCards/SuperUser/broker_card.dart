import 'package:flutter/material.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/flutter_font_styles.dart';
import '../../../Constants/app_dimensions.dart';

class BrokerCard extends StatelessWidget {
  final String? brokerName;
  final String? contactNumber;
  final String date;
  final String? paddy;
  final double height;
  final double width;
  final VoidCallback onPressed;
  final bool isPending;

  const BrokerCard({
    super.key,
    this.brokerName,
    this.contactNumber,
    this.paddy,
    required this.date,
    required this.height,
    required this.width,
    required this.onPressed,
    required this.isPending,
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
            // Top row: Farmer name + date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Broker
                if (brokerName != null && brokerName!.isNotEmpty)
                  _buildInfoRow(
                      text: 'Broker', value: brokerName!, context: context),
                _buildStatusTag(isPending: isPending)

              ],
            ),


            AppDimensions.h10(context),


            // Broker
            if (contactNumber != null && contactNumber!.isNotEmpty)
              _buildInfoRow(
                  text: 'Contact No', value: contactNumber!, context: context),
            AppDimensions.h10(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Broker
                if (paddy != null && paddy!.isNotEmpty)
                _buildInfoRow(text: 'Paddy', value: paddy!, context: context),

                Text(
                  date,
                  style: AppTextStyles.priceTitle,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                ),

              ],
            ),
            AppDimensions.h5(context),


            // Optional status tag
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


  Widget _buildStatusTag({required bool isPending, String? text}) {
    final String statusText = text ??
        (isPending ? 'Approval Pending' : 'Approved');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isPending
            ? AppColors.pendingColor.withOpacity(0.21)
            : AppColors.successColor.withOpacity(0.21),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        statusText,
        style: AppTextStyles.statusFont.copyWith(
          color: isPending
              ? AppColors.pendingColor
              : AppColors.successColor,
        ),
        maxLines: 1,
      ),
    );
  }
}

