import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:shree_ram_staff/Bloc/AuthBloc/auth_bloc.dart';
import 'package:shree_ram_staff/screens/SubUser/Home/home_screen.dart';
import 'package:shree_ram_staff/widgets/custom_snackbar.dart';
import '../../../utils/pref_utils.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/flutter_font_styles.dart';
import '../../../utils/image_assets.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/primary_and_outlined_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../SuperUser/Home/super_user_home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Verify password and login
  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState == null) return;
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      CustomSnackBar.show(
        context,
        message: "Please fill all required fields correctly!",
        isError: true,
      );
      return;
    }

    context.read<AuthBloc>().add(
      LoginRequestEventHandler(
        phone: _phoneController.text.trim(),
        password: _passwordController.text.trim(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if(state is LoginLoading) {
      setState(() => _isLoading = true);
    } else if(state is LoginSuccess) {
      developer.log('login success: ${state.response}');
      setState(() => _isLoading = false);
      CustomSnackBar.show(
        context,
        message: state.response['message'] ?? 'Login successful',
      );
      developer.log('login success: ${state.response}');
      setState(() => _isLoading = false);

      final data = state.response['data'];
      final token = state.response['token'];
      final role = data['role'] ?? '';
      final id = data['id'] ?? '';
      final name = data['name'] ?? '';
      final mobile = data['mobileno'] ?? '';

      PrefUtils.setUserDetails(
        id: id,
        name: name,
        mobile: mobile,
        role: role,
        token: token,
      );

      PrefUtils.setLoggedIn(true);


      CustomSnackBar.show(
        context,
        message: state.response['message'] ?? 'Login successful',
      );

      // Navigate based on role
      if (role == 'superuser') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SuperUserHomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }

    } else if(state is LoginError) {
      developer.log('login error: ${state.message}');
      setState(() => _isLoading = false);
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
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Phone number is required';
                    if (value.length != 10)
                      return 'Enter a valid 10-digit number';
                    return null;
                  },
                ),

                AppDimensions.h10(context),

                // password Field
                Text('Password', style: AppTextStyles.label),
                AppDimensions.h5(context),
                CustomTextFormField(
                  controller: _passwordController,
                  hintText: 'Enter Password',
                  prefixImagePath: ImageAssets.passwordImage,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'password is required';
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
              ],
            ),
          ),
        ),
),
      ),
    );
  }
}
