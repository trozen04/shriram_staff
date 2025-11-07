import 'package:flutter/material.dart';
import 'package:shree_ram_staff/Constants/app_dimensions.dart';
import 'package:shree_ram_staff/widgets/custom_snackbar.dart';
import 'package:shree_ram_staff/widgets/primary_and_outlined_button.dart';
import 'package:shree_ram_staff/widgets/reusable_appbar.dart';
import '../../../Bloc/QCBloc/qc_bloc.dart';
import '../../../widgets/reusable_functions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InitialQcApprovalScreen extends StatefulWidget {
  final dynamic qcData;
  const InitialQcApprovalScreen({super.key, required this.qcData});

  @override
  State<InitialQcApprovalScreen> createState() =>
      _InitialQcApprovalScreenState();
}

class _InitialQcApprovalScreenState extends State<InitialQcApprovalScreen> {
  @override
  Widget build(BuildContext context) {
    final data = widget.qcData;

    final transport = data['transportId'];
    final purchase = transport?['purchaseId'];
    final broker = transport?['brokerId'];
    final user = data['userId'];

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: ReusableAppBar(
        title: transport?['vehicleno'] ?? 'Vehicle No. N/A',
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.035,
          vertical: height * 0.015,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileRow(label: 'Unit ID', value: data['_id'] ?? '-'),
            ProfileRow(label: 'Name', value: purchase?['name'] ?? '-'),
            ProfileRow(label: 'Broker', value: broker?['name'] ?? '-'),
            ProfileRow(label: 'Quantity', value: purchase?['quantity']?.toString() ?? '-'),
            ProfileRow(label: 'Date', value: _formatDate(transport?['deliverydate'])),
            ProfileRow(label: 'Initial Weight', value: data['initialweight']?.toString() ?? '-'),
            ProfileRow(label: 'Moisture %', value: data['moisture']?.toString() ?? '-'),
            ProfileRow(label: 'Rice (g)', value: data['ricein']?.toString() ?? '-'),
            ProfileRow(label: 'Husk (g)', value: data['huskin']?.toString() ?? '-'),
            ProfileRow(label: 'Discolor %', value: data['discolor']?.toString() ?? '-'),
            ProfileRow(label: 'Staff Name', value: user?['name'] ?? '-'),
            ProfileRow(label: 'Status', value: data['status'] ?? '-'),

            AppDimensions.h30(context),

          if ((data['status']?.toString().toLowerCase() ?? '').contains('pending'))
            BlocConsumer<QcBloc, QcState>(
              listener: (context, state) {
                if (state is UpdateQcStatusSuccessState) {
                  CustomSnackBar.show(context, message: 'Status updated successfully!');
                  Navigator.pop(context, true);
                } else if (state is UpdateQcStatusErrorState) {
                  CustomSnackBar.show(context, message: state.message, isError: true);
                }
              },
              builder: (context, state) {
                final isLoading = state is UpdateQcStatusLoadingState;

                return Column(
                  children: [
                    PrimaryButton(
                      text: isLoading ? 'Processing...' : 'Approve',
                      onPressed: isLoading
                          ? null
                          : () {
                        context.read<QcBloc>().add(
                          UpdateQcStatusEvent(
                            qcId: data['_id'],
                            status: 'Approve',
                          ),
                        );
                      },
                    ),
                    AppDimensions.h10(context),
                    ReusableOutlinedButton(
                      text: isLoading ? 'Processing...' : 'Reject',
                      onPressed: isLoading
                          ? null
                          : () {
                        context.read<QcBloc>().add(
                          UpdateQcStatusEvent(
                            qcId: data['_id'],
                            status: 'Cancel',
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),

          ],
        ),
      ),
    );
  }

  String _formatDate(dynamic dateStr) {
    if (dateStr == null || dateStr.toString().isEmpty) return '-';
    try {
      final date = DateTime.parse(dateStr.toString());
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return '-';
    }
  }
}
