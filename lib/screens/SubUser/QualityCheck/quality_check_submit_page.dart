import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shree_ram_staff/Bloc/QCBloc/qc_bloc.dart';
import 'package:shree_ram_staff/Utils/image_assets.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../utils/app_routes.dart';
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

  /// Lists to hold multiple paddy/rice groups
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

  final List<String> paddyTypes = [
    'Select Paddy Type',
    'Type 1',
    'Type 2',
    'Type 3',
  ];
  final List<String> riceTypes = [
    'Select Rice Type',
    'Type A',
    'Type B',
    'Type C',
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
          setState(() {
            isLoading = true;
          });
      } else if (state is FinalQcSuccessState) {
        developer.log('FinalQcSuccessState: ${state.response}');
        setState(() {
          isLoading = false;
        });
        CustomSnackBar.show(
          context,
          message: "QC details submitted successfully!",
        );

        // Navigator.pop(context);
       /// Navigator.popUntil(context, ModalRoute.withName(AppRoutes.deliveryPage));

      } else if (state is FinalQcErrorState) {
        developer.log('FinalQcSuccessState: ${state.message}');
        setState(() {
          isLoading = false;
        });
        CustomSnackBar.show(
          context,
          message: state.message,
          isError: true,
        );
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

                /// Render multiple Paddy groups
                ...List.generate(paddyGroups.length, (index) {
                  final group = paddyGroups[index];
                  return Column(
                    children: [
                      _buildDropdownWithAddButton(
                        label: 'Paddy Type',
                        hint: 'Select Paddy Type',
                        items: paddyTypes,
                        value: group['paddyType'],
                        onChanged: (val) =>
                            setState(() => group['paddyType'] = val),
                        onAddPressed: () {
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
                        },
                        onRemovePressed: () {
                          setState(() => paddyGroups.removeAt(index));
                        },
                        index: index,
                        totalCount: paddyGroups.length,
                      ),

                      AppDimensions.h10(context),
                      ReusableTextField(
                        label: 'Bags',
                        hint: 'Enter Bags',
                        onChanged: (val) => group['paddyBags'] = val,
                      ),
                      AppDimensions.h10(context),
                      ReusableTextField(
                        label: 'Moisture %',
                        hint: 'Enter Moisture %',
                        onChanged: (val) => group['paddyMoisture'] = val,
                        keyboardType: TextInputType.number,
                      ),
                      AppDimensions.h10(context),
                      ReusableTextField(
                        label: 'Rice (g)',
                        hint: 'Enter quantity',
                        onChanged: (val) => group['paddyRiceQty'] = val,
                        keyboardType: TextInputType.number,
                      ),
                      AppDimensions.h10(context),
                      ReusableTextField(
                        label: 'Husk (g)',
                        hint: 'Enter quantity',
                        onChanged: (val) => group['paddyHuskQty'] = val,
                        keyboardType: TextInputType.number,
                      ),
                      AppDimensions.h10(context),
                      ReusableTextField(
                        label: 'Discolor %',
                        hint: 'Enter Discolor %',
                        onChanged: (val) => group['paddyDiscolor'] = val,
                        keyboardType: TextInputType.number,
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

                /// Render multiple Rice groups
                ...List.generate(riceGroups.length, (index) {
                  final group = riceGroups[index];
                  return Column(
                    children: [
                      _buildDropdownWithAddButton(
                        label: 'Rice Type',
                        hint: 'Select Rice Type',
                        items: riceTypes,
                        value: group['riceType'],
                        onChanged: (val) =>
                            setState(() => group['riceType'] = val),
                        onAddPressed: () {
                          setState(() {
                            riceGroups.add({
                              'riceType': null,
                              'riceBags': null,
                              'riceDiscolor': null,
                              'riceBroken': null,
                            });
                          });
                        },
                        onRemovePressed: () {
                          setState(() => riceGroups.removeAt(index));
                        },
                        index: index,
                        totalCount: riceGroups.length,
                        addText: 'Add another paddy',
                      ),


                      AppDimensions.h10(context),
                      ReusableTextField(
                        label: 'Bags',
                        hint: 'Enter Bags',
                        onChanged: (val) => group['riceBags'] = val,
                      ),
                      AppDimensions.h10(context),
                      ReusableTextField(
                        label: 'Discolor %',
                        hint: 'Enter Discolor %',
                        onChanged: (val) => group['riceDiscolor'] = val,
                        keyboardType: TextInputType.number,
                      ),
                      AppDimensions.h10(context),
                      ReusableTextField(
                        label: 'Broken %',
                        hint: 'Enter Broken %',
                        onChanged: (val) => group['riceBroken'] = val,
                        keyboardType: TextInputType.number,
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Convert all Paddy groups
                      final paddyList = paddyGroups.map((group) {
                        return {
                          "type": "Paddy",
                          "subtype": group['paddyType'] ?? '',
                          "bags": int.tryParse(group['paddyBags'] ?? '0') ?? 0,
                          "moisture": double.tryParse(group['paddyMoisture'] ?? '0') ?? 0,
                          "rice": "${group['paddyRiceQty'] ?? '0'} g",
                          "husk": "${group['paddyHuskQty'] ?? '0'} g",
                          "discolor": double.tryParse(group['paddyDiscolor'] ?? '0') ?? 0,
                        };
                      }).toList();

                      // Convert all Rice groups
                      final riceList = riceGroups.map((group) {
                        return {
                          "type": "Rice",
                          "subtype": group['riceType'] ?? '',
                          "bags": int.tryParse(group['riceBags'] ?? '0') ?? 0,
                          "discolor": double.tryParse(group['riceDiscolor'] ?? '0') ?? 0,
                          "broken": double.tryParse(group['riceBroken'] ?? '0') ?? 0,
                        };
                      }).toList();

                      context.read<QcBloc>().add(SubmitFinalQcEvent(
                        qcNumber: '#${widget.userData['_id']?.toString().substring(0, 6) ?? '000000'}',
                        paddyQc: List<Map<String, dynamic>>.from(paddyList),
                        riceQc: List<Map<String, dynamic>>.from(riceList),
                        deliveryProof: uploadedProof,
                        transportId: widget.userData['transportId']['_id'] ?? '',
                        finalWeight: finalWeight ?? '0',

                      ));
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

  Widget _buildDropdownWithAddButton({
    required String label,
    required String hint,
    required List<String> items,
    required String? value,
    required Function(String?) onChanged,
    required VoidCallback onAddPressed,
    required VoidCallback onRemovePressed,
    required int index,
    required int totalCount,
    String addText = 'Add another type',
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.label),
            Row(
              children: [
                if (index == totalCount - 1)
                  InkWell(
                    onTap: onAddPressed,
                    child: Text(addText, style: AppTextStyles.underlineText),
                  ),
                AppDimensions.w10(context),
                if (index != 0)
                  InkWell(
                    onTap: onRemovePressed,
                    child: const Icon(
                      Icons.remove_circle,
                      color: Colors.redAccent,
                    ),
                  ),
              ],
            ),
          ],
        ),
        AppDimensions.h5(context),
        ReusableDropdown(
          items: items,
          value: value,
          onChanged: onChanged,
          hintText: hint,
          validator: (val) => val == null || val == items.first
              ? 'Please select a ${label.toLowerCase()}'
              : null,
        ),
      ],
    );
  }

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
