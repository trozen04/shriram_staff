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

    return Scaffold(
      appBar: ReusableAppBar(title: '#22311'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.035,
          vertical: height * 0.015,
        ),
        child: Column(
          children: [
            ProfileRow(label: 'Unit ID', value: '#22311'),
            ProfileRow(label: 'Name', value: 'Ramesh Yadav'),
            ProfileRow(label: 'Broker', value: 'Rahul'),
            ProfileRow(label: 'Quantity', value: '50 Qntl'),
            ProfileRow(label: 'Date', value: '511 Qntl'),
            ProfileRow(label: 'Initial Weight', value: '511 Qntl'),
            ProfileRow(label: 'Final Weight', value: '511 Qntl'),
            ProfileRow(label: 'Net Weight', value: '511 Qntl'),
            ProfileRow(label: 'Paddy Type', value: 'Type A'),
            ProfileRow(label: '', value: formatAmount(20000)),
            ProfileRow(label: 'Labor Charge', value: formatAmount(20000)),
            ProfileRow(label: 'Brokerage', value: formatAmount(20000)),
          ],
        ),
      ),
    );
  }
}
