import 'dart:io';
import 'package:flutter/material.dart' hide OutlinedButton;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../utils/flutter_font_styles.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../widgets/primary_and_outlined_button.dart';
import '../../../widgets/reusable_appbar.dart';
import '../../../widgets/reusable_functions.dart';

class LoadingProductScreen extends StatefulWidget {
  final dynamic userData;
  const LoadingProductScreen({super.key, required this.userData});

  @override
  State<LoadingProductScreen> createState() => _LoadingProductScreenState();
}

class _LoadingProductScreenState extends State<LoadingProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  // Form fields
  String? driverName, driverPhone, ownerName, ownerPhone;
  String? initialWeight, finalWeight;

  // Uploaded files
  File? rcFile, licenseFile, aadharFile, deliveryProof;

  // ---- UI START ----
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: const ReusableAppBar(title: 'Ramesh Yadav'),
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
                // ===== CUSTOMER DETAILS =====
                _buildReadOnlyField('Name', 'Rahul'),
                _buildReadOnlyField('Address', '122/22, Ram Colony'),
                _buildReadOnlyField('City/Town', 'Gorakhpur'),
                _buildReadOnlyField('Item', 'Rice'),
                _buildReadOnlyField('Qty', '112 Qntl'),
                AppDimensions.h20(context),

                _buildSectionTitle('Enter Vehicle Details'),
                AppDimensions.h10(context),

                ReusableTextField(
                  label: 'Driver Name',
                  hint: 'Enter Name',
                  onChanged: (val) => setState(() => driverName = val),
                  validator: (val) => val!.isEmpty ? 'Enter Driver Name' : null,
                ),
                AppDimensions.h10(context),
                ReusableTextField(
                  label: 'Driver Phone No.',
                  hint: 'Enter Number',
                  keyboardType: TextInputType.phone,
                  onChanged: (val) => setState(() => driverPhone = val),
                  validator: (val) => val!.isEmpty ? 'Enter Driver Number' : null,
                ),
                AppDimensions.h10(context),
                ReusableTextField(
                  label: 'Owner Name',
                  hint: 'Enter Name',
                  onChanged: (val) => setState(() => ownerName = val),
                  validator: (val) => val!.isEmpty ? 'Enter Owner Name' : null,
                ),
                AppDimensions.h10(context),
                ReusableTextField(
                  label: 'Owner Phone No.',
                  hint: 'Enter Phone No.',
                  keyboardType: TextInputType.phone,
                  onChanged: (val) => setState(() => ownerPhone = val),
                  validator: (val) => val!.isEmpty ? 'Enter Owner Number' : null,
                ),
                AppDimensions.h10(context),

                // ---- Upload Fields ----
                _buildUploadField('Vehicle RC', rcFile, (file) => rcFile = file),
                _buildUploadField('Driver License', licenseFile, (file) => licenseFile = file),
                _buildUploadField('Driver Aadhar Card', aadharFile, (file) => aadharFile = file),

                AppDimensions.h20(context),
                OutlinedButton(
                  text: 'Save',
                  onPressed: _onSavePressed,
                ),
                AppDimensions.h30(context),

                // ===== WEIGHT SECTION =====
                _buildSectionTitle('Weight'),
                AppDimensions.h10(context),

                ReusableTextField(
                  label: 'Initial Wt',
                  hint: 'Enter Weight',
                  onChanged: (val) => setState(() => initialWeight = val),
                  validator: (val) => val!.isEmpty ? 'Enter Initial Weight' : null,
                ),
                AppDimensions.h10(context),
                ReusableTextField(
                  label: 'Final Wt',
                  hint: 'Enter Wt',
                  onChanged: (val) => setState(() => finalWeight = val),
                  validator: (val) => val!.isEmpty ? 'Enter Final Weight' : null,
                ),
                AppDimensions.h20(context),

                _buildSectionTitle('Delivery Proof'),
                AppDimensions.h10(context),
                _buildUploadField('Upload Delivery Proof', deliveryProof, (file) => deliveryProof = file),
                AppDimensions.h30(context),

                PrimaryButton(
                  text: 'Submit',
                  onPressed: _onSubmitPressed,
                ),
                AppDimensions.h30(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---- FUNCTIONS ----
  void _onSavePressed() {
    if (_formKey.currentState!.validate()) {
      CustomSnackBar.show(context, message: 'Vehicle details saved successfully!');
    }
  }

  void _onSubmitPressed() {
    if (_formKey.currentState!.validate()) {
      CustomSnackBar.show(context, message: 'Form submitted successfully!');
    }
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
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () async {
                Navigator.of(context).pop();
                final picked = await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
                if (picked != null) setState(() => onFilePicked(File(picked.path)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () async {
                Navigator.of(context).pop();
                final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                if (picked != null) setState(() => onFilePicked(File(picked.path)));
              },
            ),
          ],
        ),
      ),
    );
  }

  // ---- UI HELPERS ----
  Widget _buildReadOnlyField(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyText),
        Flexible(child: Text(value, style: AppTextStyles.profileDataText, overflow: TextOverflow.ellipsis)),
      ],
    ),
  );

  Widget _buildSectionTitle(String title) => Text(title, style: AppTextStyles.appbarTitle);

  Widget _buildUploadField(String label, File? file, Function(File) onFilePicked) {
    return GestureDetector(
      onTap: () => _pickImage(onFilePicked),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(file == null ? label : 'Uploaded: ${file.path.split('/').last}',
                style: AppTextStyles.bodyText),
            const Icon(Icons.upload, color: Colors.deepPurple),
          ],
        ),
      ),
    );
  }
}
