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
  DateTime? selectedDate = DateTime.now();

  // List to store all added items
  List<Map<String, dynamic>> items = [
    {'item': null, 'quantity': '', 'bags': '', 'quintal': ''}
  ];

  void _pickDate() async {
    final DateTime? picked = await pickDate(
      context: context,
      initialDate: selectedDate,
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Function to add new item
  void _addItem() {
    setState(() {
      items.add({'item': null, 'quantity': '', 'bags': '', 'quintal': ''});
    });
  }

  void _removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Factory', preferredHeight: height * 0.12),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.035,
          vertical: height * 0.015,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row with Date and Save button
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



            // Scrollable list of added items
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Column(
                      children: [
                        // Header row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Add Item', style: AppTextStyles.label),
                            if(index == items.length-1)
                            InkWell(
                              onTap: _addItem,
                              child: Text(
                                'Add Item',
                                style: AppTextStyles.underlineText,
                              ),
                            ),
                            if(index != items.length - 1) InkWell(
                                onTap: () => _removeItem(index),
                                child: Icon(Icons.remove_circle, color: Colors.red,))
                          ],
                        ),

                        AppDimensions.h10(context),
                        ReusableDropdown(
                          items: ['Wheat', 'Rice', 'Barley', 'Maize'],
                          value: item['item'],
                          onChanged: (val) {
                            setState(() {
                              item['item'] = val;
                            });
                          },
                          validator: (val) =>
                          val == null ? 'Please select an item' : null,
                          hintText: 'Select Item',
                        ),
                        AppDimensions.h10(context),
                        ReusableTextField(
                          label: 'Quantity',
                          hint: 'Enter Quantity',
                          onChanged: (val) {
                            item['quantity'] = val;
                          },
                          validator: (val) => val!.isEmpty
                              ? 'Please enter quantity'
                              : null,
                        ),
                        AppDimensions.h10(context),
                        ReusableTextField(
                          label: 'Bags',
                          hint: 'Enter number of bags',
                          onChanged: (val) {
                            item['bags'] = val;
                          },
                          validator: (val) =>
                          val!.isEmpty ? 'Please enter bags' : null,
                        ),
                        AppDimensions.h10(context),
                        ReusableTextField(
                          label: 'Quintal',
                          hint: 'Enter Quintal',
                          onChanged: (val) {
                            item['quintal'] = val;
                          },
                          validator: (val) =>
                          val!.isEmpty ? 'Please enter quintal' : null,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
