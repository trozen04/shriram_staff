import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../utils/app_routes.dart';
import '../../../utils/flutter_font_styles.dart';
import '../../../widgets/primary_and_outlined_button.dart';
import '../../../widgets/reusable_appbar.dart';
import '../../../widgets/reusable_functions.dart';

class DeliveryQcDetailPage extends StatelessWidget {
  final dynamic userData;
  final bool isQcPage;
  const DeliveryQcDetailPage({
    super.key,
    required this.userData,
    this.isQcPage = false,
  });

  /// ✅ Helper to safely extract nested keys
  String getNestedValue(dynamic map, List<String> path) {
    dynamic value = map;
    for (var key in path) {
      if (value is Map && value.containsKey(key)) {
        value = value[key];
      } else {
        return '';
      }
    }
    return value?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    developer.log('userdata: $userData\n$isQcPage');

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    /// ✅ Extract common values safely
    final String id = getNestedValue(userData, ['_id']);
    final String transportId = getNestedValue(userData, ['transportId', '_id']);
    final String vehicleno = getNestedValue(userData, ['transportId', 'vehicleno']);
    final String brokerName = getNestedValue(userData, ['transportId', 'brokerId', 'name']);
    final String farmerName = getNestedValue(userData, ['transportId', 'purchaseId', 'name']);
    final String weight = getNestedValue(userData, ['transportId', 'weight']);
    final String deliveryDate = getNestedValue(userData, ['transportId', 'deliverydate']);
    final String initialWeight = getNestedValue(userData, ['initialweight']);
    final String moisture = getNestedValue(userData, ['moisture']);
    final String riceIn = getNestedValue(userData, ['ricein']);
    final String huskIn = getNestedValue(userData, ['huskin']);
    final String discolor = getNestedValue(userData, ['discolor']);
    final String status = isQcPage
        ? getNestedValue(userData, ['status'])
        : getNestedValue(userData, ['purchaseId', 'status']);


    /// ✅ Format unit id with max 6 digits
    String formattedId = '#${(transportId.isNotEmpty ? transportId.substring(transportId.length - 6) : id.substring(id.length - 6))}';

    return Scaffold(
      appBar: ReusableAppBar(
        title: isQcPage
            ? formattedId
            : (vehicleno.isNotEmpty ? vehicleno : 'Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.035,
          vertical: height * 0.015,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🚚 Vehicle number (only for delivery)
            if (!isQcPage && vehicleno.isNotEmpty)
              Text(vehicleno, style: AppTextStyles.cardHeading),
            AppDimensions.h20(context),

            /// 🧾 Unit ID (for QC)
            if (isQcPage && transportId.isNotEmpty)
              ProfileRow(label: 'Unit ID', value: formattedId),

            /// 👨 Farmer & Broker info
            ProfileRow(label: 'Name', value: isQcPage ? farmerName : getNestedValue(userData, ['purchaseId', 'name'])),
            ProfileRow(label: 'Broker', value: isQcPage ? brokerName : getNestedValue(userData, ['brokerId', 'name'])),
            ProfileRow(label: 'Weight', value: isQcPage ? weight : getNestedValue(userData, ['weight'])),
            ProfileRow(
              label: 'Date',
              value: isQcPage
                  ? formatToISTFull(deliveryDate)
                  : formatToISTFull(getNestedValue(userData, ['deliverydate'])),
            ),

            /// ⚗️ QC Specific Data
            if (isQcPage) ...[
              ProfileRow(label: 'Initial Weight', value: initialWeight),
              ProfileRow(label: 'Moisture %', value: moisture),
              ProfileRow(label: 'Rice (g)', value: riceIn),
              ProfileRow(label: 'Husk (g)', value: huskIn),
              ProfileRow(label: 'Discolor %', value: discolor),
            ],

            /// 📊 Status
            ProfileRow(label: 'Status', value: status),

            AppDimensions.h30(context),

            /// ✅ Action Button
            if (!isQcPage && status.toLowerCase().contains('QC-Check'))
              PrimaryButton(
                text: 'Ready to Unload',
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.weightConfirmationPage,
                    arguments: userData,
                  );
                },
                isLoading: false,
              ),
            if (isQcPage && status.toLowerCase().contains('approve'))
              PrimaryButton(
                text: 'Start Final QC',
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.qualityCheckSubmitPage,
                    arguments: userData,
                  );
                },
                isLoading: false,
              ),
          ],
        ),
      ),
    );
  }
}

/// 🧩 Capitalize helper
extension StringCasingExtension on String {
  String capitalize() => isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';
}
