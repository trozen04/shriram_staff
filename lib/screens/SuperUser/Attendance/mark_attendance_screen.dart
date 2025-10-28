import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shree_ram_staff/Constants/app_dimensions.dart';
import 'package:shree_ram_staff/widgets/custom_app_bar.dart';
import 'package:shree_ram_staff/widgets/primary_and_outlined_button.dart';

import '../../../utils/flutter_font_styles.dart';
import '../../../widgets/reusable_functions.dart';

class MarkAttendanceScreen extends StatefulWidget {
  const MarkAttendanceScreen({super.key});

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _labourController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();

  final List<String> statusList = ['Present', 'Absent', 'Half Day'];
  String? _selectedStatus;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      // Convert to Indian Standard Time (UTC+5:30)
      final istDate = picked.toUtc().add(const Duration(hours: 5, minutes: 30));

      // Format as "23 September, 2025"
      final formattedDate = DateFormat('d MMMM, yyyy').format(istDate);

      // ✅ Update text controller so it shows inside the field
      setState(() {
        _dateController.text = formattedDate;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // handle form data
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attendance submitted successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(title: 'Attendance', preferredHeight: height * 0.12),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: width * 0.035, vertical: height * 0.015),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReusableTextField(
                label: 'Name',
                hint: 'Enter Name',
                controller: _nameController,
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty ? 'Name is required' : null,
              ),
              AppDimensions.h10(context),

              ReusableTextField(
                label: 'Date',
                hint: 'select date',
                controller: _dateController,
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (value) => value == null || value.isEmpty ? 'Date is required' : null,
              ),


              AppDimensions.h10(context),
              Text('Status', style: AppTextStyles.label),
              AppDimensions.h5(context),
              ReusableDropdown(
                items: statusList,
                value: _selectedStatus,
                onChanged: (val) => setState(() => _selectedStatus = val),
                hintText: 'Select Status',
                validator: (val) => val == null ? 'Select Status' : null,
              ),
              AppDimensions.h10(context),
             ReusableTextField(
                label: 'No. of labours',
                hint: 'Enter no. of labours',
                controller: _labourController,
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty ? 'A value is required' : null,
              ),
              AppDimensions.h10(context),
              ReusableTextField(
                label: 'Monthly Salary',
                hint: 'Enter Salary',
                controller: _salaryController,
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty ? 'Salary is required' : null,
              ),
              AppDimensions.h30(context),

              PrimaryButton(text: 'Submit', onPressed: _submitForm)

            ],
          ),
        ),
      ),
    );
  }
}
