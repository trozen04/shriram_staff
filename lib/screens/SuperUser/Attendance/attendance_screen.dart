import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shree_ram_staff/Constants/app_dimensions.dart';
import 'package:shree_ram_staff/Utils/image_assets.dart';
import 'package:shree_ram_staff/widgets/custom_app_bar.dart';
import '../../../Bloc/AttendanceBloc/attendance_bloc.dart';
import '../../../Bloc/FactoryBloc/factory_bloc.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/flutter_font_styles.dart';
import '../../../widgets/primary_and_outlined_button.dart';
import '../../../widgets/reusable_functions.dart';
import '../../../utils/app_routes.dart';
import '../../../widgets/custom_snackbar.dart';
import 'package:intl/intl.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  DateTime? selectedMonthYear; // Only month/year
  Set<String> factoryNames = {};
  String? selectedFactoryName;
  bool isLoadingFactory = false;
  bool isDownload = false;

  @override
  void initState() {
    super.initState();
    context.read<FactoryBloc>().add(FactoryEventHandler());
  }

  void _pickMonthYear() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showMonthYearPicker(
      context: context,
      initialDate: selectedMonthYear ?? now,
      firstDate: DateTime(now.year - 5, 1),
      lastDate: DateTime(now.year + 5, 12),
    );

    if (picked != null) {
      setState(() => selectedMonthYear = picked);
      if (selectedFactoryName != null) _fetchAttendance();
    }
  }

  void _fetchAttendance({bool? isDownload = false}) {
    if (selectedFactoryName == null) return;

    final monthYear = selectedMonthYear ?? DateTime.now();

    context.read<AttendanceBloc>().add(FetchAttendanceEventHandler(
      month: monthYear.month,
      year: monthYear.year,
      factoryName: selectedFactoryName!,
      isDownload: isDownload ?? false
    ));
  }


  String get monthYearLabel {
    if (selectedMonthYear == null) return 'Select Month/Year';
    return DateFormat('MMMM yyyy').format(selectedMonthYear!);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(title: 'Attendance', preferredHeight: height * 0.12),
      body: MultiBlocListener(
        listeners: [
          BlocListener<FactoryBloc, FactoryState>(
            listener: (context, state) {
              if (state is FactoryLoadingState) setState(() => isLoadingFactory = true);
              else setState(() => isLoadingFactory = false);

              if (state is FactorySuccessState) {
                final dataList = state.factoryData['data'] as List? ?? [];
                factoryNames = dataList.map((e) => e['factoryname'].toString()).toSet();
                setState(() {});
              }

              if (state is FactoryErrorState) {
                CustomSnackBar.show(context, message: state.message, isError: true);
              }
            },
          ),
          BlocListener<AttendanceBloc, AttendanceState>(
            listener: (context, state) {
              if (state is AttendanceErrorState) {
                CustomSnackBar.show(context, message: state.message, isError: true);
              }
            },
          ),
        ],
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.035, vertical: height * 0.015),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildFactoryDropdown(width, height),
                  ),
                  SizedBox(width: width * 0.04),
                  _buildIconContainer(width, height, _pickMonthYear, imagePath: ImageAssets.calender),
                  SizedBox(width: width * 0.04),
                  SizedBox(
                    width: width * 0.25,
                    child: PrimaryButton(
                      text: 'Save',
                      onPressed: () {
                        setState(() {
                          isDownload = true; // trigger download param
                        });
                        _fetchAttendance(isDownload : true);
                      },
                    ),
                  )
                ],
              ),
              AppDimensions.h20(context),
              if (selectedMonthYear != null)
                Text(
                  monthYearLabel,
                  style: AppTextStyles.appbarTitle,
                ),
              AppDimensions.h10(context),
              Expanded(
                child: BlocBuilder<AttendanceBloc, AttendanceState>(
                  builder: (context, state) {
                    if (state is AttendanceLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is AttendanceSuccessState) {
                      final data = state.attendanceData as Map<String, dynamic>;
                      final summary = data['summary'] as List<dynamic>? ?? [];

                      if (summary.isEmpty) {
                        return const Center(child: Text('No attendance data found'));
                      }

                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Show filter applied
                            StaffTable(data: summary),
                          ],
                        ),
                      );
                    } else if (state is AttendanceErrorState) {
                      return Center(child: Text(state.message));
                    } else {
                      return const Center(child: Text('Select a factory and month/year'));
                    }
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFactoryDropdown(double width, double height) {
    if (isLoadingFactory) {
      return const SizedBox(
        height: 50,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: width * 0.035, vertical: height * 0.005),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withAlpha((0.16 * 255).toInt()),
        borderRadius: BorderRadius.circular(61),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectedFactoryName,
          hint: Text('Select Factory', style: AppTextStyles.searchFieldFont),
          items: factoryNames.map((name) {
            return DropdownMenuItem<String>(
              value: name,
              child: Text(name, style: AppTextStyles.searchFieldFont),
            );
          }).toList(),
          onChanged: (val) {
            setState(() => selectedFactoryName = val);
            _fetchAttendance();
          },
          icon: Padding(
            padding: EdgeInsets.only(right: width * 0.03),
            child: Image.asset(
              ImageAssets.factoryPNG,
              height: height * 0.025,
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainer(double width, double height, VoidCallback onTap, {String? imagePath}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.065, vertical: height * 0.015),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withAlpha((0.16 * 255).toInt()),
          borderRadius: BorderRadius.circular(30),
        ),
        child: imagePath != null
            ? Image.asset(
          imagePath,
          width: width * 0.06,
          height: width * 0.06,
          color: AppColors.primaryColor,
        )
            : const SizedBox.shrink(),
      ),
    );
  }
}

/// Month Year Picker helper
Future<DateTime?> showMonthYearPicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) async {
  int selectedYear = initialDate.year;
  int selectedMonth = initialDate.month;

  return showDialog<DateTime>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Select Month and Year'),
        content: SizedBox(
          height: 150,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: ListWheelScrollView.useDelegate(
                        itemExtent: 40,
                        perspective: 0.001,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (index) => selectedMonth = index + 1,
                        controller: FixedExtentScrollController(initialItem: initialDate.month - 1),
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) => Center(child: Text('${index + 1}')),
                          childCount: 12,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListWheelScrollView.useDelegate(
                        itemExtent: 40,
                        perspective: 0.001,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (index) => selectedYear = firstDate.year + index,
                        controller: FixedExtentScrollController(initialItem: initialDate.year - firstDate.year),
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) => Center(child: Text('${firstDate.year + index}')),
                          childCount: lastDate.year - firstDate.year + 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(DateTime(selectedYear, selectedMonth)),
                child: const Text('OK'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
