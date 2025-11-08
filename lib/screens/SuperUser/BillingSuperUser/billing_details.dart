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

    final billingItems = billingData['billingItems'] ?? [];

    final deductions = (billingData['deductions'] != null &&
        billingData['deductions'] is List &&
        billingData['deductions'].isNotEmpty)
        ? billingData['deductions'][0]
        : {};


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
            ProfileRow(label: 'Initial Weight', value: '511'),
            ProfileRow(label: 'Final Weight', value: '${billingData['finalWeight'] ?? 'N/A'}'),
            ProfileRow(label: 'Net Weight', value: '${billingData['netPayable'] ?? 'N/A'}'),

            AppDimensions.h20(context),
            Text('Billing Details', style: AppTextStyles.appbarTitle),

            AppDimensions.h10(context),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: width * 1.1),
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
                    TableRow(
                      children: [
                        _headerCell('Paddy Type'),
                        _headerCell('Weight'),
                        _headerCell('Bags'),
                        _headerCell('Price'),
                        _headerCell('Amount'),
                      ],
                    ),
                    ...billingItems.map(
                          (item) => TableRow(
                        children: [
                          _cell(item['itemName'].toString()),
                          _cell('${item['weight']}'),
                          _cell('${item['bags']}'),
                          _cell('₹ ${item['price']}'),
                          _cell('₹ ${item['amount']}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            AppDimensions.h20(context),
            Text('Deductions', style: AppTextStyles.appbarTitle),
            ProfileRow(
              label: 'Labor Charge',
              value: deductions.isNotEmpty ? '₹ ${deductions['labourcharge']}' : '₹ 0',
            ),
            ProfileRow(
              label: 'Brokerage',
              value: deductions.isNotEmpty ? '₹ ${deductions['brokerage']}' : '₹ 0',
            ),
            ProfileRow(
              label: 'Enter Amount',
              value: deductions.isNotEmpty ? '₹ ${deductions['enteramount']}' : '₹ 0',
            ),

            Divider(color: AppColors.dividerColor, height: height * 0.04),
            ProfileRow(
              label: 'Total',
              value: '₹ ${billingData['totalAmount']}',
            ),
            ProfileRow(
              label: 'Net Payable',
              value: '₹ ${billingData['netPayable']}',
            ),

            AppDimensions.h30(context),
            Center(
              child: CustomRoundedButton(
                backgroundColor: AppColors.primaryColor,
                child: Text(
                  'Download Pdf',
                  style: AppTextStyles.buttonText.copyWith(color: Colors.white),
                ),
                onTap: () async {
                  await generateBillingPdfToDevice(billingItems);
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
