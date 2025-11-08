import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shree_ram_staff/Bloc/PurchaseRequest/purchase_request_bloc.dart';
import '../../../Bloc/QCBloc/qc_bloc.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../Utils/image_assets.dart';
import '../../../utils/app_routes.dart';
import '../../../utils/shimmers.dart';
import '../../../widgets/CustomCards/homeInfoCard.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../widgets/filter_popup.dart';
import '../../../widgets/reusable_functions.dart';

class DeliveryQcPage extends StatefulWidget {
  final bool isQCPage;
  const DeliveryQcPage({super.key, this.isQCPage = false});

  @override
  State<DeliveryQcPage> createState() => _DeliveryQcPageState();
}

class _DeliveryQcPageState extends State<DeliveryQcPage> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  DateTimeRange? selectedDateRange;
  bool isLoading = false;
  bool isFetchingMore = false;
  bool hasMoreData = true;
  int currentPage = 1;
  final int limit = 10;
  String searchQuery = '';
  String? selectedStatus;
  Timer? _debounce;

  List<dynamic> deliveryData = [];
  List<dynamic> qcData = [];

  @override
  void initState() {
    super.initState();

    // initial fetch
    _fetchData(page: 1);

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

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  /// 🧠 Unified data fetcher
  void _fetchData({
    int page = 1,
    String? fromDate,
    String? toDate,
    String? status,
    String? query,
  }) {
    setState(() {
      currentPage = page;
    });
    String? normalizedStatus;
    if (status != null && status.isNotEmpty) {
      if (status.toLowerCase().contains('pending')) {
        normalizedStatus = 'Pending';
      } else if (status.toLowerCase().contains('approved')) {
        normalizedStatus = 'Approve';
      }
    }
    if (widget.isQCPage) {
      // 🧾 Add logs to verify what’s being sent
      developer.log('🔹 Fetching Data - QC Page: ${widget.isQCPage}');
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
        ),
      );
    } else {
      context.read<PurchaseRequestBloc>().add(
        PurchaseRequestEventHandler(
          page: page,
          limit: limit,
          fromDate: fromDate,
          toDate: toDate,
          status: normalizedStatus,
          search: query,
        ),
      );
    }
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

  /// 📅 Date picker
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

  /// ⚙️ Filter by status
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(
        isHomePage: false,
        title: widget.isQCPage ? 'Final Quality Check' : 'Deliveries',
        preferredHeight: height * 0.12,
      ),
      body: MultiBlocListener(
        listeners: [

          ///Deliveries
          BlocListener<PurchaseRequestBloc, PurchaseRequestState>(
            listener: (context, state) {
              if (state is PurchaseRequestLoadingState) {
                if (currentPage == 1) {
                  setState(() => isLoading = true);
                } else {
                  setState(() => isFetchingMore = true);
                }
              } else if (state is PurchaseRequestSuccessState) {
                developer.log('Data::: ${state.purchaseRequestData}');
                final List<dynamic> fetchedData = state.purchaseRequestData['data'] ?? [];
                setState(() {
                  if (currentPage == 1) {
                    deliveryData = fetchedData;
                  } else {
                    deliveryData.addAll(fetchedData);
                  }
                  hasMoreData = fetchedData.length >= limit;
                  isLoading = false;
                  isFetchingMore = false;
                });
              } else if (state is PurchaseRequestErrorState) {
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

           ///QC
           BlocListener<QcBloc, QcState>(
              listener: (context, state) {
                if (state is GetAllQcLoadingState) {
                  if (currentPage == 1) {
                    setState(() => isLoading = true);
                  } else {
                    setState(() => isFetchingMore = true);
                  }
                } else if (state is GetAllQcSuccessState) {
                 developer.log('GetAllQcSuccessState: ${state.responseData}');
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
              // 🔍 Search
              ReusableSearchField(
                controller: searchController,
                hintText: widget.isQCPage
                    ? 'Search Sample No./Farmer/Broker'
                    : 'Search by Truck No./Farmer/Broker',
                onChanged: _onSearchChanged,
              ),
              AppDimensions.h20(context),

              // 📅 Date & Filter
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
                  CustomIconButton(
                    text: 'Filter',
                    iconData: Icons.tune,
                    onTap: _filter,
                    showIconOnRight: true,
                  ),
                ],
              ),
              AppDimensions.h20(context),

              // 📋 List
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await Future.delayed(const Duration(milliseconds: 400)); // slight delay for smooth UI
                    _fetchData(page: 1);
                  },
                  color: Theme.of(context).primaryColor,
                  backgroundColor: Colors.white,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: (widget.isQCPage
                        ? qcData.length
                        : deliveryData.length) +
                        (isFetchingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (isFetchingMore &&
                          index ==
                              (widget.isQCPage
                                  ? qcData.length
                                  : deliveryData.length)) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final data = widget.isQCPage
                          ? qcData[index]
                          : deliveryData[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: HomeInfoCard(
                          cardType: widget.isQCPage ? CardType.qc : CardType.delivery,
                          id: widget.isQCPage
                              ? (data['transportId'] != null
                              ? (data['transportId']['_id'] ?? '')
                              : '')
                              : '',
                          farmerName: widget.isQCPage
                              ? (data['transportId'] != null &&
                              data['transportId']['purchaseId'] != null
                              ? (data['transportId']['purchaseId']['name'] ?? '')
                              : '')
                              : (data['purchaseId'] != null
                              ? (data['purchaseId']['name'] ?? '')
                              : ''),
                          date: widget.isQCPage
                              ? (data['transportId'] != null
                              ? (data['transportId']['deliverydate'] ?? '')
                              : '')
                              : (data['deliverydate'] ?? ''),
                          vehicleNumber: widget.isQCPage
                              ? (data['transportId'] != null
                              ? (data['transportId']['vehicleno'] ?? '')
                              : '')
                              : (data['vehicleno'] ?? ''),
                          brokerName: widget.isQCPage
                              ? (data['transportId'] != null
                              ? (data['transportId']['brokerId']?['name'] ?? '')
                              : '')
                              : (data['brokerId'] != null
                              ? (data['brokerId']['name'] ?? '')
                              : ''),
                          weight: widget.isQCPage
                              ? (data['transportId'] != null
                              ? (data['transportId']['weight'] ?? '')
                              : '')
                              : (data['weight'] ?? ''),
                          status: data['status'] ?? '',

                          height: height,
                          width: width,
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.deliveryDetailPage,
                              arguments: {
                                'data': data,
                                'isQcPage': widget.isQCPage ? true : false,
                              },
                            ).then((_) {
                              _fetchData(page: 1); // 🔁 Refresh after pop
                            });
                          },
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
