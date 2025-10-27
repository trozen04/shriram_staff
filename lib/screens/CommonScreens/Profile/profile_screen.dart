import 'package:flutter/material.dart';
import 'package:shree_ram_staff/widgets/custom_app_bar.dart';
import '../../../../Constants/app_dimensions.dart';
import '../../../../widgets/reusable_functions.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/pref_utils.dart';
import '../../../widgets/primary_and_outlined_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppBar(title: 'Profile', preferredHeight: height * 0.12),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.035, vertical: height * 0.015),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileRow(label: 'Name', value: 'Rahul'),
            ProfileRow(label: 'Address', value: '122/22, Tilak Nagar'),
            ProfileRow(label: 'City/Town', value: 'New Delhi'),
            ProfileRow(label: 'State', value: 'Delhi'),
            AppDimensions.h30(context),
            PrimaryButton(
              text: 'Logout',
              onPressed: () async {
                // Show the confirmation dialog
                bool confirm = await CustomConfirmationDialog.show(
                  context: context,
                  title: "Logout",
                  description: "Are you sure you want to logout?",
                  confirmText: "Logout",
                  cancelText: "Cancel",
                  confirmColor: AppColors.logoutColor,
                );

                // Handle user response
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
    );
  }
}

