import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:shree_ram_staff/Constants/app_dimensions.dart';
import 'package:shree_ram_staff/widgets/custom_app_bar.dart';
import 'package:shree_ram_staff/widgets/primary_and_outlined_button.dart';
import '../../../Bloc/PurchaseRequest/purchase_request_bloc.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../widgets/reusable_functions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PurchaseRequestDetail extends StatefulWidget {
  final dynamic purchaseData;
  const PurchaseRequestDetail({super.key, required this.purchaseData});

  @override
  State<PurchaseRequestDetail> createState() => _PurchaseRequestDetailState();
}

class _PurchaseRequestDetailState extends State<PurchaseRequestDetail> {
  bool isButtonLoading = false;
  @override
  Widget build(BuildContext context) {
    final data = widget.purchaseData;
    developer.log('data: ${widget.purchaseData}');

    final purchase = data['purchaseId'] ?? {};
    final broker = data['brokerId'] ?? {};

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    String formatDate(String? date) {
      if (date == null) return '~';
      try {
        final d = DateTime.parse(date);
        return '${d.day}/${d.month}/${d.year}';
      } catch (e) {
        return date;
      }
    }




    return Scaffold(
      appBar: CustomAppBar(
        title: purchase['name'] ?? 'Purchase Detail',
        preferredHeight: height * 0.12,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.035,
          vertical: height * 0.015,
        ),
        child: BlocListener<PurchaseRequestBloc, PurchaseRequestState>(
  listener: (context, state) {
    if(state is PurchaseRequestLoadingState) {
      setState(() {
        isButtonLoading = true;
      });
    } else if(state is ApproveRejectPurchaseSuccessState) {
      setState(() {
        isButtonLoading = false;
      });
      CustomSnackBar.show(
        context,
        message: state.message,
      );
      Navigator.pop(context, true);

    } else if(state is ApproveRejectPurchaseErrorState) {
      setState(() {
        isButtonLoading = true;
      });
    }
  },
  child: SingleChildScrollView(
          child: Column(
            children: [
              ProfileRow(label: 'Farmer Name', value: purchase['name'] ?? '~'),
              ProfileRow(label: 'Broker Name', value: broker['name'] ?? '~'),
              ProfileRow(label: 'Paddy Type', value: purchase['paddytype'] ?? '~'),
              ProfileRow(
                  label: 'Quantity',
                  value: purchase['quantity'] != null
                      ? '${purchase['quantity']} Qntl'
                      : '~'),
              ProfileRow(label: 'Address', value: purchase['address'] ?? '~'),
              ProfileRow(label: 'City/Town', value: purchase['city'] ?? '~'),
              ProfileRow(label: 'Factory', value: data['factory'] ?? '~'),
              ProfileRow(label: 'Delivery Date', value: formatDate(data['deliverydate'])),
              AppDimensions.h30(context),

              // Optional Approve/Reject buttons
              if ((data['status']?.toLowerCase() ?? '').contains('pending')) ...[
                PrimaryButton(
                  text: 'Approve',
                  onPressed: () {
                    context.read<PurchaseRequestBloc>().add(
                      ApproveRejectPurchaseEvent(
                        purchaseId: widget.purchaseData['_id'],
                        status: 'Approve',
                      ),
                    );
                  },
                ),
                AppDimensions.h10(context),
                ReusableOutlinedButton(
                  text: 'Reject',
                  onPressed: () {
                    context.read<PurchaseRequestBloc>().add(
                      ApproveRejectPurchaseEvent(
                        purchaseId: widget.purchaseData['_id'],
                        status: 'Cancel',
                      ),
                    );
                  },
                ),

              ],

              AppDimensions.h30(context),
            ],
          ),
        ),
),
      ),
    );
  }
}
