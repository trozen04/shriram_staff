import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shree_ram_staff/Bloc/SalesBloc/sales_bloc.dart';
import 'package:shree_ram_staff/Bloc/FactoryBloc/factory_bloc.dart';
import 'package:shree_ram_staff/utils/image_assets.dart';
import 'package:shree_ram_staff/widgets/CustomCards/sales_card.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../utils/app_routes.dart';
import '../../../utils/flutter_font_styles.dart';
import '../../../utils/app_colors.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/reusable_functions.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../widgets/filter_popup.dart'; // for showStatusFilterDialog()

class SalesScreen extends StatefulWidget {
  final bool? isSuperUser;
  const SalesScreen({super.key, this.isSuperUser = false});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  TextEditingController searchController = TextEditingController();
  DateTimeRange? selectedDateRange;
  ScrollController scrollController = ScrollController();
  Timer? _debounce;

  List<dynamic> salesData = [];
  bool isLoading = false;
  bool hasMore = true;
  int currentPage = 1;
  final int limit = 10;

  // 🔹 Factory
  List<Map<String, String>> factoryList = [];
  String? selectedFactoryId;
  bool isLoadingFactory = false;

  // 🔹 Status filter
  String? selectedStatus;

  @override
  void initState() {
    super.initState();

    if (widget.isSuperUser == true) {
      context.read<FactoryBloc>().add(FactoryEventHandler());
    }

    _fetchSales(refresh: true);
    _setupScrollListener();
  }

  void _setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100 &&
          !isLoading &&
          hasMore) {
        _fetchSales();
      }
    });
  }

  void _fetchSales({bool refresh = false}) {
    if (refresh) {
      salesData.clear();
      currentPage = 1;
      hasMore = true;
    }

    String? normalizedStatus;
    if (selectedStatus != null && selectedStatus!.isNotEmpty) {
      if (selectedStatus!.toLowerCase().contains('pending')) {
        normalizedStatus = 'Pending';
      } else if (selectedStatus!.toLowerCase().contains('approved')) {
        normalizedStatus = 'Approve';
      } else {
        normalizedStatus = selectedStatus;
      }
    }

    // 🔹 Different event for SuperUser / SubUser
    if (widget.isSuperUser == true) {
      context.read<SalesBloc>().add(
        GetAllSalesLeadsSuperUserEvent(
          page: currentPage,
          limit: limit,
          search: searchController.text.trim().isEmpty
              ? null
              : searchController.text.trim(),
          fromDate: selectedDateRange?.start.toIso8601String(),
          toDate: selectedDateRange?.end.toIso8601String(),
          status: normalizedStatus,
          factory: selectedFactoryId,
        ),
      );
    } else {
      context.read<SalesBloc>().add(
        GetAllSalesLeadsSubUserEvent(
          isSuperUser: widget.isSuperUser ?? false,
          page: currentPage,
          limit: limit,
          search: searchController.text.trim().isEmpty
              ? null
              : searchController.text.trim(),
          fromDate: selectedDateRange?.start.toIso8601String(),
          toDate: selectedDateRange?.end.toIso8601String(),
          status: normalizedStatus,
        ),
      );
    }
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      _fetchSales(refresh: true);
    });
  }

  void _pickDate() async {
    final picked = await pickDateRange(
      context: context,
      initialRange: selectedDateRange,
    );

    if (picked != null) {
      setState(() => selectedDateRange = picked);
      _fetchSales(refresh: true);
    }
  }

  void _filter() async {
    final selectedStatuses = await showStatusFilterDialog(
      context,
      initialSelected: selectedStatus != null ? [selectedStatus!] : [],
    );
    if (selectedStatuses == null) return;

    setState(() {
      selectedStatus =
      selectedStatuses.isNotEmpty ? selectedStatuses.first : null;
    });

    _fetchSales(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return MultiBlocListener(
      listeners: [
        // 🔹 Sales Bloc Listener
        BlocListener<SalesBloc, SalesState>(
          listener: (context, state) {
            if (state is SalesLoading) {
              setState(() => isLoading = true);
            } else {
              setState(() => isLoading = false);
            }

            if (state is SalesSuccess) {
              //developer.log("✅ Sales Success: ${state.responseData}");
              final dataList = state.responseData['data'] ?? [];
              if (dataList.length < limit) hasMore = false;
              salesData.addAll(dataList);
              currentPage++;
              setState(() {});
            }

            if (state is SalesError) {
              CustomSnackBar.show(context,
                  message: state.message, isError: true);
            }


          },
        ),
        BlocListener<SalesBloc, SalesState>(
          listener: (context, state) {
            if (state is AcceptSalesLeadLoading) {
              setState(() => isLoading = true); // optional: show overlay
            } else {
              setState(() => isLoading = false);
            }

            if (state is AcceptSalesLeadSuccess) {
              CustomSnackBar.show(
                context,
                message: "Sale accepted successfully",
                isError: false,
              );

              _fetchSales(refresh: true);
            }

            if (state is AcceptSalesLeadError) {
              CustomSnackBar.show(
                context,
                message: state.message,
                isError: true,
              );
            }
          },
        ),

        // 🔹 Factory Bloc Listener
        BlocListener<FactoryBloc, FactoryState>(
          listener: (context, state) {
            if (state is FactoryLoadingState) {
              setState(() => isLoadingFactory = true);
            } else {
              setState(() => isLoadingFactory = false);
            }

            if (state is FactorySuccessState) {
              final dataList = state.factoryData['data'] as List;
              final seenNames = <String>{};

              // ✅ Unique by factoryname
              factoryList = dataList
                  .where((e) => seenNames.add(e['factoryname'].toString().trim()))
                  .map((e) => {
                'name': e['factoryname'].toString().trim(),
              })
                  .toList();

              selectedFactoryId = null;
              setState(() {});
            }



            if (state is FactoryErrorState) {
              CustomSnackBar.show(context,
                  message: state.message, isError: true);
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: CustomAppBar(
          isHomePage: false,
          title: 'Sales',
          preferredHeight: height * 0.12,
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.035,
                vertical: height * 0.015,
              ),
              child: Column(
                children: [
                  // 🔍 Search
                  ReusableSearchField(
                    controller: searchController,
                    hintText: 'Search by Truck No./Farmer/Broker',
                    onChanged: _onSearchChanged,
                  ),

                  AppDimensions.h20(context),

                  // 📅 Filters Row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: width - width * 0.07),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomIconButton(
                            text: formatDateRange(selectedDateRange),
                            imagePath: ImageAssets.calender,
                            width: width,
                            height: height,
                            onTap: _pickDate,
                          ),

                          // 🔹 Factory Filter (SuperUser only)
                          if (widget.isSuperUser == true) ...[
                            SizedBox(width: width * 0.045),
                            isLoadingFactory
                                ? const SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                                : Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.03,
                                vertical: height * 0.00,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.16),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedFactoryId,
                                  hint: Row(
                                    children: [
                                      Image.asset(
                                        ImageAssets.factoryPNG,
                                        height: 18,
                                        width: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Text("Factory", style: AppTextStyles.bodyText),
                                    ],
                                  ),
                                  items: factoryList.map((factory) {
                                    final factoryName = factory['name'] ?? '';
                                    return DropdownMenuItem<String>(
                                      value: factoryName,
                                      child: Text(factoryName, style: AppTextStyles.hintText),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    setState(() => selectedFactoryId = val);
                                    _fetchSales(refresh: true);
                                  },
                                  icon: const Icon(Icons.arrow_drop_down_rounded),
                                ),
                              ),

                            ),
                          ],

                          SizedBox(width: width * 0.045),

                          // 🔹 Status Filter Button
                          CustomIconButton(
                            text: 'Filter',
                            iconData: Icons.tune,
                            onTap: _filter,
                            showIconOnRight: true,
                          ),
                        ],
                      ),
                    ),
                  ),

                  AppDimensions.h20(context),

                  // 🧾 Sales List
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async => _fetchSales(refresh: true),
                      child: isLoading && salesData.isEmpty
                          ? ListView(
                        children: [
                          SizedBox(
                            height: height * 0.6, // fill space to allow pull
                            child: Center(child: Text('No sales records found')),
                          ),
                        ],
                      )
                          : salesData.isEmpty
                          ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'No sales records found',
                              style: AppTextStyles.bodyText
                            ),
                          ],
                        ),
                      )
                          : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.only(bottom: 10),
                        itemCount: salesData.length + (hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= salesData.length) {
                            return const Padding(
                              padding: EdgeInsets.all(10),
                              child: Center(
                                  child: CircularProgressIndicator(strokeWidth: 2)),
                            );
                          }

                          final data = salesData[index];
                          final status = (data['status'] ?? '').toString().toLowerCase();

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: GestureDetector(
                              onTap: () async {
                                developer.log('status: $status');
                                if (widget.isSuperUser!) {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.salesDetailScreen,
                                    arguments: data,
                                  );
                                } else {
                                  if (status.contains('pending')) {
                                    final confirmed = await CustomConfirmationDialog.show(
                                      context: context,
                                      title: "Pending Sale",
                                      description: "Do you want to accept this sale?",
                                      confirmText: "Accept",
                                      cancelText: "Cancel",
                                      confirmColor: AppColors.primaryColor,
                                    );

                                    if (confirmed) {
                                      developer.log("Sale accepted: ${data['_id']}");
                                      context.read<SalesBloc>().add(
                                        AcceptSalesLeadEvent(leadId: data['_id']),
                                      );
                                    } else {
                                      developer.log("Sale cancelled: ${data['_id']}");
                                    }
                                    // 🔹 Do NOT navigate to loading screen, keep logic as is
                                  } else if(status.contains('accepted')) {
                                    final result = await Navigator.pushNamed(
                                      context,
                                      AppRoutes.loadingProductScreen,
                                      arguments: data,
                                    );

                                    // 🔹 If LoadingProductScreen returns true, fetch sales again
                                    if (result == true) {
                                      _fetchSales(refresh: true);
                                    }
                                  } else {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.salesDetailScreen,
                                      arguments: data,
                                    );
                                  }
                                }
                              },

                              child: SalesCard(
                                name: data['customername'] ?? '~',
                                date: data['createdAt'] ?? '~',
                                address: data['address'] ?? '~',
                                city: data['city'] ?? '~',
                                height: height,
                                width: width,
                                staffName: (data['acceptedBy'] != null && data['acceptedBy'] is Map && (data['acceptedBy']['name'] ?? '').toString().isNotEmpty)
                                    ? data['acceptedBy']['name']
                                    : '~',
                                status: data['status'] ?? '',
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
            if (widget.isSuperUser!)
              CustomFAB(
                onTap: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    AppRoutes.createSalesLeadScreen,
                  );

                  if (result == true) {
                    _fetchSales(refresh: true);
                  }
                },
              ),

          ],
        ),
      ),
    );
  }
}
