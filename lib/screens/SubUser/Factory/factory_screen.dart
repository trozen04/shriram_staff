import 'package:flutter/material.dart';
import 'package:shree_ram_staff/widgets/custom_app_bar.dart';
import 'package:intl/intl.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/flutter_font_styles.dart';
import '../../../widgets/reusable_functions.dart';

class FactoryScreen extends StatefulWidget {
  const FactoryScreen({super.key});

  @override
  State<FactoryScreen> createState() => _FactoryScreenState();
}

class _FactoryScreenState extends State<FactoryScreen> {
  DateTime? selectedDate;

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppBar(title: 'Factory', preferredHeight: height * 0.12),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.035, vertical: height * 0.015),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomRoundedButton(
                  onTap: _pickDate,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        selectedDate != null
                            ? DateFormat('dd-MM-yy').format(selectedDate!)
                            : 'Date',
                        style: AppTextStyles.dateText,
                      ),
                      AppDimensions.w10(context),
                      Icon(
                        Icons.calendar_month_outlined,
                        color: AppColors.primaryColor,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: height * 0.05,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.055),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  alignment: Alignment.center,
                  child: Text('Save', style: AppTextStyles.dateText),
                ),
              ],
            ),
            AppDimensions.h20(context),
            Text('Add Item', style: AppTextStyles.label),
            AppDimensions.h5(context),
            ReusableDropdown(
              items: ['1', '2', '3'],
              value: null,
              onChanged: (val) {

              },
              validator: (val) => val == null ? 'Please select any item' : null,
              hintText: 'Select Item',
            ),
            AppDimensions.h10(context),
            ReusableTextField(
              label: 'Quantity',
              hint: 'Enter Quantity',
              onChanged: (val) {

              },
              validator: (val) => val!.isEmpty ? 'Please enter some quantity' : null,
            ),
            AppDimensions.h10(context),
            ReusableTextField(
              label: 'Bags',
              hint: 'Enter number of bags',
              onChanged: (val) {

              },
              validator: (val) => val!.isEmpty ? 'Please enter some quantity' : null,
            ),
            AppDimensions.h10(context),
            ReusableTextField(
              label: 'Quintal',
              hint: 'Enter Quintal',
              onChanged: (val) {

              },
              validator: (val) => val!.isEmpty ? 'Please enter some quantity' : null,
            ),
          ],
        ),
      ),
    );
  }
}
