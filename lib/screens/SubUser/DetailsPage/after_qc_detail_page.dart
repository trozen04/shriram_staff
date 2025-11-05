import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:shree_ram_staff/screens/SubUser/DetailsPage/delivery_qc_detail_page.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../utils/app_routes.dart';
import '../../../widgets/reusable_appbar.dart';
import '../../../widgets/reusable_functions.dart';

class AfterQcDetailPage extends StatelessWidget {
  final dynamic qcData;
  final dynamic userData;
  const AfterQcDetailPage({super.key, required this.qcData, required this.userData});

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
    developer.log('QC Data: $qcData');
    developer.log('User Data: $userData');

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final qcDetails = qcData['data'] ?? {};

    // Use userData for nested transport info
    final transport = userData;

    final String vehicleno = getNestedValue(transport, ['vehicleno']);
    final String id = getNestedValue(qcDetails, ['_id']);
    final String brokerName = getNestedValue(transport, ['brokerId', 'name']);
    final String farmerName = getNestedValue(transport, ['purchaseId', 'name']);
    final String quantity = getNestedValue(transport, ['weight']);
    final String date = getNestedValue(transport, ['deliverydate']);
    final String initialWeight = getNestedValue(qcDetails, ['initialweight']);
    final String moisture = getNestedValue(qcDetails, ['moisture']);
    final String riceIn = getNestedValue(qcDetails, ['ricein']);
    final String huskIn = getNestedValue(qcDetails, ['huskin']);
    final String discolor = getNestedValue(qcDetails, ['discolor']);
    final String status = getNestedValue(qcDetails, ['status']);

    String formattedId = '#${id.isNotEmpty ? id.substring(id.length - 6) : '------'}';

    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(context, ModalRoute.withName(AppRoutes.deliveryPage));
        return false;
      },
      child: Scaffold(
        appBar: ReusableAppBar(
          title: vehicleno.isNotEmpty ? vehicleno : 'QC Details',
          onBackTap: () {
            Navigator.popUntil(context, ModalRoute.withName(AppRoutes.deliveryPage));
          },
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.05,
            vertical: height * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileRow(label: 'Unit ID', value: formattedId),
              ProfileRow(label: 'Name', value: farmerName),
              ProfileRow(label: 'Broker', value: brokerName),
              ProfileRow(label: 'Quantity', value: quantity),
              ProfileRow(label: 'Date', value: formatToISTFull(date)),
              ProfileRow(label: 'Initial Weight', value: initialWeight),
              ProfileRow(label: 'Moisture %', value: '$moisture%'),
              ProfileRow(label: 'Rice (g)', value: riceIn),
              ProfileRow(label: 'Husk (g)', value: huskIn),
              ProfileRow(label: 'Discolor %', value: discolor),
              ProfileRow(label: 'Status', value: status.capitalize()),
              AppDimensions.h30(context),
            ],
          ),
        ),
      ),
    );
  }
}

