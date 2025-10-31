import 'package:flutter/material.dart';
import 'package:shree_ram_staff/widgets/reusable_appbar.dart';
import 'package:shree_ram_staff/Constants/app_dimensions.dart';
import '../../../utils/flutter_font_styles.dart';
import '../../../widgets/primary_and_outlined_button.dart';
import '../../../widgets/reusable_functions.dart';

class CreateSubUserPage extends StatefulWidget {
  final subUserData;
  const CreateSubUserPage({super.key, required this.subUserData});

  @override
  State<CreateSubUserPage> createState() => _CreateSubUserPageState();
}

class _CreateSubUserPageState extends State<CreateSubUserPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _salaryController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _selectedFactory;
  String? _selectedRole;
  String? _selectedAuthority;

  final List<String> factories = ['Select Factory', 'Factory A', 'Factory B'];
  final List<String> roles = ['Select Role', 'Manager', 'Staff', 'Loader'];
  final List<String> authorities = ['Select Authority', 'Full', 'Limited'];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: const ReusableAppBar(title: 'Create Sub user'),
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
                ReusableTextField(
                  label: 'Name',
                  hint: 'Enter Name',
                  controller: _nameController,
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Enter Name' : null,
                ),
                AppDimensions.h10(context),

                ReusableTextField(
                  label: 'Phone Number',
                  hint: 'Enter Phone Number',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Enter Phone Number';
                    if (val.length < 10) return 'Enter valid number';
                    return null;
                  },
                ),
                AppDimensions.h10(context),

                ReusableTextField(
                  label: 'Salary',
                  hint: 'Enter Salary',
                  controller: _salaryController,
                  keyboardType: TextInputType.number,
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Enter Salary' : null,
                ),
                AppDimensions.h10(context),
                Text('Factory', style: AppTextStyles.label),
                AppDimensions.h5(context),
                ReusableDropdown(
                  items: factories,
                  value: _selectedFactory ?? factories.first,
                  onChanged: (val) => setState(() => _selectedFactory = val),
                  hintText: 'Select Factory',
                  validator: (val) => val == null || val == factories.first
                      ? 'Select Factory'
                      : null,
                ),
                AppDimensions.h10(context),
                Text('Role', style: AppTextStyles.label),
                AppDimensions.h5(context),
                ReusableDropdown(
                  items: roles,
                  value: _selectedRole ?? roles.first,
                  onChanged: (val) => setState(() => _selectedRole = val),
                  hintText: 'Select Role',
                  validator: (val) =>
                      val == null || val == roles.first ? 'Select Role' : null,
                ),
                AppDimensions.h10(context),
                Text('Authority', style: AppTextStyles.label),
                AppDimensions.h5(context),
                ReusableDropdown(
                  items: authorities,
                  value: _selectedAuthority ?? authorities.first,
                  onChanged: (val) => setState(() => _selectedAuthority = val),
                  hintText: 'Select Authority',
                  validator: (val) => val == null || val == authorities.first
                      ? 'Select Authority'
                      : null,
                ),
                AppDimensions.h10(context),

                ReusableTextField(
                  label: 'Password',
                  hint: 'Enter Password',
                  controller: _passwordController,
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Enter Password' : null,
                ),
                AppDimensions.h10(context),

                ReusableTextField(
                  label: 'Confirm Password',
                  hint: 'Enter Password',
                  controller: _confirmPasswordController,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Confirm Password';
                    if (val != _passwordController.text)
                      return 'Passwords do not match';
                    return null;
                  },
                ),
                AppDimensions.h30(context),

                PrimaryButton(
                  text: 'Submit',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // handle submit
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
