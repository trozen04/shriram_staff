import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shree_ram_staff/Bloc/PurchaseRequest/purchase_request_bloc.dart';
import 'package:shree_ram_staff/Bloc/FactoryBloc/factory_bloc.dart';
import 'package:shree_ram_staff/widgets/CustomCards/SuperUser/purchase_request_card.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../Utils/image_assets.dart';
import '../../../Utils/app_routes.dart';
import '../../../utils/app_colors.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/filter_popup.dart';
import '../../../widgets/reusable_functions.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../utils/flutter_font_styles.dart';

class PurchaseRequestScreen extends StatefulWidget {
  const PurchaseRequestScreen({super.key});

  @override
  State<PurchaseRequestScreen> createState() => _PurchaseRequestScreenState();
}

class _PurchaseRequestScreenState extends State<PurchaseRequestScreen> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Timer? _debounce;
  DateTimeRange? selectedDateRange;
  String? selectedStatus;
  String? searchQuery;

  String? selectedFactoryId;
  List<dynamic> factoryList = [];
  bool isFactoryLoading = false;

  List<dynamic> deliveryData = [];
  bool isLoading = false;
  bool isFetchingMore = false;
  bool hasMoreData = true;
  int currentPage = 1;
  final int limit = 10;

  @override
  void initState() {
    super.initState();
    context.read<FactoryBloc>().add(FactoryEventHandler());
    _fetchData(page: 1);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  /// 🧭 Fetch Data from Bloc
  void _fetchData({
    required int page,
    String? query,
    String? status,
    String? fromDate,
    String? toDate,
    String? factoryId, // now passing factory name
  }) {
    context.read<PurchaseRequestBloc>().add(
      PurchaseRequestEventHandler(
        page: page,
        limit: limit,
        search: query,
        status: status,
        fromDate: fromDate,
        toDate: toDate,
        factoryName: factoryId, // sending name
      ),
    );
  }


  /// 📜 Infinite scroll pagination
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      if (!isFetchingMore && hasMoreData) {
        setState(() => currentPage++);
        _fetchData(
          page: currentPage,
          query: searchQuery,
          status: selectedStatus,
          fromDate: selectedDateRange != null
              ? DateFormat('yyyy-MM-dd').format(selectedDateRange!.start)
              : null,
          toDate: selectedDateRange != null
              ? DateFormat('yyyy-MM-dd').format(selectedDateRange!.end)
              : null,
          factoryId: selectedFactoryId,
        );
      }
    }
  }

  /// 🔍 Debounced search
  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () {
      setState(() {
        searchQuery = value;
        currentPage = 1;
      });
      _fetchData(
        page: 1,
        query: value,
        status: selectedStatus,
        factoryId: selectedFactoryId,
      );
    });
  }

  /// 📅 Pick Date Range
  Future<void> _pickDate() async {
    final DateTimeRange? picked = await pickDateRange(
      context: context,
      initialRange: selectedDateRange,
    );

    if (picked != null) {
      setState(() {
        selectedDateRange = picked;
        currentPage = 1;
      });
      _fetchData(
        page: 1,
        fromDate: DateFormat('yyyy-MM-dd').format(picked.start),
        toDate: DateFormat('yyyy-MM-dd').format(picked.end),
        status: selectedStatus,
        factoryId: selectedFactoryId,
      );
    }
  }

  /// ⚙️ Status Filter
  void _filter() async {
    final selectedStatuses = await showStatusFilterDialog(
      context,
      initialSelected: selectedStatus != null ? [selectedStatus!] : [],
    );
    if (selectedStatuses == null) return;

    setState(() {
      selectedStatus = selectedStatuses.isNotEmpty ? selectedStatuses.first : null;
      currentPage = 1;
    });

    _fetchData(
      page: 1,
      status: selectedStatus,
      factoryId: selectedFactoryId,
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
        title: 'Purchase Request',
        preferredHeight: height * 0.12,
      ),
      body: MultiBlocListener(
        listeners: [
          /// 🏭 FactoryBloc Listener
          BlocListener<FactoryBloc, FactoryState>(
            listener: (context, state) {
              if (state is FactoryLoadingState) {
                setState(() => isFactoryLoading = true);
              } else {
                setState(() => isFactoryLoading = false);
              }

              if (state is FactorySuccessState) {
                // Extract unique factory names
                final factoryNamesSet = <String>{};
                factoryList = (state.factoryData['data'] as List)
                    .where((e) => e['factoryname'] != null)
                    .map((e) {
                  factoryNamesSet.add(e['factoryname'].toString());
                  return {
                    '_id': e['_id'].toString(),
                    'name': e['factoryname'].toString(),
                  };
                })
                    .toList();

                // Keep only unique names
                final uniqueFactoryNames = factoryNamesSet.toList();

                // Default select first factory
                if (uniqueFactoryNames.isNotEmpty && selectedFactoryId == null) {
                  selectedFactoryId = factoryList
                      .firstWhere((e) => e['name'] == uniqueFactoryNames.first)['_id'];
                }

                setState(() {});
              }


              if (state is FactoryErrorState) {
                CustomSnackBar.show(context,
                    message: state.message, isError: true);
              }
            },
          ),

          /// 📦 PurchaseRequestBloc Listener
          BlocListener<PurchaseRequestBloc, PurchaseRequestState>(
            listener: (context, state) {
              if (state is PurchaseRequestLoadingState) {
                if (currentPage == 1) {
                  setState(() => isLoading = true);
                } else {
                  setState(() => isFetchingMore = true);
                }
              } else if (state is PurchaseRequestSuccessState) {
                final List<dynamic> fetchedData =
                    state.purchaseRequestData['data'] ?? [];
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
                CustomSnackBar.show(context,
                    message: state.message, isError: true);
              }
            },
          ),
        ],
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.035,
            vertical: height * 0.015,
          ),
          child: Column(
            children: [
              /// 🔍 Search + Factory Dropdown
              ReusableSearchField(
                controller: searchController,
                hintText: 'Search by Truck No./Farmer/Broker',
                onChanged: _onSearchChanged,
              ),

              AppDimensions.h20(context),

              /// 📅 Date + Status Filter
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
                        value: selectedFactoryId,
                        hint: Text('Factory', style: AppTextStyles.hintText),
                        items: factoryList.map<DropdownMenuItem<String>>((e) {
                          return DropdownMenuItem<String>(
                            value: e['_id'],
                            child: Text(e['name'], style: AppTextStyles.hintText),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedFactoryId = val;
                            currentPage = 1;
                          });

                          // Get factory name from _id
                          final selectedFactoryName = factoryList
                              .firstWhere((element) => element['_id'] == val)['name'];

                          _fetchData(
                            page: 1,
                            factoryId: selectedFactoryName, // send name to API
                            status: selectedStatus,
                            query: searchQuery,
                          );
                        },

                        decoration: InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: width * 0.03,
                            vertical: height * 0.015,
                          ),
                        ),
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

              /// 📦 List Section
              if (isLoading)
                Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  ),
                )
              else if (deliveryData.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text(
                      'No Purchase Requests Found',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: deliveryData.length + (hasMoreData ? 1 : 0),
                    padding: const EdgeInsets.only(bottom: 10),
                    itemBuilder: (context, index) {
                      if (index == deliveryData.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      }

                      final data = deliveryData[index];
                      final broker = data['brokerId'] ?? {};
                      final purchase = data['purchaseId'] ?? {};

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: PurchaseRequestCard(
                          farmerName: purchase['name'] ?? '~',
                          brokerName: broker['name'] ?? '~',
                          date: data['deliverydate'] != null
                              ? formatToIST(data['deliverydate'])
                              : '~',
                          status: data['status'],
                          paddy: purchase['paddytype'] ?? '~',
                          height: height,
                          width: width,
                          onPressed: () async {
                            final result = await Navigator.pushNamed(
                              context,
                              AppRoutes.purchaseRequestDetail,
                              arguments: data,
                            );

                            if (result == true) {
                              // Refresh the list
                              setState(() {
                                currentPage = 1;
                              });
                              _fetchData(page: 1);
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
