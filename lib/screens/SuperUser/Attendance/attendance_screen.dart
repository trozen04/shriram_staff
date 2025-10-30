import 'package:flutter/material.dart';
import 'package:shree_ram_staff/Constants/app_dimensions.dart';
import 'package:shree_ram_staff/Utils/image_assets.dart';
import 'package:shree_ram_staff/widgets/custom_app_bar.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_routes.dart';
import '../../../utils/flutter_font_styles.dart';
import '../../../widgets/reusable_functions.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  TextEditingController searchController = TextEditingController();
  DateTime? selectedDate  = DateTime.now();

  final dynamic attendanceData = [
    {"name": "Suresh Kumar", "present": 20, "absent": 2},
    {"name": "Ramesh Yadav", "present": 18, "absent": 4},
    {"name": "Amit Singh", "present": 22, "absent": 0},
    {"name": "Vijay Kumar", "present": 19, "absent": 3},
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Attendance', preferredHeight: height * 0.12),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.035, vertical: height * 0.015),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔍 Search Field

            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search Factory',
                hintStyle: AppTextStyles.searchFieldFont,
                suffixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.015),
                  child: Image.asset(ImageAssets.factoryPNG, height: height * 0.01),
                ),
                filled: true,
                fillColor: AppColors.primaryColor.withOpacity(0.16),
                contentPadding: EdgeInsets.symmetric(horizontal: width * 0.035, vertical: height * 0.01),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(61),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            AppDimensions.h10(context),

            /// 🔘 Filter / Calendar / Mark Attendance Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildIconContainer(Icons.filter_list, width, height, (){
                    print('filter list');
                  }),
                  SizedBox(width: width * 0.045),

                  _buildIconContainer(Icons.calendar_month_outlined, width, height, _pickDate),

                  SizedBox(width: width * 0.045),

                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.markAttendanceScreen);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.065, vertical: height * 0.015),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.16),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Text('Mark Attendance', style: AppTextStyles.dateText),
                          AppDimensions.w10(context),
                          Image.asset(ImageAssets.editImage, height: height * 0.02),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppDimensions.h20(context),

            /// 📅 Date Header
            Text(formatReadableDate(selectedDate), style: AppTextStyles.appbarTitle),
            AppDimensions.h10(context),

            /// 📋 Attendance Table
            Expanded(
              child: SingleChildScrollView(
                child: StaffTable(data: attendanceData),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildIconContainer(IconData icon, double width, double height, final VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.065, vertical: height * 0.015),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.16),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(icon, color: AppColors.primaryColor),
      ),
    );
  }
}

