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

    // actualData is the real object, in case API sends data inside { data: {...} }
    final actualData = salesData['data'] ?? salesData;
    developer.log('actualData: $actualData');

    final factoryData = actualData['factory'] ?? {};
    final createdBy = actualData['createdBy'] ?? {};
    final acceptedBy = actualData['acceptedBy'] ?? {};
    final loading = actualData['loadingDetails'] ?? {};
    final List<dynamic> items = actualData['items'] ?? [];

    // Combine all item names into comma-separated string
    final itemNames = items.map((e) {
      final name = e['item'] is Map ? e['item']['name'] : e['item']?.toString();
      return name ?? '~';
    }).join(', ');

    // Date formatting (basic)
    final date = (actualData['createdAt'] ?? '').toString().split('T').first;
    final acceptedAt = (actualData['acceptedAt'] ?? '').toString().split('T').first;

    return Scaffold(
      appBar: ReusableAppBar(
        title: actualData['customername'] ?? 'Sales Details',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.035,
          vertical: height * 0.015,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileRow(label: 'Name', value: actualData['customername'] ?? '~'),
            ProfileRow(label: 'Address', value: actualData['address'] ?? '~'),
            ProfileRow(label: 'City/Town', value: actualData['city'] ?? '~'),
            ProfileRow(label: 'Factory', value: factoryData['factoryname'] ?? '~'),
            ProfileRow(label: 'Date', value: date.isEmpty ? '~' : date),
            ProfileRow(label: 'Item(s)', value: itemNames.isEmpty ? '~' : itemNames),

            // Vehicle Details (from loadingDetails)
            ProfileRow(label: 'Driver Name', value: loading['drivername'] ?? '~'),
            ProfileRow(label: 'Driver Phone No.', value: loading['phoneno'] ?? '~'),
            ProfileRow(label: 'Owner Name', value: loading['ownername'] ?? '~'),
            ProfileRow(label: 'Owner Phone No.', value: loading['ownerphoneno'] ?? '~'),
            ProfileRow(label: 'Vehicle RC', value: loading['vehiclerc'] ?? '~'),
            ProfileRow(label: 'Driver License', value: loading['driverlicence'] ?? '~'),
            ProfileRow(label: 'Driver Aadhar Card', value: loading['adharcard'] ?? '~'),
            ProfileRow(label: 'Delivery Proof', value: loading['deliveryproof'] ?? '~'),

            AppDimensions.h20(context),
          ],
        ),
      ),
    );
  }
}
