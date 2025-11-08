import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Bloc/SalesBloc/sales_bloc.dart';
import '../../../Bloc/FactoryBloc/factory_bloc.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../Utils/image_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/flutter_font_styles.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../widgets/reusable_functions.dart';

class ReportScreen extends StatefulWidget {
  final bool isSuperUser;
  const ReportScreen({super.key, this.isSuperUser = false});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  DateTimeRange? selectedDateRange;

  // Factory state
  Map<String, String> factoryMap = {}; // factoryname → id
  Set<String> factoryNames = {};
  String? selectedFactoryName;
  bool isLoadingFactory = false;

  // Report state
  bool isLoading = false;
  List<Map<String, String>> reportData = [];

  @override
  void initState() {
    super.initState();
    if (widget.isSuperUser) {
      context.read<FactoryBloc>().add(FactoryEventHandler());
    }
    _fetchReportData();
  }

  // Pick date range
  void _pickDate() async {
    final picked = await pickDateRange(
      context: context,
      initialRange: selectedDateRange,
    );

    if (picked != null) {
      setState(() => selectedDateRange = picked);
      _fetchReportData();
    }
  }

  // Fetch report
  void _fetchReportData() {
    final fromDate = selectedDateRange?.start.toIso8601String().split('T').first;
    final toDate = selectedDateRange?.end.toIso8601String().split('T').first;

    context.read<SalesBloc>().add(
      GetSalesReportEvent(
        fromDate: fromDate,
        toDate: toDate,
        factory: selectedFactoryName, // 🟢 send factory name instead of id
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return MultiBlocListener(
      listeners: [
        // 🏭 FACTORY BLOC
        BlocListener<FactoryBloc, FactoryState>(
          listener: (context, state) {
            if (state is FactoryLoadingState) setState(() => isLoadingFactory = true);
            else setState(() => isLoadingFactory = false);

            if (state is FactorySuccessState) {
              final factories = (state.factoryData['data'] as List?) ?? [];
              factoryMap = {
                for (var f in factories)
                  f['factoryname']?.toString() ?? '': f['_id']?.toString() ?? ''
              };
              factoryNames = factoryMap.keys.toSet();
              developer.log('🏭 Loaded factories: $factoryMap');
            }

            if (state is FactoryErrorState) {
              CustomSnackBar.show(context, message: state.message, isError: true);
            }
          },
        ),

        // 📊 REPORT BLOC
        BlocListener<SalesBloc, SalesState>(
          listener: (context, state) {
            if (state is SalesLoading) {
              setState(() => isLoading = true);
            } else if (state is SalesReportSuccess) {
              final data = (state.reportData['data'] as List?) ?? [];
              setState(() {
                isLoading = false;
                reportData = data.map<Map<String, String>>((item) {
                  return {
                    'item': item['itemName']?.toString() ?? 'N/A',
                    'qtyIn': '${item['totalWeight'] ?? 0}',
                    'qtyOut': '${item['soldWeight'] ?? 0}',
                    'stockLeft': '${item['leftStock'] ?? 0}',
                  };
                }).toList();
              });
            } else if (state is SalesError) {
              setState(() => isLoading = false);
              CustomSnackBar.show(context, message: state.message, isError: true);
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Report',
          preferredHeight: height * 0.12,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.035,
            vertical: height * 0.015,
          ),
          child: Column(
            children: [
              // 🔹 Filters Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 📅 Date Picker
                  CustomIconButton(
                    text: formatDateRange(selectedDateRange),
                    imagePath: ImageAssets.calender,
                    width: width,
                    height: height,
                    onTap: _pickDate,
                  ),
                  SizedBox(width: width * 0.045),

                  // 🏭 Factory Dropdown (Same UI as BrokerScreen)
                  if (widget.isSuperUser)
                    isLoadingFactory
                        ? const SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : Container(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.16),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedFactoryName,
                          hint: Row(
                            children: [
                              Image.asset(ImageAssets.factoryPNG,
                                  height: 18, width: 18),
                              const SizedBox(width: 8),
                              Text(
                                'Factory',
                                style: AppTextStyles.bodyText.copyWith(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          items: factoryNames.map((name) {
                            return DropdownMenuItem<String>(
                              value: name,
                              child: Text(
                                name,
                                style: AppTextStyles.bodyText.copyWith(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() => selectedFactoryName = val);
                            _fetchReportData();
                          },
                          icon: const Icon(
                            Icons.arrow_drop_down_rounded,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              AppDimensions.h20(context),

              // 🔹 Report Data Table
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : reportData.isEmpty
                    ? const Center(
                  child: Text(
                    'No data available',
                    style: TextStyle(fontSize: 16),
                  ),
                )
                    : SingleChildScrollView(
                  child: ReportTable(data: reportData),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
