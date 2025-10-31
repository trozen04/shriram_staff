import 'package:flutter/material.dart';
import 'package:shree_ram_staff/widgets/primary_and_outlined_button.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/reusable_functions.dart';

class SalaryRolloutScreen extends StatefulWidget {
  const SalaryRolloutScreen({super.key});

  @override
  State<SalaryRolloutScreen> createState() => _SalaryRolloutScreenState();
}

class _SalaryRolloutScreenState extends State<SalaryRolloutScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController totalSalaryController = TextEditingController();
  final TextEditingController salaryPaidController = TextEditingController();
  final TextEditingController totalPresentController = TextEditingController();
  final TextEditingController salaryLeftController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          isHomePage: false,
          title: 'Salary',
          preferredHeight: height * 0.12,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.05,
            vertical: height * 0.015,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppDimensions.h20(context),

                /// Name Field
                ReusableTextField(
                  label: 'Name',
                  hint: 'Select Name',
                  controller: nameController,
                  readOnly: false,
                ),
                AppDimensions.h20(context),

                /// Total Salary Field
                ReusableTextField(
                  label: 'Total Salary',
                  hint: 'Enter Salary',
                  controller: totalSalaryController,
                  keyboardType: TextInputType.number,
                ),
                AppDimensions.h20(context),

                /// Salary Paid Field
                ReusableTextField(
                  label: 'Salary Paid',
                  hint: 'Enter Salary',
                  controller: salaryPaidController,
                  keyboardType: TextInputType.number,
                ),
                AppDimensions.h20(context),

                /// Total Present (Read-only)
                ReusableTextField(
                  label: 'Total Present',
                  hint: 'Present',
                  controller: totalPresentController,
                  readOnly: true,
                ),
                AppDimensions.h20(context),

                /// Salary Left Field
                ReusableTextField(
                  label: 'Salary Left',
                  hint: 'Enter Salary',
                  controller: salaryLeftController,
                  keyboardType: TextInputType.number,
                ),

                AppDimensions.h30(context),

                /// Submit Button
                PrimaryButton(text: 'Submit', onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
