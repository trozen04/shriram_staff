import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shree_ram_staff/Bloc/BillingBloc/billing_bloc.dart';
import 'package:shree_ram_staff/utils/app_colors.dart';
import 'package:shree_ram_staff/utils/flutter_font_styles.dart';
import 'package:shree_ram_staff/widgets/reusable_appbar.dart';
import 'package:shree_ram_staff/widgets/reusable_functions.dart';
import 'package:shree_ram_staff/Constants/app_dimensions.dart';
import '../../../widgets/generate_pdf.dart';
import '../../../widgets/custom_snackbar.dart';

class BillingDetailScreen extends StatefulWidget {
  final dynamic billingData;
  const BillingDetailScreen({super.key, required this.billingData});

  @override
  State<BillingDetailScreen> createState() => _BillingDetailScreenState();
}

class _BillingDetailScreenState extends State<BillingDetailScreen> {
  dynamic billingDetails;

  @override
  void initState() {
    super.initState();
    final id = widget.billingData['_id'] ?? widget.billingData['data']?['_id'];
    if (id != null) {
      context.read<BillingBloc>().add(GetBillingDetailsEvent(billingId: id));
    } else {
      developer.log('❌ No billing _id found in provided data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const ReusableAppBar(title: 'Billing Details'),
      body: BlocListener<BillingBloc, BillingState>(
        listener: (context, state) {
          if (state is BillingDetailsSuccess) {
            developer.log('✅ Billing details response: ${state.data}');
            setState(() => billingDetails = state.data['data']);
          } else if (state is BillingError) {
            CustomSnackBar.show(context, message: state.message, isError: true);
          }
        },
        child: billingDetails == null
            ? const Center(child: CircularProgressIndicator())
            : _buildBody(context, width, height),
      ),
    );
  }

  Widget _buildBody(BuildContext context, double width, double height) {
    final data = billingDetails ?? {};
    final billingItems = (data['billingItems'] is List)
        ? List<Map<String, dynamic>>.from(data['billingItems'])
        : [];
    final deductions = (data['deductions'] != null &&
        data['deductions'] is List &&
        data['deductions'].isNotEmpty)
        ? data['deductions'][0]
        : {};

    final finalQC = data['finalQCId'] ?? {};
    final transport = finalQC['transportId'] ?? {};
    final purchase = transport['purchaseId'] ?? {};
    final broker = transport['brokerId'] ?? {};

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.035,
        vertical: height * 0.015,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileRow(label: 'Unit ID', value: '${finalQC['_id'] ?? '#N/A'}'),
          ProfileRow(label: 'Name', value: purchase['name'] ?? '~'),
          ProfileRow(label: 'Broker', value: broker['name'] ?? '~'),
          ProfileRow(label: 'Final Weight', value: '${finalQC['finalweight'] ?? 'N/A'}'),

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
                        _cell(item['itemName']?.toString() ?? '—'),
                        _cell('${item['weight'] ?? '—'}'),
                        _cell('${item['bags'] ?? '—'}'),
                        _cell('₹ ${item['price'] ?? 0}'),
                        _cell('₹ ${item['amount'] ?? 0}'),
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
            value: '₹ ${deductions['labourcharge'] ?? 0}',
          ),
          ProfileRow(
            label: 'Brokerage',
            value: '₹ ${deductions['brokerage'] ?? 0}',
          ),
          ProfileRow(
            label: 'Enter Amount',
            value: '₹ ${deductions['enteramount'] ?? 0}',
          ),

          Divider(color: AppColors.dividerColor, height: height * 0.04),

          ProfileRow(
            label: 'Total',
            value: '₹ ${data['totalAmount'] ?? 0}',
          ),
          ProfileRow(
            label: 'Net Payable',
            value: '₹ ${data['netPayable'] ?? 0}',
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
                await generateBillingPdfToDevice(billingDetails);

              },
            ),
          ),
          AppDimensions.h20(context),
        ],
      ),
    );
  }

  Widget _headerCell(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
    child: Text(
      text,
      style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.bold),
    ),
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
