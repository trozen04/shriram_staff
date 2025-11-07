import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shree_ram_staff/widgets/primary_and_outlined_button.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/reusable_functions.dart';
import '../../../Bloc/SalaryBloc/salary_bloc.dart';
import '../../../widgets/custom_snackbar.dart';

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

  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    salaryPaidController.addListener(_calculateSalaryLeft);
    totalSalaryController.addListener(_calculateSalaryLeft);
  }

  void _calculateSalaryLeft() {
    final totalSalary = int.tryParse(totalSalaryController.text) ?? 0;
    final salaryPaid = int.tryParse(salaryPaidController.text) ?? 0;
    salaryLeftController.text = (totalSalary - salaryPaid).toString();
  }

  @override
  void dispose() {
    nameController.dispose();
    totalSalaryController.dispose();
    salaryPaidController.dispose();
    totalPresentController.dispose();
    salaryLeftController.dispose();
    super.dispose();
  }

  void _submitSalary(BuildContext context) {
    if (nameController.text.isEmpty ||
        totalSalaryController.text.isEmpty ||
        salaryPaidController.text.isEmpty ||
        totalPresentController.text.isEmpty) {
      CustomSnackBar.show(context, message: 'Please fill all fields', isError: true);
      return;
    }

    context.read<SalaryBloc>().add(CreateSalaryEvent(
      name: nameController.text.trim(),
      totalSalary: int.tryParse(totalSalaryController.text.trim()) ?? 0,
      salaryPaid: int.tryParse(salaryPaidController.text.trim()) ?? 0,
      totalPresent: int.tryParse(totalPresentController.text.trim()) ?? 0,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (_) => SalaryBloc(),
      child: BlocListener<SalaryBloc, SalaryState>(
        listener: (context, state) {
          if (state is SalaryLoadingState) {
            setState(() => isSubmitting = true);
          } else if (state is SalaryCreateSuccessState) {
            setState(() => isSubmitting = false);
            CustomSnackBar.show(context, message: 'Salary added successfully!');
            Navigator.pop(context, true);
          } else if (state is SalaryErrorState) {
            setState(() => isSubmitting = false);
            CustomSnackBar.show(context, message: state.message, isError: true);
          }
        },
        child: GestureDetector(
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
                      hint: 'Enter Name',
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

                    /// Total Present Field
                    ReusableTextField(
                      label: 'Total Present',
                      hint: 'Enter Days',
                      controller: totalPresentController,
                      keyboardType: TextInputType.number,
                      
                      
                    ),
                    AppDimensions.h20(context),

                    /// Salary Left Field (Read-only)
                    ReusableTextField(
                      label: 'Salary Left',
                      hint: 'Salary Left',
                      controller: salaryLeftController,
                      readOnly: true,
                      
                      
                    ),
                    AppDimensions.h30(context),

                    /// Submit Button
                    PrimaryButton(
                      text: 'Submit',
                      onPressed: isSubmitting ? null : () => _submitSalary(context),
                      isLoading: isSubmitting,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
