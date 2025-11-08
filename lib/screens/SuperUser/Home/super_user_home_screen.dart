import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shree_ram_staff/Bloc/FactoryBloc/factory_bloc.dart';
import 'package:shree_ram_staff/Bloc/SalesBloc/sales_bloc.dart';
import 'package:shree_ram_staff/utils/app_colors.dart';
import 'package:shree_ram_staff/utils/flutter_font_styles.dart';
import 'package:shree_ram_staff/utils/image_assets.dart';
import 'package:shree_ram_staff/widgets/custom_app_bar.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../utils/app_routes.dart';
import '../../../widgets/reusable_functions.dart';
import '../../../widgets/custom_snackbar.dart';

class SuperUserHomeScreen extends StatefulWidget {
  const SuperUserHomeScreen({super.key});

  @override
  State<SuperUserHomeScreen> createState() => _SuperUserHomeScreenState();
}

class _SuperUserHomeScreenState extends State<SuperUserHomeScreen> {
  DateTimeRange? selectedDateRange;

  // Factory dropdown
  Set<String> factoryNames = {};
  String? selectedFactoryName;
  bool isLoadingFactory = false;

  // Report data
  List<dynamic> reportData = [];
  bool isLoadingReport = false;

  @override
  void initState() {
    super.initState();
    context.read<FactoryBloc>().add(FactoryEventHandler());
    _fetchReportData();
  }

  void _pickDate() async {
    final DateTimeRange? picked = await pickDateRange(
      context: context,
      initialRange: selectedDateRange,
    );
    if (picked != null) {
      setState(() => selectedDateRange = picked);
      _fetchReportData();
    }
  }

  void _fetchReportData() {
    String fromDate = selectedDateRange?.start.toIso8601String().split('T').first ?? '';
    String toDate = selectedDateRange?.end.toIso8601String().split('T').first ?? '';


    developer.log('Fetching report: factory=$selectedFactoryName, from=$fromDate, to=$toDate');

    setState(() => isLoadingReport = true);

    context.read<SalesBloc>().add(
      GetSalesReportEvent(
        fromDate: fromDate,
        toDate: toDate,
        factory: selectedFactoryName, // send factory name
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return MultiBlocListener(
      listeners: [
        BlocListener<FactoryBloc, FactoryState>(
          listener: (context, state) {
            if (state is FactoryLoadingState) setState(() => isLoadingFactory = true);
            else setState(() => isLoadingFactory = false);

            if (state is FactorySuccessState) {
              final dataList = state.factoryData['data'] as List? ?? [];
              factoryNames = {for (var e in dataList) e['factoryname']?.toString() ?? ''};
              selectedFactoryName ??= factoryNames.isNotEmpty ? factoryNames.first : null;
              setState(() {});
              _fetchReportData();
            }

            if (state is FactoryErrorState) {
              CustomSnackBar.show(context, message: state.message, isError: true);
            }
          },
        ),
        BlocListener<SalesBloc, SalesState>(
          listener: (context, state) {
            if (state is SalesLoading) setState(() => isLoadingReport = true);
            if (state is SalesReportSuccess) {
              setState(() {
                isLoadingReport = false;
                final data = (state.reportData['data'] as List?) ?? [];
                reportData = data.map((item) {
                  return {
                    'item': item['itemName']?.toString() ?? 'N/A',
                    'qtyIn': "${item['totalWeight'] ?? 0}",
                    'qtyOut': "${item['soldWeight'] ?? 0}",
                    'stockLeft': "${item['leftStock'] ?? 0}",
                  };
                }).toList();
              });
            }
            if (state is SalesError) {
              setState(() => isLoadingReport = false);
              CustomSnackBar.show(context, message: state.message, isError: true);
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: CustomAppBar(
          isHomePage: true,
          title: 'Home',
          superUser: true,
          preferredHeight: height * 0.15,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: width * 0.035, vertical: height * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: width * 0.02,
                mainAxisSpacing: height * 0.02,
                childAspectRatio: 1.25,
                children: [
                  ActionButton(title: 'Sub Users', imagePath: ImageAssets.subUsers, ontap: () => Navigator.pushNamed(context, AppRoutes.subUsersList)),
                  ActionButton(title: 'Purchase Request', imagePath: ImageAssets.purchaseRequest, ontap: () => Navigator.pushNamed(context, AppRoutes.purchaseRequestScreen)),
                  ActionButton(title: 'Initial QC', imagePath: ImageAssets.qc, ontap: () => Navigator.pushNamed(context, AppRoutes.initialQcScreen)),
                  ActionButton(title: 'Attendance', imagePath: ImageAssets.attendance, ontap: () => Navigator.pushNamed(context, AppRoutes.attendanceScreen)),
                  ActionButton(title: 'Sales', imagePath: ImageAssets.sales, ontap: () => Navigator.pushNamed(context, AppRoutes.salesScreen, arguments: true)),
                  // ActionButton(title: 'Factory', imagePath: ImageAssets.factory, ontap: () => Navigator.pushNamed(context, AppRoutes.factoryScreen, arguments: null)),
                  ActionButton(title: 'Expense', imagePath: ImageAssets.expense, ontap: () => Navigator.pushNamed(context, AppRoutes.expenseScreen)),
                  ActionButton(title: 'Billing', imagePath: ImageAssets.billing, ontap: () => Navigator.pushNamed(context, AppRoutes.billingScreen, arguments: true)),
                  ActionButton(title: 'Salary', imagePath: ImageAssets.salary, ontap: () => Navigator.pushNamed(context, AppRoutes.salaryScreen)),
                  ActionButton(title: 'Report', imagePath: ImageAssets.report, ontap: () => Navigator.pushNamed(context, AppRoutes.reportScreen, arguments: {'reportData': null, 'isSuperUser': true})),
                  ActionButton(title: 'Broker', imagePath: ImageAssets.broker, ontap: () => Navigator.pushNamed(context, AppRoutes.brokerScreen)),
                  ActionButton(title: 'Labour', imagePath: ImageAssets.labour, ontap: () => Navigator.pushNamed(context, AppRoutes.labourScreen)),
                  ActionButton(title: 'Products', imagePath: ImageAssets.broker, ontap: () => Navigator.pushNamed(context, AppRoutes.productMasterScreen)),
                ],
              ),
              AppDimensions.h20(context),
              Text('Report', style: AppTextStyles.appbarTitle),
              AppDimensions.h10(context),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomIconButton(
                    text: formatDateRange(selectedDateRange),
                    imagePath: ImageAssets.calender,
                    width: width,
                    height: height,
                    onTap: _pickDate,
                  ),
                  isLoadingFactory
                      ? const SizedBox(width: 30, height: 30, child: CircularProgressIndicator(strokeWidth: 2))
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
                            Image.asset(ImageAssets.factoryPNG, height: 18, width: 18),
                            const SizedBox(width: 8),
                            Text(
                              'Factory',
                              style: AppTextStyles.bodyText.copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        items: factoryNames.map((name) {
                          return DropdownMenuItem<String>(
                            value: name,
                            child: Text(name, style: AppTextStyles.bodyText.copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.w500)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() => selectedFactoryName = val);
                          _fetchReportData();
                        },
                        icon: const Icon(Icons.arrow_drop_down_rounded, color: AppColors.primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
              AppDimensions.h20(context),
              isLoadingReport
                  ? const Center(child: CircularProgressIndicator())
                  : ReportTable(data: reportData),
              AppDimensions.h20(context),
            ],
          ),
        ),
      ),
    );
  }
}
