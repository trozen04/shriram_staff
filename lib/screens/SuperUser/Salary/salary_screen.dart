import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Constants/app_dimensions.dart';
import '../../../Utils/image_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_routes.dart';
import '../../../utils/flutter_font_styles.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/reusable_functions.dart';
import '../../../Bloc/SalaryBloc/salary_bloc.dart';
import '../../../Bloc/FactoryBloc/factory_bloc.dart';

class SalaryScreen extends StatefulWidget {
  const SalaryScreen({super.key});

  @override
  State<SalaryScreen> createState() => _SalaryScreenState();
}

class _SalaryScreenState extends State<SalaryScreen> {
  DateTimeRange? selectedDateRange;

  // Salary state
  List<dynamic> salaryData = [];
  bool isLoading = false;
  String errorMessage = '';

  // Factory dropdown
  Map<String, String> factoryMap = {};
  Set<String> factoryNames = {};
  String? selectedFactoryName;
  bool isLoadingFactory = false;

  @override
  void initState() {
    super.initState();

    // Fetch factories
    context.read<FactoryBloc>().add(FactoryEventHandler());

    // Trigger default salary fetch (last 7 days)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final now = DateTime.now();
      final fromDate = now.subtract(const Duration(days: 7));
      final toDate = now;
      selectedDateRange = DateTimeRange(start: fromDate, end: toDate);

      _fetchSalary();
    });
  }

  void _pickDate() async {
    final DateTimeRange? picked = await pickDateRange(
      context: context,
      initialRange: selectedDateRange,
    );
    if (picked != null) {
      setState(() => selectedDateRange = picked);
      _fetchSalary();
    }
  }

  void _fetchSalary() {
    if (selectedDateRange == null) return;

    final fromDate = selectedDateRange!.start.toIso8601String().split('T')[0];
    final toDate = selectedDateRange!.end.toIso8601String().split('T')[0];

    // Send factory name instead of ID
    final factoryName = selectedFactoryName;

    developer.log('Fetching salary: from=$fromDate, to=$toDate, factoryName=$factoryName');

    context.read<SalaryBloc>().add(FetchSalaryEvent(
      fromDate: fromDate,
      toDate: toDate,
      factoryName: factoryName,
    ));
  }


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return MultiBlocListener(
      listeners: [
        BlocListener<FactoryBloc, FactoryState>(
          listener: (context, state) {
            if (state is FactoryLoadingState) setState(() => isLoadingFactory = true);
            else setState(() => isLoadingFactory = false);

            if (state is FactorySuccessState) {
              final dataList = state.factoryData['data'] as List? ?? [];
              factoryMap = {for (var e in dataList) e['factoryname']?.toString() ?? '': e['_id'].toString()};
              factoryNames = factoryMap.keys.toSet();
              if (factoryNames.isNotEmpty && selectedFactoryName == null) {
                selectedFactoryName = factoryNames.first;
              }
              setState(() {});
            }

            if (state is FactoryErrorState) {
              errorMessage = state.message;
            }
          },
        ),
        BlocListener<SalaryBloc, SalaryState>(
          listener: (context, state) {
            if (state is SalaryLoadingState) {
              setState(() {
                isLoading = true;
                errorMessage = '';
              });
            } else if (state is SalaryErrorState) {
              setState(() {
                isLoading = false;
                errorMessage = state.message;
                salaryData = [];
              });
            } else if (state is SalarySuccessState) {
              setState(() {
                isLoading = false;
                salaryData = state.salaryData['data'] as List<dynamic>;
                errorMessage = '';
              });
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: CustomAppBar(
          isHomePage: false,
          title: 'Salary',
          preferredHeight: height * 0.12,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.035, vertical: height * 0.015),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Factory dropdown container (same UI as before)
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.035, vertical: height * 0.0),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withAlpha((0.16 * 255).toInt()),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    isLoadingFactory
                        ? const SizedBox(width: 30, height: 30, child: CircularProgressIndicator(strokeWidth: 2))
                        : DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedFactoryName,
                        items: factoryNames.map((name) {
                          return DropdownMenuItem<String>(
                            value: name,
                            child: Text(
                              name,
                              style: AppTextStyles.dateText,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() => selectedFactoryName = val);
                          _fetchSalary();
                        },
                        icon: const Icon(Icons.arrow_drop_down_rounded, color: AppColors.primaryColor),
                      ),
                    ),
                    Image.asset(ImageAssets.factoryPNG, height: height * 0.025),
                  ],
                ),
              ),

              AppDimensions.h10(context),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildIconContainer(width: width, height: height, onTap: _pickDate, imagePath: ImageAssets.calender),
                  SizedBox(width: width * 0.08),
                  InkWell(
                    onTap: () async {
                      final result = await Navigator.pushNamed(context, AppRoutes.salaryRolloutScreen);

                      // If rollout was successful, refresh salary data
                      if (result == true) {
                        _fetchSalary();
                      }
                    },

                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.065, vertical: height * 0.015),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withAlpha((0.16 * 255).toInt()),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Text('Rollout Salary', style: AppTextStyles.dateText),
                          AppDimensions.w10(context),
                          Image.asset(ImageAssets.salaryPng, height: height * 0.02),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              if (selectedDateRange != null) ...[
                AppDimensions.h30(context),
                Text(formatDateRange(selectedDateRange), style: AppTextStyles.appbarTitle),
              ],

              AppDimensions.h10(context),

              // Salary Table
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : errorMessage.isNotEmpty
                    ? Center(child: Text(errorMessage))
                    : salaryData.isEmpty
                    ? const Center(child: Text('No salary data found.'))
                    : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: width * 1.1),
                    child: Table(
                      columnWidths: const {
                        0: FlexColumnWidth(1.8),
                        1: FlexColumnWidth(1.2),
                        2: FlexColumnWidth(1.6),
                        3: FlexColumnWidth(1.6),
                        4: FlexColumnWidth(1.6),
                      },
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(
                          children: [
                            _headerCell('Staff Name'),
                            _headerCell('Present'),
                            _headerCell('Total Salary'),
                            _headerCell('Salary Paid'),
                            _headerCell('Salary Left'),
                          ],
                        ),
                        ...salaryData.map(
                              (row) => TableRow(
                            children: [
                              _cell(row['name'] ?? 'N/A'),
                              _cell('${row['totalpresent'] ?? 0} Days'),
                              _cell('₹ ${row['totalsalary'] ?? 0}'),
                              _cell('₹ ${row['salarypaid'] ?? 0}'),
                              _cell('₹ ${row['salaryleft'] ?? 0}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainer({
    String? imagePath,
    IconData? iconData,
    required double width,
    required double height,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.065, vertical: height * 0.015),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withAlpha((0.16 * 255).toInt()),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            if (imagePath != null) Image.asset(imagePath, height: height * 0.02)
            else if (iconData != null) Icon(iconData, size: height * 0.022, color: AppColors.primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _headerCell(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
    child: Text(text, style: AppTextStyles.bodyText),
  );

  Widget _cell(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
    child: Text(
      text,
      style: AppTextStyles.bodyText.copyWith(color: AppColors.opacityColorBlack),
      overflow: TextOverflow.ellipsis,
    ),
  );
}
