import 'package:flutter/material.dart';
import 'package:shree_ram_staff/Constants/app_dimensions.dart';
import 'package:shree_ram_staff/widgets/primary_and_outlined_button.dart';
import 'package:shree_ram_staff/widgets/reusable_appbar.dart';

import '../../../widgets/reusable_functions.dart';

class InitialQcApprovalScreen extends StatefulWidget {
  final qcData;
  const InitialQcApprovalScreen({super.key, required this.qcData});

  @override
  State<InitialQcApprovalScreen> createState() =>
      _InitialQcApprovalScreenState();
}

class _InitialQcApprovalScreenState extends State<InitialQcApprovalScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: ReusableAppBar(title: 'DL 12 AB 2198'),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.035,
          vertical: height * 0.015,
        ),
        child: Column(
          children: [
            ProfileRow(label: 'Unit ID', value: '#221212'),
            ProfileRow(label: 'Name', value: 'Ramesh Yadav'),
            ProfileRow(label: 'Broker', value: 'Rahul'),
            ProfileRow(label: 'Quantity', value: '50 Qntl'),
            ProfileRow(label: 'Date', value: '20/09/2025'),
            ProfileRow(label: 'Initial Weight', value: '511 Qntl'),
            ProfileRow(label: 'Moisture %', value: '33%'),
            ProfileRow(label: 'Rice (g)', value: '1110'),
            ProfileRow(label: 'Husk (g)', value: '1120'),
            ProfileRow(label: 'Discolor %', value: '12'),
            ProfileRow(label: 'Status', value: 'Approval Pending'),

            AppDimensions.h30(context),

            PrimaryButton(text: 'Approve', onPressed: () {}),
            AppDimensions.h10(context),
            ReusableOutlinedButton(text: 'Reject', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
