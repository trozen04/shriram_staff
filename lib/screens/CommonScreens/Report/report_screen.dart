import 'package:flutter/material.dart';
import 'package:shree_ram_staff/widgets/custom_app_bar.dart';
import 'package:intl/intl.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../Utils/image_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/flutter_font_styles.dart';
import '../../../widgets/reusable_functions.dart';

class ReportScreen extends StatefulWidget {
  final reportData;
  final bool isSuperUser;
  const ReportScreen({super.key, required this.reportData,  this.isSuperUser = false});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  DateTime? fromDate;
  DateTime? toDate;
  DateTime? _fromDate;
  DateTime? _toDate;
  DateTime? selectedDate  = DateTime.now();
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
    {'item': 'Paddy', 'qtyIn': '33 Qntl', 'qtyOut': '13 Qntl', 'stockLeft': '20 Qntl'},
    {'item': 'Paddy', 'qtyIn': '33 Qntl', 'qtyOut': '13 Qntl', 'stockLeft': '20 Qntl'},
    {'item': 'Paddy', 'qtyIn': '33 Qntl', 'qtyOut': '13 Qntl', 'stockLeft': '20 Qntl'},
    {'item': 'Paddy', 'qtyIn': '33 Qntl', 'qtyOut': '13 Qntl', 'stockLeft': '20 Qntl'},
  ];

  void _pickDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDateRange: selectedDate != null
          ? DateTimeRange(start: selectedDate!, end: selectedDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor, // header & selection color
              onPrimary: Colors.white, // text on selected color
              onSurface: Colors.black, // default text color
            ),
            dialogBackgroundColor: Colors.white, // ✅ make dialog white
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked.start;
        _fromDate = picked.start;
        _toDate = picked.end;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Report', preferredHeight: height * 0.12),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.035, vertical: height * 0.015),
        child: Column(
          children: [
            if (widget.isSuperUser) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomRoundedButton(
                    onTap: _pickDateRange,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _fromDate != null && _toDate != null
                              ? '${DateFormat('dd-MM-yy').format(_fromDate!)} → ${DateFormat('dd-MM-yy').format(_toDate!)}'
                              : 'Date',
                          style: AppTextStyles.dateText,
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.calendar_month_outlined,
                          color: AppColors.primaryColor,
                          size: height * 0.02,
                        ),
                      ],
                    ),
                  ),

                  AppDimensions.w20(context),
                  CustomRoundedButton(
                    onTap: () {},
                    child: Row(
                      children: [
                        Text('Factory', style: AppTextStyles.dateText),
                        const SizedBox(width: 8),
                        Image.asset(ImageAssets.factoryPNG, height: height * 0.02),
                      ],
                    ),
                  ),
                ],
              ),
            ] else ...[
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
            ],

            AppDimensions.h20(context),
            Expanded(child: SingleChildScrollView(child: ReportTable(data: reportData))),
          ],
        ),
      ),
    );
  }
}
