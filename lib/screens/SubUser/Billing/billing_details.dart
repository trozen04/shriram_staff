import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:shree_ram_staff/widgets/reusable_appbar.dart';
import 'package:shree_ram_staff/widgets/reusable_functions.dart';

class BillingDetails extends StatefulWidget {
  final billingData;
  const BillingDetails({super.key, required this.billingData});

  @override
  State<BillingDetails> createState() => _BillingDetailsState();
}

class _BillingDetailsState extends State<BillingDetails> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;


    final data = widget.billingData;
    final transport = data['transportId'] ?? {};
    final broker = transport['brokerId'] ?? {};

    // Using first paddyQC item for Paddy Type (as an example)
    final paddyQCList = data['paddyQC'] as List? ?? [];
    final firstPaddy = paddyQCList.isNotEmpty ? paddyQCList[0] : {};

    return Scaffold(
      appBar: ReusableAppBar(title: '#${data['_id'] ?? ''}'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.035,
          vertical: height * 0.015,
        ),
        child: Column(
          children: [
            ProfileRow(label: 'Unit ID', value: '#${data['_id'] ?? ''}'),
            ProfileRow(label: 'Name', value: transport['drivername'] ?? ''),
            ProfileRow(label: 'Broker', value: broker['name'] ?? ''),
            ProfileRow(label: 'Quantity', value: '${data['finalweight'] ?? 0}'),
            ProfileRow(label: 'Date', value: transport['deliverydate'] != null
                ? DateTime.parse(transport['deliverydate']).toLocal().toString().split(' ')[0]
                : ''),
            ProfileRow(label: 'Initial Weight', value: '${data['initialweight'] ?? 0}'),
            ProfileRow(label: 'Final Weight', value: '${data['finalweight'] ?? 0}'),
            ProfileRow(label: 'Net Weight', value: '${data['weight'] ?? 0}'),
            ProfileRow(label: 'Paddy Type', value: firstPaddy['type'] ?? ''),
            ProfileRow(label: '', value: formatAmount(20000)), // placeholder
            ProfileRow(label: 'Labor Charge', value: formatAmount(20000)), // placeholder
            ProfileRow(label: 'Brokerage', value: formatAmount(20000)), // placeholder
          ],
        ),
      ),
    );
  }
}
