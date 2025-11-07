import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../Bloc/LabourBloc/labour_bloc.dart';
import '../../../Bloc/FactoryBloc/factory_bloc.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../Utils/image_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_routes.dart';
import '../../../utils/flutter_font_styles.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/filter_popup.dart';
import '../../../widgets/reusable_functions.dart';
import '../../../widgets/custom_snackbar.dart';

class LabourScreen extends StatefulWidget {
  const LabourScreen({super.key});

  @override
  State<LabourScreen> createState() => _LabourScreenState();
}

class _LabourScreenState extends State<LabourScreen> {
  TextEditingController searchController = TextEditingController();
  DateTimeRange? selectedDateRange;
  Timer? _debounce;

  // Factories
  Map<String, String> factoryMap = {}; // name -> id
  Set<String> factoryNames = {}; // for dropdown
  String? selectedFactoryName;
  bool isLoadingFactory = false;

  // Filter
  String? selectedStatus;

  @override
  void initState() {
    super.initState();
    context.read<FactoryBloc>().add(FactoryEventHandler()); // fetch factories
    _fetchLabour();
    searchController.addListener(() => _onSearchChanged(searchController.text));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    final picked = await pickDateRange(context: context, initialRange: selectedDateRange);
    if (picked != null) {
      setState(() => selectedDateRange = picked);
      _fetchLabour(status: selectedStatus);
    }
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetchLabour(status: selectedStatus);
    });
  }

  void _applyFilter() async {
    final selectedStatuses = await showStatusFilterDialog(
      context,
      initialSelected: selectedStatus != null ? [selectedStatus!] : [],
    );
    if (selectedStatuses == null) return;

    String? normalizedStatus;
    if (selectedStatuses.isNotEmpty) {
      final status = selectedStatuses.first.toLowerCase();
      if (status.contains('pending')) normalizedStatus = 'Pending';
      else if (status.contains('approved') || status.contains('approve')) normalizedStatus = 'Approve';
    }

    setState(() {
      selectedStatus = normalizedStatus;
    });

    _fetchLabour(status: normalizedStatus);
  }

  void _fetchLabour({String? status}) {
    final fromDate = selectedDateRange != null
        ? DateFormat('yyyy-MM-dd').format(selectedDateRange!.start)
        : null;
    final toDate = selectedDateRange != null
        ? DateFormat('yyyy-MM-dd').format(selectedDateRange!.end)
        : null;

    final selectedFactoryId = selectedFactoryName != null ? factoryMap[selectedFactoryName!] : null;

    context.read<LabourBloc>().add(
      GetAllLabourEventHandler(
        fromDate: fromDate,
        toDate: toDate,
        search: searchController.text.trim(),
        factory: selectedFactoryId,
        status: status,
      ),
    );
  }

  String formatAmount(dynamic amount) {
    if (amount == null) return '₹ 0';
    try {
      final number = amount is String ? double.parse(amount) : amount.toDouble();
      final formatter = NumberFormat('#,##0', 'en_IN');
      return '₹ ${formatter.format(number)}';
    } catch (e) {
      return '₹ ${amount.toString()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return MultiBlocListener(
      listeners: [
        BlocListener<FactoryBloc, FactoryState>(
          listener: (context, state) {
            if (state is FactoryLoadingState) {
              setState(() => isLoadingFactory = true);
            } else {
              setState(() => isLoadingFactory = false);
            }

            if (state is FactorySuccessState) {
              final dataList = state.factoryData['data'] as List? ?? [];
              factoryMap = {
                for (var e in dataList) e['factoryname']?.toString() ?? '': e['_id'].toString()
              };
              factoryNames = factoryMap.keys.toSet();
              selectedFactoryName = null;
              setState(() {});
            }

            if (state is FactoryErrorState) {
              CustomSnackBar.show(context, message: state.message, isError: true);
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: CustomAppBar(
          isHomePage: false,
          title: 'Labour',
          preferredHeight: height * 0.12,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.035, vertical: height * 0.015),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReusableSearchField(
                    controller: searchController,
                    hintText: 'Search Labour',
                    onChanged: _onSearchChanged,
                  ),
                  AppDimensions.h20(context),

                  // Row: Date, Factory, Filter
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
                      // AppDimensions.w10(context),

                      // Factory dropdown
                      isLoadingFactory
                          ? const SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.04,
                          vertical: height * 0.0,
                        ),
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
                              _fetchLabour(status: selectedStatus);
                            },
                            icon: const Icon(Icons.arrow_drop_down_rounded, color: AppColors.primaryColor),
                          ),
                        ),
                      ),

                      // AppDimensions.w10(context),

                      // Filter button
                      // CustomIconButton(
                      //   text: 'Filter',
                      //   iconData: Icons.tune,
                      //   onTap: _applyFilter,
                      //   showIconOnRight: true,
                      // ),
                    ],
                  ),

                  AppDimensions.h20(context),

                  // Labour items table
                  Expanded(
                    child: BlocBuilder<LabourBloc, LabourState>(
                      builder: (context, state) {
                        if (state is LabourLoadingState) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is LabourSuccessState) {
                          final labourData = state.labourData;
                          if (labourData.isEmpty) {
                            return const Center(child: Text('No Labour Found'));
                          }

                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: width * 1.2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Table Header
                                  Row(
                                    children: [
                                      Expanded(flex: 3, child: Text('Item Name', style: AppTextStyles.bodyText)),
                                      Expanded(flex: 2, child: Text('Unit', style: AppTextStyles.bodyText)),
                                      Expanded(flex: 2, child: Text('Price/U', style: AppTextStyles.bodyText)),
                                      Expanded(flex: 3, child: Text('Amount', style: AppTextStyles.bodyText)),
                                      Expanded(flex: 2, child: Text('Extra', style: AppTextStyles.bodyText)),
                                      Expanded(flex: 3, child: Text('Total', style: AppTextStyles.bodyText)),
                                    ],
                                  ),
                                  AppDimensions.h10(context),

                                  // Table Rows
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: labourData.map<Widget>((labour) {
                                          final items = labour['labourItems'] as List? ?? [];
                                          return Column(
                                            children: items.map<Widget>((item) {
                                              return Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 6.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(flex: 3, child: Text(item['itemname'] ?? '')),
                                                    Expanded(flex: 2, child: Text(item['unit']?.toString() ?? '0')),
                                                    Expanded(flex: 2, child: Text(formatAmount(item['price']))),
                                                    Expanded(flex: 3, child: Text(formatAmount(item['amount']))),
                                                    Expanded(flex: 2, child: Text(formatAmount(item['extra']))),
                                                    Expanded(flex: 3, child: Text(formatAmount(item['total']))),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else if (state is LabourErrorState) {
                          return Center(child: Text(state.message));
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ],
              ),
              CustomFAB(
                onTap: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    AppRoutes.addLabourChargesScreen,
                  );

                  if (result == true) {
                    _fetchLabour();
                  }
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}
