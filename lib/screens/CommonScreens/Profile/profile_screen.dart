import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shree_ram_staff/Bloc/ProfileBloc/profile_bloc.dart';
import 'package:shree_ram_staff/utils/app_colors.dart';
import 'package:shree_ram_staff/utils/pref_utils.dart';
import 'package:shree_ram_staff/widgets/custom_app_bar.dart';
import 'package:shree_ram_staff/widgets/primary_and_outlined_button.dart';
import 'package:shree_ram_staff/Constants/app_dimensions.dart';
import '../../../utils/shimmers.dart';
import '../../../widgets/reusable_functions.dart';

class ProfileScreen extends StatefulWidget {
  final bool isSuperUser;
  const ProfileScreen({super.key, required this.isSuperUser});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  dynamic profileData = {};
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(FetchProfileEventHandler());
  }

  Widget _buildProfileRow(String label, dynamic value) {
    final displayValue = (value == null || value.toString().trim().isEmpty)
        ? '~'
        : value.toString();

    return ProfileRow(label: label, value: displayValue);
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(title: 'Profile', preferredHeight: height * 0.12),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoadingState) {
            setState(() {
              isLoading = true;
            });
          } else if (state is ProfileSuccessState) {
            setState(() {
              isLoading = false;
              errorMessage = null;
              profileData = state.responseData['data'];
            });
          } else if (state is ProfileErrorState) {
            setState(() {
              isLoading = false;
              errorMessage = state.message;
            });
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.035,
            vertical: height * 0.015,
          ),
          child: isLoading
              ? ProfileShimmer()
          : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileRow('Name', profileData!['name']),
              _buildProfileRow('Email', profileData!['email']),
              _buildProfileRow('Address', profileData!['address']),
              _buildProfileRow('Role', profileData!['role']),
              _buildProfileRow('Authority', profileData!['authority']),
              if(!widget.isSuperUser)
                _buildProfileRow(
                  'Factory',
                  profileData?['factory'] != null
                      ? (profileData!['factory']['factoryname'] ?? 'N/A')
                      : 'N/A',
                ),
              AppDimensions.h30(context),
              PrimaryButton(
                text: 'Logout',
                onPressed: () async {
                  bool confirm = await CustomConfirmationDialog.show(
                    context: context,
                    title: "Logout",
                    description: "Are you sure you want to logout?",
                    confirmText: "Logout",
                    cancelText: "Cancel",
                    confirmColor: AppColors.logoutColor,
                    cancelColor: AppColors.primaryColor
                  );

                  if (confirm) {
                    PrefUtils.clearPrefs();
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
                isLoading: false,
                isLogout: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
