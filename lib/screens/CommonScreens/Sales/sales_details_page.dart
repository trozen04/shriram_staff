import 'package:flutter/material.dart';
import 'package:shree_ram_staff/widgets/reusable_appbar.dart';
import 'package:shree_ram_staff/Constants/app_dimensions.dart';
import '../../../widgets/reusable_functions.dart';

class SalesDetailScreen extends StatelessWidget {
  final salesData;
  const SalesDetailScreen({super.key, required this.salesData});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ReusableAppBar(title: 'Ramesh Yadav'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.035,
          vertical: height * 0.015,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileRow(label: 'Name', value: 'Ramesh Yadav'),
              ProfileRow(label: 'Address', value: '112/22, Ram Colony'),
              ProfileRow(label: 'City/Town', value: 'Gorakhpur'),
              ProfileRow(label: 'Factory', value: 'Factory 1'),
              ProfileRow(label: 'Date', value: '20/09/2025'),
              ProfileRow(label: 'Item', value: 'Rice'),
              ProfileRow(label: 'Driver Name', value: 'Rajeev'),
              ProfileRow(label: 'Driver Phone No.', value: '+91 9073128782'),
              ProfileRow(label: 'Owner Name', value: 'Saksham'),
              ProfileRow(label: 'Owner Phone No.', value: '+91 922711744'),
              ProfileRow(label: 'Vehicle No.', value: 'DL 12 AB 2198'),
              ProfileRow(label: 'Vehicle RC', value: 'RC.pdf'),
              ProfileRow(label: 'Driver License', value: 'License.pdf'),
              ProfileRow(label: 'Driver Aadhar Card', value: 'Aadhar.pdf'),
              ProfileRow(label: 'Delivery Proof', value: 'proof.pdf'),
              AppDimensions.h20(context),
            ],
          ),
        ),
      ),
    );
  }
}

