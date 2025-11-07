import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shree_ram_staff/Constants/app_dimensions.dart';
import 'package:shree_ram_staff/widgets/custom_app_bar.dart';
import 'package:shree_ram_staff/widgets/primary_and_outlined_button.dart';
import '../../../Bloc/Broker/broker_bloc.dart';
import '../../../widgets/reusable_functions.dart';
import '../../../widgets/custom_snackbar.dart';

class BrokerDetailScreen extends StatefulWidget {
  final brokerData;
  const BrokerDetailScreen({super.key, required this.brokerData});

  @override
  State<BrokerDetailScreen> createState() => _BrokerDetailScreenState();
}

class _BrokerDetailScreenState extends State<BrokerDetailScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final data = widget.brokerData;

    return BlocListener<BrokerBloc, BrokerState>(
      listener: (context, state) {
        if (state is BrokerApprovalSuccessState) {
          print('BrokerApprovalSuccessState: ${state.message}');
          CustomSnackBar.show(context, message: state.message);

          // Delay pop to allow snackbar to render
          Future.delayed(const Duration(milliseconds: 200), () {
            Navigator.pop(context, true);
          });
        }
        if (state is BrokerApprovalErrorState) {
          CustomSnackBar.show(context, message: state.message, isError: true);
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: data['name'] ?? 'Broker Detail',
          preferredHeight: height * 0.12,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.035,
            vertical: height * 0.015,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileRow(label: 'Broker Name', value: data['name'] ?? 'N/A'),
              ProfileRow(label: 'Contact No.', value: data['mobileno'] ?? 'N/A'),
              ProfileRow(label: 'Address', value: data['address'] ?? 'N/A'),
              ProfileRow(label: 'City/Town', value: data['city'] ?? 'N/A'),
              ProfileRow(label: 'State', value: data['state'] ?? 'N/A'),
              ProfileRow(label: 'Status', value: data['status'] ?? 'N/A'),
              ProfileRow(label: 'Created At', value: formatToISTFull(data['createdAt'])),
              AppDimensions.h30(context),

              // Show Approve/Reject buttons only if status is pending
              if ((data['status']?.toLowerCase() ?? '').contains('pending')) ...[
                PrimaryButton(
                  text: 'Approve',
                  onPressed: () {
                    context.read<BrokerBloc>().add(
                      ApproveRejectBrokerEvent(
                        brokerId: data['_id'],
                        status: 'Approve',
                      ),
                    );
                  },
                ),
                AppDimensions.h10(context),
                ReusableOutlinedButton(
                  text: 'Reject',
                  onPressed: () {
                    context.read<BrokerBloc>().add(
                      ApproveRejectBrokerEvent(
                        brokerId: data['_id'],
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
    );
  }
}
