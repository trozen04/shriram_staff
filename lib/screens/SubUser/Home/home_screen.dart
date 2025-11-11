import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shree_ram_staff/utils/app_colors.dart';
import 'package:shree_ram_staff/utils/flutter_font_styles.dart';
import 'package:shree_ram_staff/utils/image_assets.dart';
import 'package:shree_ram_staff/widgets/custom_app_bar.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../utils/app_routes.dart';
import '../../../widgets/reusable_functions.dart';
import '../../../Bloc/SalesBloc/sales_bloc.dart';
import '../../../widgets/custom_snackbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTimeRange? selectedDateRange;
  List<Map<String, String>> reportData = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<SalesBloc>();

    if (bloc.lastReportData == null) { // <- store last fetched data in Bloc
      _getReportData(); // only fetch if no cached data
    } else {
      reportData = bloc.lastReportData!; // restore cached data
    }
  }

  void _pickDate() async {
    final DateTimeRange? picked = await pickDateRange(
      context: context,
      initialRange: selectedDateRange,
    );

    if (picked != null) {
      setState(() => selectedDateRange = picked);
      _getReportData();
    }
  }

  void _getReportData() {
    final from = selectedDateRange?.start.toIso8601String().split('T').first;
    final to = selectedDateRange?.end.toIso8601String().split('T').first;

    developer.log('Fetching report: from=$from, to=$to');

    setState(() => isLoading = true);

    context.read<SalesBloc>().add(
      GetSalesReportEvent(
        fromDate: from,
        toDate: to,
        factory: null, // no factory
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(
        isHomePage: true,
        title: 'Home',
        preferredHeight: height * 0.15,
      ),
      body: BlocListener<SalesBloc, SalesState>(
        listener: (context, state) {
          if (state is SalesLoading) {
            setState(() => isLoading = true);
          } else if (state is SalesReportSuccess) {
            setState(() {
              isLoading = false;
              final data = (state.reportData['data'] as List?) ?? [];
              reportData = data.map<Map<String, String>>((item) {
                return {
                  'item': item['itemName']?.toString() ?? 'N/A',
                  'qtyIn': "${item['totalWeight'] ?? 0}",
                  'qtyOut': "${item['soldWeight'] ?? 0}",
                  'stockLeft': "${item['leftStock'] ?? 0}",
                };
              }).toList();
             // developer.log("✅ Parsed Report Data: $reportData");
            });
          } else if (state is SalesError) {
            setState(() => isLoading = false);
            CustomSnackBar.show(context, message: state.message, isError: true);
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.035,
            vertical: height * 0.02,
          ),
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
                  ActionButton(
                    title: 'Delivery',
                    imagePath: ImageAssets.deliveryImage,
                    ontap: () {
                      Navigator.pushNamed(context, AppRoutes.deliveryPage);
                    },
                  ),
                  ActionButton(
                    title: 'Final QC',
                    imagePath: ImageAssets.qc,
                    ontap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.deliveryPage,
                        arguments: true,
                      );
                    },
                  ),
                  ActionButton(
                    title: 'Billing',
                    imagePath: ImageAssets.billing,
                    ontap: () {
                      Navigator.pushNamed(context, AppRoutes.billingScreen);
                    },
                  ),
                  ActionButton(
                    title: 'Factory',
                    imagePath: ImageAssets.factory,
                    ontap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.factoryScreen,
                        arguments: null,
                      );
                    },
                  ),
                  ActionButton(
                    title: 'Sales',
                    imagePath: ImageAssets.sales,
                    ontap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.salesScreen,
                        arguments: false,
                      );
                    },
                  ),
                  ActionButton(
                    title: 'Report',
                    imagePath: ImageAssets.report,
                    ontap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.reportScreen,
                        arguments: {'reportData': null},
                      );
                    },
                  ),
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
                  const SizedBox.shrink(),
                ],
              ),
              AppDimensions.h20(context),
              isLoading
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
