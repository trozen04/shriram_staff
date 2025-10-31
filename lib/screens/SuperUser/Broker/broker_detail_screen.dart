import 'package:flutter/material.dart';
import 'package:shree_ram_staff/Constants/app_dimensions.dart';
import 'package:shree_ram_staff/widgets/custom_app_bar.dart';
import 'package:shree_ram_staff/widgets/primary_and_outlined_button.dart';

import '../../../widgets/reusable_functions.dart';

class BrokerDetailScreen extends StatefulWidget {
  const BrokerDetailScreen({super.key});

  @override
  State<BrokerDetailScreen> createState() => _BrokerDetailScreenState();
}

class _BrokerDetailScreenState extends State<BrokerDetailScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Ramesh Yadav',
        preferredHeight: height * 0.12,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.035,
          vertical: height * 0.015,
        ),
        child: Column(
          children: [
            ProfileRow(label: 'Broker Name', value: 'Karan'),
            ProfileRow(label: 'Contact No.', value: '+91 8292839392'),
            ProfileRow(label: 'Address', value: '112/22, Ram Colony'),
            ProfileRow(label: 'City/Town', value: 'Gorakhpur'),
            ProfileRow(label: 'Factory', value: 'Factory 1'),
            ProfileRow(label: 'Date', value: '20/09/2025'),
            AppDimensions.h30(context),
            PrimaryButton(text: 'Approve', onPressed: () {}),
            AppDimensions.h10(context),
            ReusableOutlinedButton(text: 'Reject', onPressed: () {}),
            AppDimensions.h30(context),
          ],
        ),
      ),
    );
  }
}
