import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shree_ram_staff/Bloc/QCBloc/qc_bloc.dart';
import 'package:shree_ram_staff/Utils/image_assets.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../Utils/app_routes.dart';
import '../../../utils/flutter_font_styles.dart';
import '../../../utils/app_colors.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../widgets/primary_and_outlined_button.dart';
import '../../../widgets/reusable_appbar.dart';
import '../../../widgets/reusable_functions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QualityCheckSubmitPage extends StatefulWidget {
  final dynamic userData;
  const QualityCheckSubmitPage({super.key, required this.userData});

  @override
  State<QualityCheckSubmitPage> createState() => _QualityCheckSubmitPageState();
}

class _QualityCheckSubmitPageState extends State<QualityCheckSubmitPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;
  File? uploadedProof;
  String? finalWeight;

  // Groups for form entries
  List<Map<String, String?>> paddyGroups = [
    {
      'paddyType': null,
      'paddyBags': null,
      'paddyMoisture': null,
      'paddyRiceQty': null,
      'paddyHuskQty': null,
      'paddyDiscolor': null,
    },
  ];

  List<Map<String, String?>> riceGroups = [
    {
      'riceType': null,
      'riceBags': null,
      'riceDiscolor': null,
      'riceBroken': null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: const ReusableAppBar(title: '#22311'),
        body: BlocListener<QcBloc, QcState>(
          listener: (context, state) {
            if (state is FinalQcLoadingState) {
              setState(() => isLoading = true);
            } else if (state is FinalQcSuccessState) {
              setState(() => isLoading = false);
              CustomSnackBar.show(
                context,
                message: 'QC submitted successfully!',
              );
              Navigator.of(context).popUntil((route) {
                if (route.settings.name == AppRoutes.deliveryPage) {
                  Navigator.of(context).pop(true);
                  return true;
                }
                return false;
              });
            } else if (state is FinalQcErrorState) {
              setState(() => isLoading = false);
              CustomSnackBar.show(
                context,
                message: state.message,
                isError: true,
              );
              developer.log('QC Error: ${state.message}');
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
                  _buildSectionTitle('Enter Paddy QC details'),
                  AppDimensions.h20(context),
                  ...List.generate(paddyGroups.length, (index) {
                    final group = paddyGroups[index];
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ReusableTextField(
                                actionLabel: index == 0 ? 'Add another type' : 'Remove'                         ,
                                onActionTap: () {
                                  if (index == 0) {
                                    setState(() {
                                      paddyGroups.add({
                                        'paddyType': null,
                                        'paddyBags': null,
                                        'paddyMoisture': null,
                                        'paddyRiceQty': null,
                                        'paddyHuskQty': null,
                                        'paddyDiscolor': null,
                                      });
                                    });
                                  }
                                  if (index != 0) {
                                    setState(() {
                                      paddyGroups.removeAt(index);
                                    });
                                  }
                                },
                                label: 'Paddy Type',
                                hint: 'Enter Paddy Type',
                                onChanged: (val) => group['paddyType'] = val,
                                validator: (val) => val == null || val.isEmpty
                                    ? 'Please enter paddy type'
                                    : null,
                              ),
                            ),
                            AppDimensions.w10(context),
                          ],
                        ),
                        AppDimensions.h10(context),
                        ReusableTextField(
                          label: 'Bags',
                          hint: 'Enter Bags',
                          onChanged: (val) => group['paddyBags'] = val,
                          validator: (val) => val == null || val.isEmpty
                              ? 'Please enter bags'
                              : null,
                          keyboardType: TextInputType.number,
                        ),
                        ReusableTextField(
                          label: 'Moisture %',
                          hint: 'Enter Moisture %',
                          onChanged: (val) => group['paddyMoisture'] = val,
                          keyboardType: TextInputType.number,
                          validator: (val) => val == null || val.isEmpty
                              ? 'Please enter moisture %'
                              : null,
                        ),
                        ReusableTextField(
                          label: 'Rice (g)',
                          hint: 'Enter Rice Quantity',
                          onChanged: (val) => group['paddyRiceQty'] = val,
                          keyboardType: TextInputType.number,
                          validator: (val) => val == null || val.isEmpty
                              ? 'Please enter rice quantity'
                              : null,
                        ),
                        ReusableTextField(
                          label: 'Husk (g)',
                          hint: 'Enter Husk Quantity',
                          onChanged: (val) => group['paddyHuskQty'] = val,
                          keyboardType: TextInputType.number,
                          validator: (val) => val == null || val.isEmpty
                              ? 'Please enter husk quantity'
                              : null,
                        ),
                        ReusableTextField(
                          label: 'Discolor %',
                          hint: 'Enter Discolor %',
                          onChanged: (val) => group['paddyDiscolor'] = val,
                          keyboardType: TextInputType.number,
                          validator: (val) => val == null || val.isEmpty
                              ? 'Please enter discolor %'
                              : null,
                        ),
                        AppDimensions.h20(context),
                        if (index != paddyGroups.length - 1)
                          const Divider(thickness: 1),
                        AppDimensions.h10(context),
                      ],
                    );
                  }),
                  _buildSectionTitle('Enter Rice QC details'),
                  AppDimensions.h20(context),
                  ...List.generate(riceGroups.length, (index) {
                    final group = riceGroups[index];
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ReusableTextField(
                                actionLabel: index == 0 ? 'Add another paddy' : 'Remove'                         ,
                                label: 'Rice Type',
                                hint: 'Enter Rice Type',
                                onChanged: (val) => group['riceType'] = val,
                                validator: (val) => val == null || val.isEmpty
                                    ? 'Please enter rice type'
                                    : null,
                                onActionTap: () {
                                  if (index == 0) {
                                    setState(() {
                                      riceGroups.add({
                                        'riceType': null,
                                        'riceBags': null,
                                        'riceDiscolor': null,
                                        'riceBroken': null,
                                      });
                                    });
                                  }
                                  if (index != 0) {
                                    setState(() {
                                      riceGroups.removeAt(index);
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        AppDimensions.h10(context),
                        ReusableTextField(
                          label: 'Bags',
                          hint: 'Enter Bags',
                          onChanged: (val) => group['riceBags'] = val,
                          validator: (val) => val == null || val.isEmpty
                              ? 'Please enter bags'
                              : null,
                          keyboardType: TextInputType.number,
                        ),
                        ReusableTextField(
                          label: 'Discolor %',
                          hint: 'Enter Discolor %',
                          onChanged: (val) => group['riceDiscolor'] = val,
                          keyboardType: TextInputType.number,
                          validator: (val) => val == null || val.isEmpty
                              ? 'Please enter discolor %'
                              : null,
                        ),
                        ReusableTextField(
                          label: 'Broken %',
                          hint: 'Enter Broken %',
                          onChanged: (val) => group['riceBroken'] = val,
                          keyboardType: TextInputType.number,
                          validator: (val) => val == null || val.isEmpty
                              ? 'Please enter broken %'
                              : null,
                        ),
                        if (index != riceGroups.length - 1) ...[
                          AppDimensions.h20(context),
                          const Divider(thickness: 1),
                        ],
                        AppDimensions.h10(context),
                      ],
                    );
                  }),
                  ReusableTextField(
                    label: 'Final Wt.',
                    hint: 'Enter total final weight',
                    onChanged: (val) => finalWeight = val,
                    initialValue: finalWeight,
                    validator: (val) => val == null || val.isEmpty
                        ? 'Please enter final weight'
                        : null,
                  ),
                  AppDimensions.h10(context),
                  _buildSectionTitle('Delivery Proof'),
                  AppDimensions.h10(context),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.035,
                        vertical: height * 0.015,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              uploadedProof == null
                                  ? 'Upload Delivery Proof'
                                  : 'Proof Selected: ${uploadedProof!.path.split('/').last}',
                              style: AppTextStyles.hintText,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Image.asset(
                            ImageAssets.uploadIcon,
                            color: AppColors.primaryColor,
                            height: 25,
                          ),
                        ],
                      ),
                    ),
                  ),
                  AppDimensions.h30(context),
                  PrimaryButton(
                    text: 'Submit',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (uploadedProof == null) {
                          CustomSnackBar.show(
                            context,
                            message: 'Please upload delivery proof',
                            isError: true,
                          );
                          return;
                        }

                        List<Map<String, dynamic>>
                        paddyPayload = paddyGroups.map((group) {
                          return {
                            "type": group['paddyType'],
                            "subtype": group['paddyType'],
                            "bags":
                                int.tryParse(group['paddyBags'] ?? '0') ?? 0,
                            "moisture":
                                double.tryParse(
                                  group['paddyMoisture'] ?? '0',
                                ) ??
                                0,
                            "rice":
                                double.tryParse(group['paddyRiceQty'] ?? '0') ??
                                0,
                            "husk":
                                double.tryParse(group['paddyHuskQty'] ?? '0') ??
                                0,
                            "discolor":
                                double.tryParse(
                                  group['paddyDiscolor'] ?? '0',
                                ) ??
                                0,
                            "weight": finalWeight ?? '',
                          };
                        }).toList();

                        List<Map<String, dynamic>>
                        ricePayload = riceGroups.map((group) {
                          return {
                            "type": group['riceType'],
                            "subtype": group['riceType'],
                            "bags": int.tryParse(group['riceBags'] ?? '0') ?? 0,
                            "discolor":
                                double.tryParse(group['riceDiscolor'] ?? '0') ??
                                0,
                            "broken":
                                double.tryParse(group['riceBroken'] ?? '0') ??
                                0,
                            "weight": finalWeight ?? '',
                          };
                        }).toList();

                        context.read<QcBloc>().add(
                          SubmitFinalQcEvent(
                            qcNumber: widget.userData['qcNumber'] ?? '',
                            paddyQc: paddyPayload,
                            riceQc: ricePayload,
                            deliveryProof: uploadedProof,
                            transportId:
                                widget.userData['transportId']['_id'] ?? '',
                            finalWeight: finalWeight ?? '',
                          ),
                        );
                      }
                    },
                    isLoading: isLoading,
                  ),
                  AppDimensions.h20(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) =>
      Text(title, style: AppTextStyles.appbarTitle);

  Future<void> _pickImage() async {
    final permission = await Permission.camera.request();
    if (!permission.isGranted) {
      CustomSnackBar.show(
        context,
        message: "Camera permission denied.",
        isError: true,
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () async {
                Navigator.of(context).pop();
                final file = await _picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 80,
                );
                if (file != null)
                  setState(() => uploadedProof = File(file.path));
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () async {
                Navigator.of(context).pop();
                final file = await _picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 80,
                );
                if (file != null)
                  setState(() => uploadedProof = File(file.path));
              },
            ),
          ],
        ),
      ),
    );
  }
}
