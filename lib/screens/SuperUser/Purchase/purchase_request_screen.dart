import 'dart:async';
import 'dart:developer' as developer;
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
import '../../../widgets/primary_and_outlined_button.dart';
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
  bool isDownload = false;
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
    String? factoryId,
    bool? isDownload,
  }) {
    context.read<PurchaseRequestBloc>().add(
      purchaseRequest(
        page: page,
        limit: limit,
        search: query,
        status: status,
        fromDate: fromDate,
        toDate: toDate,
        factoryName: factoryId,
        isDownload: isDownload ?? false,
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
                final rawFactories = (state.factoryData['data'] as List).cast<Map<String, dynamic>>();
                final seenFactories = <String>{};

                factoryList = rawFactories
                    .where((e) => seenFactories.add(e['factoryname'].toString()))
                    .map((e) => {
                  '_id': e['_id'].toString(),
                  'name': e['factoryname'].toString(),
                })
                    .toList();

                // Default select first factory
                if (factoryList.isNotEmpty && selectedFactoryId == null) {
                  selectedFactoryId = factoryList.first['_id'];
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
                developer.log('PurchaseRequestSuccessState: ${state.purchaseRequestData}');
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
              /// Search + Download button

              Row(
                children: [
                  Expanded(
                    child: ReusableSearchField(
                      controller: searchController,
                      hintText: 'Search by Truck No./Farmer/Broker',
                      onChanged: _onSearchChanged,
                    ),
                  ),
                  AppDimensions.w10(context),
                  SizedBox(
                    width: width * 0.25,
                    child: PrimaryButton(
                      text: 'Save',
                      onPressed: () {
                        setState(() {
                          isDownload = true; // trigger download param
                        });

                        _fetchData(
                          page: 1,
                          fromDate: selectedDateRange != null
                              ? DateFormat('yyyy-MM-dd').format(selectedDateRange!.start)
                              : null,
                          toDate: selectedDateRange != null
                              ? DateFormat('yyyy-MM-dd').format(selectedDateRange!.end)
                              : null,
                          status: selectedStatus,
                          query: searchQuery,
                          isDownload: true, // pass flag
                        );
                      },
                    ),
                  )
                ],
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
                    Container(
                      width: width * 0.35,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.16),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: selectedFactoryId,
                        hint: Text(
                          'Select Factory',
                          style: AppTextStyles.hintText.copyWith(fontSize: 14),
                        ),
                        items: factoryList.map<DropdownMenuItem<String>>((e) {
                          return DropdownMenuItem<String>(
                            value: e['_id'],
                            child: Text(
                              e['name'],
                              style: AppTextStyles.hintText.copyWith(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedFactoryId = val;
                            currentPage = 1;
                          });

                          final selectedFactoryName = factoryList
                              .firstWhere((element) => element['_id'] == val)['name'];

                          _fetchData(
                            page: 1,
                            factoryId: selectedFactoryName,
                            status: selectedStatus,
                            query: searchQuery,
                          );
                        },
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 22),
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.primaryColor, width: 1.2),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: width * 0.03,
                            vertical: height * 0.012,
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
                          farmerName: data['name'] ?? '~',
                          brokerName: broker['name'] ?? '~',
                          date: data['date'] != null
                              ? formatToIST(data['date'])
                              : '~',
                          status: data['status'],
                          paddy: data['paddytype'] ?? '~',
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
