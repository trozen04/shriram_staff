import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shree_ram_staff/Bloc/QCBloc/qc_bloc.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../utils/app_routes.dart';
import '../../../utils/flutter_font_styles.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../widgets/primary_and_outlined_button.dart';
import '../../../widgets/reusable_appbar.dart';
import '../../../widgets/reusable_functions.dart';

class WeightConfirmationPage extends StatefulWidget {
  final dynamic userData;
  const WeightConfirmationPage({super.key, required this.userData});

  @override
  State<WeightConfirmationPage> createState() => _WeightConfirmationPageState();
}

class _WeightConfirmationPageState extends State<WeightConfirmationPage> {
  final _formKey = GlobalKey<FormState>();
  File? uploadedPhoto;
  String? initialWeight;
  String? moisturePercent;
  String? riceWeight;
  String? huskWeight;
  String? discolorPercent;
  DateTime? expectedDeliveryDate;
  bool isLoading = false;
  dynamic data = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = widget.userData;
    developer.log('data: $data');
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const ReusableAppBar(title: 'Delivery & Initial QC'),
      body: BlocListener<QcBloc, QcState>(
        listener: (context, state) {
          if (state is CreateInitialQcLoadingState) {
            setState(() {
              isLoading = true;
            });
          } else if (state is CreateInitialQcSuccessState) {
            developer.log('CreateInitialQcSuccessState: ${state.responseData}');
            setState(() {
              isLoading = false;
            });
            CustomSnackBar.show(
              context,
              message: "Request Submitted Successfully!",
            );
            Navigator.pushNamed(
              context,
              AppRoutes.afterQcDetailPage,
              arguments: {
                'qcData': state.responseData,
                'userData': widget.userData,
              },
            );
            } else if (state is CreateInitialQcErrorState) {
            developer.log('CreateInitialQcSuccessState: ${state.message}');
            CustomSnackBar.show(
              context,
              message: state.message,
              isError: true
            );
            setState(() {
              isLoading = false;
            });
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.035,
            vertical: height * 0.015,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileRow(label: 'Vehicle No.', value: data['vehicleno']),
                // ProfileRow(label: 'Driver', value: data['vehicleno']),
                ProfileRow(label: 'Weight', value: data['weight']),
                ProfileRow(
                  label: 'Date',
                  value: formatToISTFull(data!['deliverydate']),
                ),

                AppDimensions.h20(context),

                _buildSectionTitle('Initial Weight & Initial QC'),
                AppDimensions.h20(context),

                ReusableTextField(
                  label: 'Initial Weight',
                  hint: 'Enter Initial Weight',
                  onChanged: (val) => setState(() => initialWeight = val),
                  validator: (val) =>
                      val!.isEmpty ? 'Please enter the initial weight' : null,
                ),
                AppDimensions.h10(context),

                ReusableTextField(
                  label: 'Moisture %',
                  hint: 'Enter Moisture %',
                  onChanged: (val) => setState(() => moisturePercent = val),
                  validator: (val) => val!.isEmpty
                      ? 'Please enter the moisture percentage'
                      : null,
                  keyboardType: TextInputType.number,
                ),
                AppDimensions.h10(context),

                ReusableTextField(
                  label: 'Rice in (g)',
                  hint: 'Enter Rice Weight',
                  onChanged: (val) => setState(() => riceWeight = val),
                  validator: (val) =>
                      val!.isEmpty ? 'Please enter the rice weight' : null,
                  keyboardType: TextInputType.number,
                ),

                AppDimensions.h10(context),

                ReusableTextField(
                  label: 'Husk in (g)',
                  hint: 'Enter Husk in (g)',
                  onChanged: (val) => setState(() => huskWeight = val),
                  validator: (val) =>
                      val!.isEmpty ? 'Please enter the husk weight' : null,
                  keyboardType: TextInputType.number,
                ),
                AppDimensions.h10(context),

                ReusableTextField(
                  label: 'Discolor %',
                  hint: 'Enter Discolor %',
                  onChanged: (val) => setState(() => discolorPercent = val),
                  validator: (val) => val!.isEmpty
                      ? 'Please enter the discolor percentage'
                      : null,
                  keyboardType: TextInputType.number,
                ),

                AppDimensions.h50(context),
                PrimaryButton(
                  text: 'Submit',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<QcBloc>().add(
                        CreateInitialQcEventHandler(
                          intialWeight: initialWeight!,
                          moisture: moisturePercent!,
                          ricein: '${riceWeight!} g',
                          huskin: '${huskWeight!} g',
                          discolor: discolorPercent!,
                          transportId: data['_id'],
                        ),
                      );

                    }
                  },
                  isLoading: isLoading
                ),
                AppDimensions.h20(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) =>
      Text(title, style: AppTextStyles.appbarTitle);
}
