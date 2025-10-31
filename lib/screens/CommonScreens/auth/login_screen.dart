import 'package:flutter/material.dart';
import 'package:shree_ram_staff/widgets/custom_snackbar.dart';
import '../../../utils/pref_utils.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/flutter_font_styles.dart';
import '../../../utils/image_assets.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/primary_and_outlined_button.dart';
import '../../SuperUser/Home/super_user_home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();

  bool _isOtpSent = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  /// Send OTP to the entered number
  Future<void> _sendOtp() async {
    if (_phoneController.text.length != 10) {
      CustomSnackBar.show(
        context,
        message: "Please enter a valid 10-digit phone number.",
        isError: true,
      );
      return;
    }

    setState(() => _isOtpSent = true);

    CustomSnackBar.show(
      context,
      message: "OTP sent successfully",
      isError: false,
    );
  }

  /// Verify OTP and login
  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      await Future.delayed(const Duration(seconds: 2));

      CustomSnackBar.show(
        context,
        message: "Login Successful!",
        isError: false,
      );
      setState(() => _isLoading = false);

      await PrefUtils.setLoggedIn(true);
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SuperUserHomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.035,
            vertical: height * 0.0,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppDimensions.h100(context),
                Align(
                  alignment: Alignment.center,
                  child: Text('Login', style: AppTextStyles.heading),
                ),
                AppDimensions.h10(context),
                Text(
                  'Login to access your shooting training, performance insights, and competition updates.',
                  style: AppTextStyles.bodyText,
                  textAlign: TextAlign.center,
                ),
                AppDimensions.h50(context),

                // Phone Number
                Text('Phone Number', style: AppTextStyles.label),
                AppDimensions.h5(context),
                CustomTextFormField(
                  controller: _phoneController,
                  hintText: 'Enter Phone Number',
                  prefixImagePath: ImageAssets.callImage,
                  prefix: Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Text('+91', style: AppTextStyles.hintText),
                  ),
                  keyboardType: TextInputType.phone,
                  suffix: TextButton(
                    onPressed: _sendOtp,
                    child: Text(
                      _isOtpSent ? 'Resend OTP' : 'Get OTP',
                      style: AppTextStyles.hintText.copyWith(fontSize: 10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Phone number is required';
                    if (value.length != 10)
                      return 'Enter a valid 10-digit number';
                    return null;
                  },
                ),

                AppDimensions.h10(context),

                // OTP Field
                Text('OTP', style: AppTextStyles.label),
                AppDimensions.h5(context),
                CustomTextFormField(
                  controller: _otpController,
                  hintText: 'Enter OTP',
                  prefixImagePath: ImageAssets.passwordImage,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (!_isOtpSent) return 'Please request OTP first';
                    if (value == null || value.isEmpty)
                      return 'OTP is required';
                    if (value.length < 4) return 'Enter valid OTP';
                    return null;
                  },
                ),
                AppDimensions.h30(context),

                // Login Button
                PrimaryButton(
                  text: 'Login',
                  onPressed: _login,
                  isLoading: _isLoading,
                ),
                AppDimensions.h30(context),

                // Register link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: AppTextStyles.bodyText,
                    ),
                    GestureDetector(
                      onTap: () {
                        // TODO: Navigate to Register Screen
                        Navigator.of(context).pushNamed('/register');
                      },
                      child: Text("Signup", style: AppTextStyles.linkText),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
