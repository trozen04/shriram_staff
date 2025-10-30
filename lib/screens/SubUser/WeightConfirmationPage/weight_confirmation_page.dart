import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../Constants/app_dimensions.dart';
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
  final ImagePicker _picker = ImagePicker();

  File? uploadedPhoto;

  String? initialWeight;
  String? moisturePercent;
  String? riceWeight;
  String? huskWeight;
  String? discolorPercent;
  DateTime? expectedDeliveryDate;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ReusableAppBar(title: 'Delivery & Initial QC'),
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
              _buildReadOnlyField('Vehicle No.', 'DL 12 AB 2198'),
              _buildReadOnlyField('Driver', 'Ram'),
              _buildReadOnlyField('Quantity', '50 Qntl'),
              _buildReadOnlyField('Date', '20/09/2025'),
              AppDimensions.h20(context),

              _buildSectionTitle('Initial Weight & Initial QC'),
              AppDimensions.h20(context),

              ReusableTextField(
                label: 'Initial Weight',
                hint: 'Enter Initial Weight',
                onChanged: (val) => setState(() => initialWeight = val),
                validator: (val) => val!.isEmpty ? 'Please enter the initial weight' : null,
              ),
              AppDimensions.h10(context),

              ReusableTextField(
                label: 'Moisture %',
                hint: 'Enter Moisture %',
                onChanged: (val) => setState(() => moisturePercent = val),
                validator: (val) => val!.isEmpty ? 'Please enter the moisture percentage' : null,
              ),
              AppDimensions.h10(context),

              Text('Rice in (g)', style: AppTextStyles.label),
              AppDimensions.h5(context),
              ReusableDropdown(
                items: ['1', '2', '3'],
                value: riceWeight,
                onChanged: (val) => setState(() => riceWeight = val),
                validator: (val) => val == null ? 'Please select the rice weight' : null,
                hintText: 'Select Rice Weight',
              ),
              AppDimensions.h10(context),

              ReusableTextField(
                label: 'Husk in (g)',
                hint: 'Enter Husk in (g)',
                onChanged: (val) => setState(() => huskWeight = val),
                validator: (val) => val!.isEmpty ? 'Please enter the husk weight' : null,
              ),
              AppDimensions.h10(context),

              ReusableTextField(
                label: 'Discolor %',
                hint: 'Enter Discolor %',
                onChanged: (val) => setState(() => discolorPercent = val),
                validator: (val) => val!.isEmpty ? 'Please enter the discolor percentage' : null,
              ),


              AppDimensions.h50(context),
              PrimaryButton(
                text: 'Submit',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    CustomSnackBar.show(
                      context,
                      message: "Form Submitted Successfully!",
                    );
                  }
                },
              ),
              AppDimensions.h20(context),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final cameraStatus = await Permission.camera.request();

    if (!cameraStatus.isGranted) {
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
                final XFile? pickedFile = await _picker.pickImage(
                    source: ImageSource.camera, imageQuality: 80);
                if (pickedFile != null) {
                  setState(() => uploadedPhoto = File(pickedFile.path));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () async {
                Navigator.of(context).pop();
                final XFile? pickedFile = await _picker.pickImage(
                    source: ImageSource.gallery, imageQuality: 80);
                if (pickedFile != null) {
                  setState(() => uploadedPhoto = File(pickedFile.path));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Text(
    title,
    style: AppTextStyles.appbarTitle,
  );

  Widget _buildReadOnlyField(String label, String value) => Padding(
    padding:
    EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.012),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: AppTextStyles.bodyText,
            overflow: TextOverflow.ellipsis),
        Text(value,
            style: AppTextStyles.profileDataText,
            overflow: TextOverflow.ellipsis),
      ],
    ),
  );

}
