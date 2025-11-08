import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:shree_ram_staff/widgets/reusable_appbar.dart';
import 'package:shree_ram_staff/Constants/app_dimensions.dart';
import '../../../widgets/reusable_functions.dart';

class SalesDetailScreen extends StatelessWidget {
  final dynamic salesData;
  const SalesDetailScreen({super.key, required this.salesData});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    developer.log('salesData: $salesData');

    final factoryData = salesData['factory'] ?? {};
    final createdBy = salesData['createdBy'] ?? {};
    final List<dynamic> items = salesData['items'] ?? [];

    // 🧮 Combine all item names in a comma-separated string
    final itemNames = items.map((e) => e['item'].toString()).join(', ');
    // 🧮 Date format (basic)
    final date = (salesData['createdAt'] ?? '').toString().split('T').first;

    return Scaffold(
      appBar: ReusableAppBar(
        title: salesData['customername'] ?? 'Sales Details',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.035,
          vertical: height * 0.015,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileRow(label: 'Name', value: salesData['customername'] ?? '~'),
            ProfileRow(label: 'Address', value: salesData['address'] ?? '~'),
            ProfileRow(label: 'City/Town', value: salesData['city'] ?? '~'),
            ProfileRow(label: 'Factory', value: factoryData['factoryname'] ?? '~'),
            ProfileRow(label: 'Date', value: date.isEmpty ? '~' : date),
            ProfileRow(label: 'Item(s)', value: itemNames.isEmpty ? '~' : itemNames),
            ProfileRow(label: 'Driver Name', value: salesData['driverName'] ?? '~'),
            ProfileRow(label: 'Driver Phone No.', value: salesData['driverPhone'] ?? '~'),
            ProfileRow(label: 'Owner Name', value: salesData['ownerName'] ?? '~'),
            ProfileRow(label: 'Owner Phone No.', value: salesData['ownerPhone'] ?? '~'),
            ProfileRow(label: 'Vehicle No.', value: salesData['vehicleNo'] ?? '~'),
            ProfileRow(label: 'Vehicle RC', value: salesData['vehicleRc'] ?? '~'),
            ProfileRow(label: 'Driver License', value: salesData['driverLicense'] ?? '~'),
            ProfileRow(label: 'Driver Aadhar Card', value: salesData['driverAadhar'] ?? '~'),
            ProfileRow(label: 'Delivery Proof', value: salesData['deliveryProof'] ?? '~'),
            ProfileRow(label: 'Created By', value: createdBy['name'] ?? '~'),
            ProfileRow(label: 'Status', value: salesData['status'] ?? '~'),
            AppDimensions.h20(context),
          ],
        ),
      ),
    );
  }
}
