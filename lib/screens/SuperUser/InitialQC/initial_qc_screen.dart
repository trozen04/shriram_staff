import 'dart:async';
import 'dart:developer' as developer;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shree_ram_staff/utils/flutter_font_styles.dart';
import 'package:shree_ram_staff/widgets/custom_app_bar.dart';
import '../../../Bloc/FactoryBloc/factory_bloc.dart';
import '../../../Bloc/QCBloc/qc_bloc.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../Utils/image_assets.dart';
import '../../../utils/app_routes.dart';
import '../../../utils/shimmers.dart';
import '../../../widgets/CustomCards/homeInfoCard.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../widgets/filter_popup.dart';
import '../../../widgets/reusable_functions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InitialQcScreen extends StatefulWidget {
  const InitialQcScreen({super.key});

  @override
  State<InitialQcScreen> createState() => _InitialQcScreenState();
}

class _InitialQcScreenState extends State<InitialQcScreen> {
  TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  DateTimeRange? selectedDateRange;
  bool isLoading = false;
  bool isFactoryLoading = false;
  bool isFetchingMore = false;
  bool hasMoreData = true;
  int currentPage = 1;
  final int limit = 10;
  String searchQuery = '';
  String? selectedStatus;
  Timer? _debounce;
  List<dynamic> factoryList = [];
  String? _selectedFactoryId;
  String? _selectedFactoryName;

  dynamic qcData = [];

  @override
  void initState() {
    super.initState();

    // initial fetch
    _fetchData(page: 1);
    context.read<FactoryBloc>().add(FactoryEventHandler());
    // pagination listener
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100 &&
          !isFetchingMore &&
          hasMoreData &&
          !isLoading) {
        _fetchMore();
      }
    });
  }

  /// 🧠 Unified data fetcher
  void _fetchData({
    int page = 1,
    String? fromDate,
    String? toDate,
    String? status,
    String? query,
  }) {
    if (page == 1) {
      setState(() {
        qcData = [];
        hasMoreData = true;
        currentPage = 1;
      });
    } else {
      setState(() {
        currentPage = page;
      });
    }
    String? normalizedStatus;
    if (status != null && status.isNotEmpty) {
      if (status.toLowerCase().contains('pending')) {
        normalizedStatus = 'Pending';
      } else if (status.toLowerCase().contains('approved')) {
        normalizedStatus = 'Approve';
      }
    }
    developer.log('➡️ Page: $page');
    developer.log('➡️ Limit: $limit');
    developer.log('➡️ From Date: $fromDate');
    developer.log('➡️ To Date: $toDate');
    developer.log('➡️ Status: $status');
    developer.log('➡️ Search: $query');

    context.read<QcBloc>().add(
      GetAllQcEventHandler(
        page: page,
        limit: limit,
        fromDate: fromDate,
        toDate: toDate,
        status: normalizedStatus,
        search: query,
        factory: _selectedFactoryName,

      ),
    );

  }

  /// 🌀 Pagination loader
  void _fetchMore() {
    if (!hasMoreData) return;
    setState(() => isFetchingMore = true);

    _fetchData(
      page: currentPage + 1,
      fromDate: selectedDateRange != null
          ? DateFormat('yyyy-MM-dd').format(selectedDateRange!.start)
          : null,
      toDate: selectedDateRange != null
          ? DateFormat('yyyy-MM-dd').format(selectedDateRange!.end)
          : null,
      status: selectedStatus,
      query: searchQuery,
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    final DateTimeRange? picked = await pickDateRange(
      context: context,
      initialRange: selectedDateRange,
    );

    if (picked != null) {
      setState(() {
        selectedDateRange = picked;
      });
      _fetchData(
        page: 1,
        fromDate: DateFormat('yyyy-MM-dd').format(picked.start),
        toDate: DateFormat('yyyy-MM-dd').format(picked.end),
      );
    }
  }

  /// 🔍 Debounced search
  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      setState(() {
        searchQuery = value;
      });
      _fetchData(page: 1, query: value);
    });
  }

  void _filter() async {
    final selectedStatuses = await showStatusFilterDialog(
      context,
      initialSelected: selectedStatus != null ? [selectedStatus!] : [],
    );
    if (selectedStatuses == null) return;

    setState(() {
      selectedStatus = selectedStatuses.isNotEmpty ? selectedStatuses.first : null;
    });

    _fetchData(
      page: 1,
      status: selectedStatus,
      fromDate: selectedDateRange != null
          ? DateFormat('yyyy-MM-dd').format(selectedDateRange!.start)
          : null,
      toDate: selectedDateRange != null
          ? DateFormat('yyyy-MM-dd').format(selectedDateRange!.end)
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(title: 'Initial QC', preferredHeight: height * 0.12),
      body: MultiBlocListener(
  listeners: [
    BlocListener<FactoryBloc, FactoryState>(
      listener: (context, state) {
        if (state is FactoryLoadingState) {
          setState(() => isFactoryLoading = true);
        } else {
          setState(() => isFactoryLoading = false);
        }

        if (state is FactorySuccessState) {
          // Convert to unique set based on name to remove duplicates
          final uniqueFactories = <String>{};
          factoryList = (state.factoryData['data'] as List)
              .where((e) => uniqueFactories.add(e['factoryname'].toString()))
              .map((e) => {
            '_id': e['_id'].toString(),
            'name': e['factoryname'].toString(),
          })
              .toList();

          // Set initial selection if null
          if (factoryList.isNotEmpty && _selectedFactoryName == null) {
            _selectedFactoryId = factoryList.first['_id'];
            _selectedFactoryName = factoryList.first['name'];
          }
          setState(() {});
        }

        if (state is FactoryErrorState) {
          CustomSnackBar.show(context, message: state.message, isError: true);
        }
      },
    ),


    BlocListener<QcBloc, QcState>(
      listener: (context, state) {
        if (state is GetAllQcLoadingState) {
          if (currentPage == 1) {
            setState(() => isLoading = true);
          } else {
            setState(() => isFetchingMore = true);
          }
        } else if (state is GetAllQcSuccessState) {
          //developer.log('GetAllQcSuccessState: ${state.responseData}');
          final List<dynamic> fetchedData = state.responseData['data'] ?? [];
          setState(() {
            if (currentPage == 1) {
              qcData = fetchedData;
            } else {
              qcData.addAll(fetchedData);
            }
            hasMoreData = fetchedData.length >= limit;
            isLoading = false;
            isFetchingMore = false;
          });
        } else if (state is GetAllQcErrorState) {
          developer.log('GetAllQcErrorState: ${state.message}');
          setState(() {
            isLoading = false;
            isFetchingMore = false;
          });
          CustomSnackBar.show(
              context,
              message: state.message,
              isError: true
          );
        }
      },
    ),
  ],
  child: isLoading
      ? SizedBox.expand(
    child: DeliveryQcPageShimmer(height: height, width: width),
  )
      : Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.035,
              vertical: height * 0.015,
            ),
            child: Column(
              children: [
                ReusableSearchField(
                  controller: searchController,
                  hintText: 'Search by Truck No./Farmer/Broker',
                  onChanged: _onSearchChanged,
                ),
      
                AppDimensions.h20(context),
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

                      SizedBox(
                        width: width * 0.3,
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: _selectedFactoryName,
                          items: factoryList.map<DropdownMenuItem<String>>((e) {
                            return DropdownMenuItem<String>(
                              value: e['name'], // send name here
                              child: Text(e['name'], style: AppTextStyles.hintText),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _selectedFactoryName = val;
                              // find ID from name for internal use if needed
                              _selectedFactoryId = factoryList.firstWhere((e) => e['name'] == val)['_id'];
                              currentPage = 1;
                              _fetchData(); // API call will now use _selectedFactoryName
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Factory',
                            hintStyle: AppTextStyles.hintText,
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: width * 0.03,
                              vertical: height * 0.015,
                            ),
                          ),
                          validator: (val) => val == null ? 'Select Factory' : null,
                        ),
                      ),


                      SizedBox(width: width * 0.045),
      
                      CustomIconButton(
                        text: 'Filter',
                        iconData: Icons.tune,
                        onTap: _filter,
                        showIconOnRight: true,
                      ),
                    ],
                  ),
                ),
                AppDimensions.h20(context),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await Future.delayed(const Duration(milliseconds: 400)); // slight delay for smooth UI
                      _fetchData(page: 1);
                    },
                    child: qcData.isEmpty
                        ? ListView( // needed for RefreshIndicator to scroll
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Center(
                            child: Text(
                              "No records found",
                              style: AppTextStyles.bodyText
                            ),
                          ),
                        ),
                      ],
                    )
                        : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 10),
                      itemCount: qcData.length,
                      itemBuilder: (context, index) {
                        final data = qcData[index];
                        final transport = data['transportId'];
                        final broker = transport['brokerId'];
                        final purchase = transport['purchaseId'];
                        final user = data['userId'];
                        final transportStatus = (data['transportId']?['status'] ?? '').toLowerCase();
                        final qcStatus = (data['status'] ?? '').toLowerCase();

                        String finalStatus = '';

                        if (qcStatus == 'pending' && transportStatus == 'qc-check') {
                          finalStatus = 'initial-qc-pending';
                        } else if (qcStatus == 'approve' && transportStatus == 'qc-check') {
                          finalStatus = 'approve';
                        } else if (qcStatus == 'approve' && transportStatus == 'delivered') {
                          finalStatus = 'delivered';
                        } else {
                          finalStatus = transportStatus;
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.billingFillDetailsScreen,
                                arguments: null,
                              );
                            },
                            child: HomeInfoCard(
                              cardType: CardType.initialQC,
                              farmerName: purchase?['name'] ?? '~',
                              date: transport['deliverydate'] ?? '~',
                              vehicleNumber: transport['vehicleno'] ?? '~',
                              brokerName: broker['name'] ?? '~',
                              staffName: user['name'] ?? '~',
                              height: height,
                              width: width,
                              status: finalStatus,
                              weight: transport['weight'] ?? '~',
                              isSuperUser: true,
                              onPressed: () async {
                                final result = await Navigator.pushNamed(
                                  context,
                                  AppRoutes.initialQcApprovalScreen,
                                  arguments: data,
                                );
      
                                // If approval/rejection was successful, refresh list
                                if (result == true) {
                                 _fetchData();
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
),
    );
  }
}
