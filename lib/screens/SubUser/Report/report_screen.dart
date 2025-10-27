import 'package:flutter/material.dart';
import 'package:shree_ram_staff/widgets/custom_app_bar.dart';
import 'package:intl/intl.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/flutter_font_styles.dart';
import '../../../widgets/reusable_functions.dart';

class ReportScreen extends StatefulWidget {
  final reportData;
  const ReportScreen({super.key, required this.reportData});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  DateTime? fromDate;
  DateTime? toDate;

  Future<void> _pickFromDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fromDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => fromDate = picked);
    }
  }

  Future<void> _pickToDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: toDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => toDate = picked);
    }
  }

  final reportData = [
    {'item': 'Paddy', 'qtyIn': '33 Qntl', 'qtyOut': '13 Qntl', 'stockLeft': '20 Qntl'},
    {'item': 'Paddy', 'qtyIn': '33 Qntl', 'qtyOut': '13 Qntl', 'stockLeft': '20 Qntl'},
    {'item': 'Paddy', 'qtyIn': '33 Qntl', 'qtyOut': '13 Qntl', 'stockLeft': '20 Qntl'},
    {'item': 'Paddy', 'qtyIn': '33 Qntl', 'qtyOut': '13 Qntl', 'stockLeft': '20 Qntl'},
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(title: 'Report', preferredHeight: height * 0.12),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.035, vertical: height * 0.015),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // ---- FROM DATE ----
                CustomRoundedButton(
                  onTap: _pickFromDate,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        fromDate != null
                            ? DateFormat('dd/MM/yy').format(fromDate!)
                            : 'From Date',
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

                AppDimensions.w10(context),

                // ---- TO DATE ----
                CustomRoundedButton(
                  onTap: _pickToDate,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        toDate != null
                            ? DateFormat('dd/MM/yy').format(toDate!)
                            : 'To Date',
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
              ],
            ),
            AppDimensions.h20(context),
            ReportTable(data: reportData),
          ],
        ),
      ),
    );
  }
}
