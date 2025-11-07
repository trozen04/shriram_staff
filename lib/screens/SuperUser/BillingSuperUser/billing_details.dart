import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:shree_ram_staff/utils/app_colors.dart';
import 'package:shree_ram_staff/utils/flutter_font_styles.dart';
import 'package:shree_ram_staff/widgets/reusable_appbar.dart';
import 'package:shree_ram_staff/widgets/reusable_functions.dart';
import 'package:shree_ram_staff/Constants/app_dimensions.dart';

import '../../../widgets/generate_pdf.dart';

class BillingDetailScreen extends StatelessWidget {
  final billingData;
  const BillingDetailScreen({super.key, required this.billingData});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    developer.log('billingData: $billingData');

    final billingDetails = [
      {
        'paddyType': 'Mohan',
        'weight': '223 Qntl',
        'bags': '23',
        'price': '₹ 7500',
        'amount': '₹ 175000',
      },
      {
        'paddyType': 'Mohan',
        'weight': '223 Qntl',
        'bags': '23',
        'price': '₹ 7500',
        'amount': '₹ 175000',
      },
      {
        'paddyType': 'Mohan',
        'weight': '223 Qntl',
        'bags': '23',
        'price': '₹ 7500',
        'amount': '₹ 175000',
      },
    ];

    return Scaffold(
      appBar: ReusableAppBar(title: '#22311'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.035,
          vertical: height * 0.015,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileRow(label: 'Unit ID', value: '#221212'),
            ProfileRow(label: 'Name', value: 'Ramesh Yadav'),
            ProfileRow(label: 'Broker', value: 'Rahul'),
            ProfileRow(label: 'Initial Weight', value: '511 Qntl'),
            ProfileRow(label: 'Final Weight', value: '511 Qntl'),
            ProfileRow(label: 'Net Weight', value: '112 Qntl'),

            AppDimensions.h20(context),
            Text('Billing Details', style: AppTextStyles.appbarTitle),

            AppDimensions.h10(context),

            // ✅ Scrollable Table Container
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: width * 1.1,
                ), // ensures proper width
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(1.6),
                    1: FlexColumnWidth(1.2),
                    2: FlexColumnWidth(1),
                    3: FlexColumnWidth(1),
                    4: FlexColumnWidth(1),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    // ✅ Header Row
                    TableRow(
                      children: [
                        _headerCell('Paddy Type'),
                        _headerCell('Weight'),
                        _headerCell('Bags'),
                        _headerCell('Price'),
                        _headerCell('Amount'),
                      ],
                    ),

                    // ✅ Data Rows
                    ...billingDetails.map(
                      (row) => TableRow(
                        children: [
                          _cell(row['paddyType']!),
                          _cell(row['weight']!),
                          _cell(row['bags']!),
                          _cell(row['price']!),
                          _cell(row['amount']!),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            AppDimensions.h20(context),
            Text('Deductions', style: AppTextStyles.appbarTitle),
            ProfileRow(label: 'Labor Charge', value: '₹ 2300'),
            ProfileRow(label: 'Brokerage', value: '₹ 1220'),

            Divider(color: AppColors.dividerColor, height: height * 0.04),
            ProfileRow(label: 'Total', value: '₹ 2300'),

            AppDimensions.h30(context),
            Center(
              child: CustomRoundedButton(
                backgroundColor: AppColors.primaryColor,
                child: Text(
                  'Download Pdf',
                  style: AppTextStyles.buttonText.copyWith(color: Colors.white),
                ),
                onTap: () async {
                  await generateBillingPdfToDevice(billingDetails);
                },
              ),
            ),
            AppDimensions.h20(context),
          ],
        ),
      ),
    );
  }

  Widget _headerCell(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
    child: Text(text, style: AppTextStyles.bodyText),
  );

  Widget _cell(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
    child: Text(
      text,
      style: AppTextStyles.bodyText.copyWith(
        color: AppColors.opacityColorBlack,
      ),
      overflow: TextOverflow.ellipsis,
    ),
  );
}
