import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shree_ram_staff/Bloc/FactoryBloc/factory_bloc.dart';
import 'package:shree_ram_staff/widgets/reusable_appbar.dart';
import 'package:shree_ram_staff/Constants/app_dimensions.dart';
import '../../../Bloc/SubUsers/subusers_bloc.dart';
import '../../../utils/flutter_font_styles.dart';
import '../../../widgets/custom_snackbar.dart';
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
  final _emailController = TextEditingController(); // replaced phone with email
  final _salaryController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();

  String? _selectedFactory;
  String? _selectedFactoryId;
  String? _selectedAuthority;

  bool isButtonLoading = false;
  bool isLoading = false;

  List<Map<String, String>> factoryList = [];
  final List<String> authorities = ['Select Authority', 'Full', 'Limited'];

  @override
  void initState() {
    super.initState();
    developer.log('subUserData: ${widget.subUserData}');
    if (widget.subUserData != null) {
      final data = widget.subUserData;

      _nameController.text = data['name'] ?? '';
      _emailController.text = data['email'] ?? ''; // replace phone with email
      _salaryController.text = data['salary']?.toString() ?? '';
      _addressController.text = data['address'] ?? '';

      // Authority
      if (data['authority'] != null &&
          authorities.contains(data['authority'])) {
        _selectedAuthority = data['authority'];
      } else {
        _selectedAuthority = authorities.first;
      }

      // Factory
      if (data['factory'] != null) {
        _selectedFactoryId = data['factory']['_id'];
        _selectedFactory = data['factory']['factoryname'];
      }
    } else {
      _selectedAuthority = authorities.first;
    }

    context.read<FactoryBloc>().add(FactoryEventHandler());
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: MultiBlocListener(
        listeners: [
          // Subusers Bloc
          BlocListener<SubusersBloc, SubusersState>(
            listener: (context, state) {
              if (state is SubusersLoadingState) {
                setState(() => isButtonLoading = true);
              } else {
                setState(() => isButtonLoading = false);
              }
              if (state is SubusersCreateSuccessState) {
                CustomSnackBar.show(
                  context,
                  message: "Subuser Created Successfully!",
                );
                Navigator.pop(context, true);
              }
              if (state is SubusersErrorState) {
                CustomSnackBar.show(
                  context,
                  message: state.message,
                  isError: true,
                );
              }
            },
          ),
          // Factory Bloc
          BlocListener<FactoryBloc, FactoryState>(
            listener: (context, state) {
              if (state is FactoryLoadingState) {
                setState(() => isLoading = true);
              } else {
                setState(() => isLoading = false);
              }
              if (state is FactorySuccessState) {
                factoryList = (state.factoryData['data'] as List)
                    .map(
                      (e) => {
                        '_id': e['_id'].toString(),
                        'name': e['factoryname'].toString(),
                      },
                    )
                    .toList();

                if (factoryList.isNotEmpty) {
                  _selectedFactory = factoryList.first['name'];
                  _selectedFactoryId = factoryList.first['_id'];
                }
                setState(() {});
              }
              if (state is FactoryErrorState) {
                developer.log('FactoryErrorState: ${state.message}');
                CustomSnackBar.show(
                  context,
                  message: state.message,
                  isError: true,
                );
              }
            },
          ),
        ],
        child: Scaffold(
          appBar: const ReusableAppBar(title: 'Create Sub user'),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.035,
                  vertical: height * 0.015,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      ReusableTextField(
                        label: 'Name',
                        hint: 'Enter Name',
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        validator: (val) =>
                            val == null || val.isEmpty ? 'Enter Name' : null,
                      ),
                      AppDimensions.h10(context),
                      ReusableTextField(
                        label: 'Phone',
                        hint: 'Enter phone',
                        controller: _phoneController,
                        validator: (val) =>
                        val == null || val.isEmpty ? 'Enter phone' : null,
                      ),
                      AppDimensions.h10(context),

                      // Email
                      ReusableTextField(
                        label: 'Email',
                        hint: 'Enter Email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          if (val == null || val.isEmpty) return 'Enter Email';
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}',
                          ).hasMatch(val)) {
                            return 'Enter valid email';
                          }
                          return null;
                        },
                      ),
                      AppDimensions.h10(context),

                      // Address
                      ReusableTextField(
                        label: 'Address',
                        hint: 'Enter Address',
                        controller: _addressController,
                        validator: (val) =>
                            val == null || val.isEmpty ? 'Enter Address' : null,
                      ),
                      AppDimensions.h10(context),

                      // Salary
                      ReusableTextField(
                        label: 'Salary',
                        hint: 'Enter Salary',
                        controller: _salaryController,
                        keyboardType: TextInputType.number,
                        validator: (val) =>
                            val == null || val.isEmpty ? 'Enter Salary' : null,
                      ),
                      AppDimensions.h10(context),

                      // Factory Dropdown
                      Text('Factory', style: AppTextStyles.label),
                      AppDimensions.h5(context),
                      DropdownButtonFormField<String>(
                        value: _selectedFactoryId, // use the unique ID here
                        items: factoryList.map<DropdownMenuItem<String>>((e) {
                          return DropdownMenuItem<String>(
                            value: e['_id'], // unique value
                            child: Text(
                              e['name']!,
                              style: AppTextStyles.hintText,
                            ), // display name
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedFactoryId = val;
                            _selectedFactory = factoryList.firstWhere(
                              (e) => e['_id'] == val,
                            )['name'];
                          });
                        },
                        decoration: InputDecoration(
                          hintStyle: AppTextStyles.hintText,
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: width * 0.035,
                            vertical: height * 0.015,
                          ),
                          errorStyle: const TextStyle(
                            height: 1,
                            color: Colors.red,
                          ),
                          errorMaxLines: 2,
                        ),
                        validator: (val) =>
                            val == null ? 'Select Factory' : null,
                      ),

                      AppDimensions.h10(context),

                      // Authority Dropdown
                      Text('Authority', style: AppTextStyles.label),
                      AppDimensions.h5(context),
                      ReusableDropdown(
                        items: authorities,
                        value: _selectedAuthority ?? authorities.first,
                        onChanged: (val) =>
                            setState(() => _selectedAuthority = val),
                        hintText: 'Select Authority',
                        validator: (val) =>
                            val == null || val == authorities.first
                            ? 'Select Authority'
                            : null,
                      ),
                      AppDimensions.h10(context),

                      // Password
                      ReusableTextField(
                        label: 'Password',
                        hint: 'Enter Password',
                        controller: _passwordController,
                        validator: (val) => val == null || val.isEmpty
                            ? 'Enter Password'
                            : null,
                      ),
                      AppDimensions.h10(context),

                      // Confirm Password
                      ReusableTextField(
                        label: 'Confirm Password',
                        hint: 'Enter Password',
                        controller: _confirmPasswordController,
                        validator: (val) {
                          if (val == null || val.isEmpty)
                            return 'Confirm Password';
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
                            context.read<SubusersBloc>().add(
                              SubusersCreateEvent(
                                name: _nameController.text,
                                email: _emailController.text,
                                phone: _phoneController.text,
                                role: 'subuser',
                                authority:
                                    _selectedAuthority ?? authorities.first,
                                salary: _salaryController.text.trim(),
                                factoryId: _selectedFactoryId ?? '',
                                address: _addressController.text,
                                password: _passwordController.text,
                                confirmPassword:
                                    _confirmPasswordController.text,
                              ),
                            );
                          }
                        },
                        isLoading: isButtonLoading,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
