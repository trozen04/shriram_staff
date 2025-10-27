import 'package:flutter/material.dart';
import '../../../utils/pref_utils.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/flutter_font_styles.dart';
import '../../../utils/image_assets.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/primary_and_outlined_button.dart';
import '../../../widgets/reusable_functions.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();

  // State variables
  bool _isLoading = false;
  bool _isOtpSent = false;

  @override
  void dispose() {
    // Dispose controllers to free up resources
    _phoneController.dispose();
    _otpController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  /// Handler for the "Get OTP" button
  Future<void> _getOtp() async {
    // Basic validation for phone number
    if (_phoneController.text.length != 10) {
      CustomSnackBar.show(
        context,
        message: "Please enter a valid 10-digit phone number.",
        isError: true,
      );
      return;
    }

    // Simulate API call to send OTP
    setState(() => _isOtpSent = true); // Update UI to indicate OTP is sent

    CustomSnackBar.show(
      context,
      message: "OTP has been sent to your number!",
      isError: false,
    );
  }

  Future<void> _register() async {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    // Validate the form
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      // Simulate a network request
      await Future.delayed(const Duration(seconds: 1));

      showDialog(
        context: context,
        builder: (context) => ReusablePopup(
          title: 'Thank you',
          message: 'Please wait till admin review your profile.',
          buttonText: 'Okay',
          onButtonPressed: () {
            Navigator.pop(context);
          },
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
      );
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: width * 0.035, vertical: height * 0.015),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // align labels to left
              children: [
                AppDimensions.h100(context),
                Align(
                  alignment: Alignment.center,
                  child: Text('Register', style: AppTextStyles.heading),
                ),
                AppDimensions.h10(context),
                Text(
                  'Register to access your shooting training, performance insights, and competition updates.',
                  style: AppTextStyles.bodyText,
                  textAlign: TextAlign.center,
                ),
                AppDimensions.h50(context),

                // Phone Number
                Text('Phone Number', style: AppTextStyles.label), // <-- Label
                AppDimensions.h5(context),
                CustomTextFormField(
                  controller: _phoneController,
                  hintText: 'Enter Phone Number',
                  prefixImagePath: ImageAssets.callImage,
                  prefix: Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Text(
                      '+91',
                        style: AppTextStyles.hintText
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  suffix: TextButton(
                    onPressed: _getOtp,
                    child: Text(
                      _isOtpSent ? 'Resend OTP' : 'Get OTP',
                      style:AppTextStyles.hintText.copyWith(fontSize: 10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Phone number is required';
                    if (value.length != 10) return 'Enter a valid 10-digit number';
                    return null;
                  },
                ),
                AppDimensions.h10(context),

                // OTP
                Text('OTP', style: AppTextStyles.label),
                AppDimensions.h5(context),
                CustomTextFormField(
                  controller: _otpController,
                  hintText: 'Enter OTP',
                  prefixImagePath: ImageAssets.passwordImage,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'OTP is required';
                    if (value.length < 4) return 'Enter a valid OTP';
                    return null;
                  },
                ),
                AppDimensions.h10(context),

                // Name
                Text('Name', style: AppTextStyles.label),
                AppDimensions.h5(context),
                CustomTextFormField(
                  controller: _nameController,
                  hintText: 'Enter Name',
                  validator: (value) => value == null || value.isEmpty ? 'Name is required' : null,
                ),
                AppDimensions.h10(context),

                // Address
                Text('Address', style: AppTextStyles.label),
                AppDimensions.h5(context),
                CustomTextFormField(
                  controller: _addressController,
                  hintText: 'Enter Address',
                  validator: (value) => value == null || value.isEmpty ? 'Address is required' : null,
                ),
                AppDimensions.h10(context),

                // State
                Text('State', style: AppTextStyles.label),
                AppDimensions.h5(context),
                CustomTextFormField(
                  controller: _stateController,
                  hintText: 'Enter State',
                  validator: (value) => value == null || value.isEmpty ? 'State is required' : null,
                ),
                AppDimensions.h10(context),

                // City
                Text('City', style: AppTextStyles.label),
                AppDimensions.h5(context),
                CustomTextFormField(
                  controller: _cityController,
                  hintText: 'Enter City',
                  validator: (value) => value == null || value.isEmpty ? 'City is required' : null,
                ),
                AppDimensions.h30(context),

                // Register Button
                PrimaryButton(
                  text: 'Register',
                  onPressed: _register,
                  isLoading: _isLoading,
                ),
                AppDimensions.h30(context),

                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Have an account? ", style: AppTextStyles.bodyText),
                    GestureDetector(
                      onTap: () {
                       // Navigator.of(context).pushNamed('/login');
                        Navigator.pop(context);
                      },
                      child: Text("Login", style: AppTextStyles.linkText),
                    ),
                  ],
                ),
                AppDimensions.h30(context),
              ],
            ),
          )

        ),
      ),
    );
  }
}