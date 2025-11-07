import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Bloc/Broker/broker_bloc.dart';
import '../../../Bloc/FactoryBloc/factory_bloc.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../Utils/image_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_routes.dart';
import '../../../utils/flutter_font_styles.dart';
import '../../../widgets/CustomCards/SuperUser/broker_card.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/reusable_functions.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../widgets/filter_popup.dart';

class BrokerScreen extends StatefulWidget {
  const BrokerScreen({super.key});

  @override
  State<BrokerScreen> createState() => _BrokerScreenState();
}

class _BrokerScreenState extends State<BrokerScreen> {
  TextEditingController searchController = TextEditingController();
  DateTimeRange? selectedDateRange;
  Timer? _debounce;

  ScrollController scrollController = ScrollController();
  bool isLoadingMore = false;
  int currentPage = 1;
  int limit = 20;
  bool hasMore = true;

  // Factories
  Map<String, String> factoryMap = {}; // name -> id
  Set<String> factoryNames = {}; // for dropdown
  String? selectedFactoryName;
  bool isLoadingFactory = false;

  // Filter status
  String? selectedStatus;

  List<dynamic> brokerData = [];

  @override
  void initState() {
    super.initState();
    context.read<FactoryBloc>().add(FactoryEventHandler());
    _fetchBrokerData(reset: true);

    searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        _fetchBrokerData(reset: true);
      });
    });

    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 300 &&
          !isLoadingMore &&
          hasMore) {
        _fetchBrokerData();
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    final DateTimeRange? picked = await pickDateRange(
      context: context,
      initialRange: selectedDateRange,
    );
    if (picked != null) {
      setState(() => selectedDateRange = picked);
      _fetchBrokerData(reset: true);
    }
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

    setState(() => selectedStatus = normalizedStatus);
    _fetchBrokerData(reset: true);
  }

  void _fetchBrokerData({bool reset = false}) {
    if (reset) {
      currentPage = 1;
      hasMore = true;
      brokerData.clear();
    }

    final fromDate = selectedDateRange?.start.toIso8601String();
    final toDate = selectedDateRange?.end.toIso8601String();
    final factoryName = selectedFactoryName;

    developer.log('Fetching brokers page $currentPage: search=${searchController.text}, factory=$factoryName, from=$fromDate, to=$toDate, status=$selectedStatus');

    setState(() => isLoadingMore = true);

    context.read<BrokerBloc>().add(
      GetAllBrokerEventHandler(
        search: searchController.text.trim(),
        fromDate: fromDate,
        toDate: toDate,
        factoryName: factoryName,
        status: selectedStatus,
        page: currentPage,
        limit: limit,
      ),
    );
  }

  void _onFetchMoreSuccess(List<dynamic> newData) {
    setState(() {
      isLoadingMore = false;
      if (newData.length < limit) {
        hasMore = false;
      } else {
        currentPage++;
      }
      brokerData.addAll(newData);
    });
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
              selectedFactoryName = null;
              setState(() {});
            }

            if (state is FactoryErrorState) {
              CustomSnackBar.show(context, message: state.message, isError: true);
            }
          },
        ),
        BlocListener<BrokerBloc, BrokerState>(
          listener: (context, state) {
            if (state is BrokerSuccessState) {
              developer.log('BrokerSuccessState: ${state.brokerData}');
              _onFetchMoreSuccess(state.brokerData);
            }
            if (state is BrokerErrorState) {
              setState(() => isLoadingMore = false);
              CustomSnackBar.show(context, message: state.message, isError: true);
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: CustomAppBar(
          isHomePage: false,
          title: 'Broker',
          preferredHeight: height * 0.12,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.035, vertical: height * 0.015),
          child: Column(
            children: [
              ReusableSearchField(
                controller: searchController,
                hintText: 'Search by Broker',
                onChanged: (value) => _fetchBrokerData(reset: true),
              ),
              AppDimensions.h20(context),

              // Date picker + Factory + Filter row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CustomIconButton(
                      text: formatDateRange(selectedDateRange),
                      imagePath: ImageAssets.calender,
                      width: width,
                      height: height,
                      onTap: _pickDate,
                    ),
                    SizedBox(width: width * 0.045),

                    // Factory dropdown
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
                            _fetchBrokerData(reset: true);
                          },
                          icon: const Icon(
                            Icons.arrow_drop_down_rounded,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: width * 0.045),
                    CustomIconButton(
                      text: 'Filter',
                      iconData: Icons.tune,
                      onTap: _applyFilter,
                      showIconOnRight: true,
                    ),
                  ],
                ),
              ),
              AppDimensions.h20(context),

              // Broker list with pagination
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: brokerData.length + (hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= brokerData.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final data = brokerData[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: BrokerCard(
                        brokerName: data['name'] ?? 'N/A',
                        contactNumber: data['mobileno'] ?? '+91 0000000000',
                        date: formatToIST(data['createdAt']),
                        height: height,
                        width: width,
                        status: data['status']?.toLowerCase() ?? '',
                        onPressed: () async {
                          if ((data['status']?.toLowerCase() ?? '').contains('pending')) {
                            final result = await Navigator.pushNamed(
                              context,
                              AppRoutes.brokerDetailScreen,
                              arguments: data,
                            );

                            // If result is true, refresh broker list
                            if (result == true) {
                              _fetchBrokerData(reset: true);
                            }
                          }
                        },

                      ),
                    );
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
