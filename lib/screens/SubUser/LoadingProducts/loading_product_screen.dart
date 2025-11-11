import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/material.dart' hide OutlinedButton;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shree_ram_staff/Constants/ApiConstants.dart';
import '../../../Bloc/SalesBloc/sales_bloc.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../Utils/image_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/flutter_font_styles.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../widgets/primary_and_outlined_button.dart';
import '../../../widgets/reusable_appbar.dart';
import '../../../widgets/reusable_functions.dart';

class LoadingProductScreen extends StatefulWidget {
  final dynamic salesData;
  const LoadingProductScreen({super.key, required this.salesData});

  @override
  State<LoadingProductScreen> createState() => _LoadingProductScreenState();
}

class _LoadingProductScreenState extends State<LoadingProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;
  bool isSaved = false;

  // --- Controllers ---
  late TextEditingController driverNameController;
  late TextEditingController driverPhoneController;
  late TextEditingController ownerNameController;
  late TextEditingController ownerPhoneController;

  String? initialWeight, finalWeight;
  dynamic userData = [];

  // Local files
  File? rcFileLocal, licenseFileLocal, aadharFileLocal, deliveryProofLocal;

  // Network URLs for display only
  String? rcFileUrl, licenseFileUrl, aadharFileUrl, deliveryProofUrl;

  @override
  void initState() {
    super.initState();
    userData = widget.salesData ?? [];

    final loading = userData['loadingDetails'];
    driverNameController = TextEditingController(text: loading?['drivername'] ?? '');
    driverPhoneController = TextEditingController(text: loading?['phoneno'] ?? '');
    ownerNameController = TextEditingController(text: loading?['ownername'] ?? '');
    ownerPhoneController = TextEditingController(text: loading?['ownerphoneno'] ?? '');

    // Prefill network URLs only (display)
    rcFileUrl = loading?['vehiclerc'] != null ? '${ApiConstants.imageUrl}${loading['vehiclerc']}' : null;
    licenseFileUrl = loading?['driverlicence'] != null ? '${ApiConstants.imageUrl}${loading['driverlicence']}' : null;
    aadharFileUrl = loading?['adharcard'] != null ? '${ApiConstants.imageUrl}${loading['adharcard']}' : null;

    // If all required vehicle fields exist, mark as saved
    if (driverNameController.text.isNotEmpty &&
        driverPhoneController.text.isNotEmpty &&
        ownerNameController.text.isNotEmpty &&
        ownerPhoneController.text.isNotEmpty &&
        rcFileUrl != null &&
        licenseFileUrl != null &&
        aadharFileUrl != null) {
      isSaved = true;
    }

    driverNameController.addListener(() => setState(() {}));
    driverPhoneController.addListener(() => setState(() {}));
    ownerNameController.addListener(() => setState(() {}));
    ownerPhoneController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    driverNameController.dispose();
    driverPhoneController.dispose();
    ownerNameController.dispose();
    ownerPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return BlocListener<SalesBloc, SalesState>(
      listener: (context, state) {
        if (state is SalesLoading) {
          setState(() => isLoading = true);
        } else {
          setState(() => isLoading = false);
        }

        if (state is SalesLoadingUpsertSuccess) {
          final message = state.isSave
              ? 'Product saved successfully!'
              : state.data['message'] ?? 'Product loaded successfully!';
          CustomSnackBar.show(context, message: message);

          if (state.isSave) {
            setState(() => isSaved = true);
          } else {
            Navigator.pop(context, true); // only on Submit
          }
        } else if (state is SalesError) {
          CustomSnackBar.show(context, message: state.message, isError: true);
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: ReusableAppBar(title: userData['customername'] ?? 'Loading'),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.035,
              vertical: height * 0.015,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildReadOnlyField('Name', userData['customername'] ?? '~'),
                  _buildReadOnlyField('Address', userData['address'] ?? '~'),
                  _buildReadOnlyField('City/Town', userData['city'] ?? '~'),
                  if (userData['items'] != null &&
                      userData['items'] is List &&
                      userData['items'].isNotEmpty)
                    ...List.generate(userData['items'].length, (index) {
                      final item = userData['items'][index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Item ${index + 1}', style: AppTextStyles.bodyText),
                            Flexible(
                              child: Text(
                                '${item['item'] ?? 'N/A'} (${item['bags'] ?? 0} bags)',
                                style: AppTextStyles.profileDataText,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  AppDimensions.h20(context),

                  _buildSectionTitle('Enter Vehicle Details'),
                  AppDimensions.h10(context),
                  ReusableTextField(
                    controller: driverNameController,
                    label: 'Driver Name',
                    hint: 'Enter Name',
                    textCapitalization: TextCapitalization.words,
                    validator: (val) => val!.isEmpty ? 'Enter Driver Name' : null,
                  ),
                  AppDimensions.h10(context),
                  ReusableTextField(
                    controller: driverPhoneController,
                    label: 'Driver Phone No.',
                    hint: 'Enter Number',
                    keyboardType: TextInputType.phone,
                    validator: (val) => val!.isEmpty ? 'Enter Driver Number' : null,
                  ),
                  AppDimensions.h10(context),
                  ReusableTextField(
                    controller: ownerNameController,
                    label: 'Owner Name',
                    hint: 'Enter Name',
                    textCapitalization: TextCapitalization.words,
                    validator: (val) => val!.isEmpty ? 'Enter Owner Name' : null,
                  ),
                  AppDimensions.h10(context),
                  ReusableTextField(
                    controller: ownerPhoneController,
                    label: 'Owner Phone No.',
                    hint: 'Enter Phone No.',
                    keyboardType: TextInputType.phone,
                    validator: (val) => val!.isEmpty ? 'Enter Owner Number' : null,
                  ),
                  AppDimensions.h10(context),

                  Text('Vehicle RC', style: AppTextStyles.label),
                  _buildUploadField('Upload RC', rcFileLocal, rcFileUrl, (file) => setState(() => rcFileLocal = file), height, width),
                  Text('Driver License', style: AppTextStyles.label),
                  _buildUploadField('Upload License', licenseFileLocal, licenseFileUrl, (file) => setState(() => licenseFileLocal = file), height, width),
                  Text('Driver Aadhar Card', style: AppTextStyles.label),
                  _buildUploadField('Upload Aadhar', aadharFileLocal, aadharFileUrl, (file) => setState(() => aadharFileLocal = file), height, width),
                  AppDimensions.h20(context),

                  ReusableOutlinedButton(
                    text: 'Save',
                    onPressed: isSaved || isLoading ? null : _onSavePressed,
                    isLoading: isLoading,
                  ),
                  AppDimensions.h30(context),

                  _buildSectionTitle('Weight'),
                  AppDimensions.h10(context),
                  ReusableTextField(
                    label: 'Initial Wt',
                    hint: 'Enter Weight',
                    onChanged: (val) => initialWeight = val,
                    validator: (val) => val!.isEmpty ? 'Enter Initial Weight' : null,
                  ),
                  AppDimensions.h10(context),
                  ReusableTextField(
                    label: 'Final Wt',
                    hint: 'Enter Wt',
                    onChanged: (val) => finalWeight = val,
                    validator: (val) => val!.isEmpty ? 'Enter Final Weight' : null,
                  ),
                  AppDimensions.h20(context),

                  _buildSectionTitle('Delivery Proof'),
                  AppDimensions.h10(context),
                  _buildUploadField('Upload Delivery Proof', deliveryProofLocal, deliveryProofUrl, (file) => setState(() => deliveryProofLocal = file), height, width),
                  AppDimensions.h30(context),

                  PrimaryButton(
                    text: 'Submit',
                    onPressed: isLoading ? null : _onSubmitPressed,
                    isLoading: isLoading,
                  ),
                  AppDimensions.h30(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmitPressed() {
    if (!isSaved) {
      CustomSnackBar.show(context, message: 'Please save vehicle details first', isError: true);
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    context.read<SalesBloc>().add(
      UpsertLoadingEvent(
        salesLeadId: userData['_id'] ?? '',
        driverName: driverNameController.text,
        phoneNo: driverPhoneController.text,
        ownerName: ownerNameController.text,
        ownerPhoneNo: ownerPhoneController.text,
        initialWeight: initialWeight ?? '',
        finalWeight: finalWeight ?? '',
        adharCard: aadharFileLocal,
        driverLicence: licenseFileLocal,
        vehicleRC: rcFileLocal,
        deliveryProof: deliveryProofLocal,
        isSave: false,
      ),
    );
  }

  Future<void> _pickImage(Function(File) onFilePicked) async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      CustomSnackBar.show(context, message: 'Camera permission denied', isError: true);
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: () async {
              Navigator.pop(context);
              final picked = await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
              if (picked != null) onFilePicked(File(picked.path));
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Gallery'),
            onTap: () async {
              Navigator.pop(context);
              final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
              if (picked != null) onFilePicked(File(picked.path));
            },
          ),
        ]),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyText),
        Flexible(
          child: Text(value, style: AppTextStyles.profileDataText, overflow: TextOverflow.ellipsis),
        ),
      ],
    ),
  );

  Widget _buildSectionTitle(String title) => Text(title, style: AppTextStyles.appbarTitle);

  Widget _buildUploadField(String label, File? fileLocal, String? fileUrl, Function(File) onFilePicked, double height, double width) {
    String displayText = label;

    if (fileLocal != null) {
      displayText = 'Uploaded: ${fileLocal.path.split('/').last}';
    } else if (fileUrl != null) {
      displayText = 'Uploaded: ${fileUrl.split('/').last}';
    }

    return GestureDetector(
      onTap: () => _pickImage(onFilePicked),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.015),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(displayText, style: AppTextStyles.bodyText, overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 8),
            Image.asset(ImageAssets.uploadIcon, color: AppColors.primaryColor, height: 25),
          ],
        ),
      ),
    );
  }

  void _onSavePressed() {
    if (driverNameController.text.isEmpty) {
      CustomSnackBar.show(context, message: 'Enter Driver Name', isError: true);
      return;
    }
    if (driverPhoneController.text.isEmpty) {
      CustomSnackBar.show(context, message: 'Enter Driver Phone', isError: true);
      return;
    }
    if (ownerNameController.text.isEmpty) {
      CustomSnackBar.show(context, message: 'Enter Owner Name', isError: true);
      return;
    }
    if (ownerPhoneController.text.isEmpty) {
      CustomSnackBar.show(context, message: 'Enter Owner Phone', isError: true);
      return;
    }

    context.read<SalesBloc>().add(
      UpsertLoadingEvent(
        salesLeadId: userData['_id'] ?? '',
        driverName: driverNameController.text,
        phoneNo: driverPhoneController.text,
        ownerName: ownerNameController.text,
        ownerPhoneNo: ownerPhoneController.text,
        adharCard: aadharFileLocal,
        driverLicence: licenseFileLocal,
        vehicleRC: rcFileLocal,
        isSave: true,
      ),
    );
  }
}
