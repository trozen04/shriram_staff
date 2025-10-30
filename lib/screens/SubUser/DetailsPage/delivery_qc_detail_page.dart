import 'package:flutter/material.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../utils/app_routes.dart';
import '../../../utils/flutter_font_styles.dart';
import '../../../widgets/primary_and_outlined_button.dart';
import '../../../widgets/reusable_appbar.dart';
import '../../../widgets/reusable_functions.dart';

class DeliveryQcDetailPage extends StatelessWidget {
  final dynamic userData;
  final bool isAfterQC;
  final bool isPendingQC;
  const DeliveryQcDetailPage({super.key, required this.userData, this.isAfterQC = false, this.isPendingQC = false});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final data = userData;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ReusableAppBar(
        title: isPendingQC ? "#22311" : data['vehicleNumber'] ?? 'Details',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: width * 0.035, vertical: height * 0.015),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Optional top row with name and call button
            if (!isAfterQC && !isPendingQC && data['vehicleNumber'] != null && data['vehicleNumber'].toString().isNotEmpty)
              Text(
                data['vehicleNumber'],
                style: AppTextStyles.cardHeading,
              ),
            AppDimensions.h20(context),

            //if (isAfterQC && data['_id'] != null && data['_id'].toString().isNotEmpty)
            if (isAfterQC || isPendingQC)
              ProfileRow(label: 'Unit ID', value: '#221212'),
            ProfileRow(label: 'Name', value: 'Ramesh Yadav'),
            ProfileRow(label: 'Broker', value: 'Rahul'),
            ProfileRow(label: 'Quantity', value: '50 Qntl'),
            ProfileRow(label: 'Date', value: '20/09/2025'),
            if (isAfterQC || isPendingQC)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileRow(label: 'Initial Weight', value: '51 Qntl'),
                  ProfileRow(label: 'Moisture %', value: '33%'),
                  ProfileRow(label: 'Rice (g)', value: '1110'),
                  ProfileRow(label: 'Husk (g)', value: '1120'),
                  ProfileRow(label: 'Discolor %', value: '12'),
                ],
              ),
            ProfileRow(label: 'Status', value: '${isPendingQC ? 'QC' : '${isAfterQC ? 'Approval' : 'Arrival'}'} Pending'),
            AppDimensions.h30(context),
            if(!isAfterQC)
            PrimaryButton(
              text: isPendingQC ? 'Start Final QC' : 'Ready to Unload',
              onPressed: () {
               if(isPendingQC) {
                 Navigator.pushNamed(context, AppRoutes.qualityCheckSubmitPage, arguments: null);
               } else {
                 Navigator.pushNamed(context, AppRoutes.weightConfirmationPage, arguments: null);
               }
              },
              isLoading: false,
            ),
          ],
        ),
      ),
    );
  }

}

// Extension to capitalize first letter
extension StringCasingExtension on String {
  String capitalize() => isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';
}