import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shree_ram_staff/Bloc/BillingBloc/billing_bloc.dart';
import 'package:shree_ram_staff/Bloc/FactoryBloc/factory_bloc.dart';
import 'package:shree_ram_staff/Bloc/QCBloc/qc_bloc.dart';
import 'package:shree_ram_staff/Constants/app_dimensions.dart';
import 'package:shree_ram_staff/Utils/image_assets.dart';
import 'package:shree_ram_staff/utils/app_colors.dart';
import 'package:shree_ram_staff/utils/app_routes.dart';
import 'package:shree_ram_staff/utils/flutter_font_styles.dart';
import 'package:shree_ram_staff/widgets/CustomCards/homeInfoCard.dart';
import 'package:shree_ram_staff/widgets/custom_app_bar.dart';
import 'package:shree_ram_staff/widgets/custom_snackbar.dart';
import 'package:shree_ram_staff/widgets/reusable_functions.dart';
import '../../../widgets/filter_popup.dart';

class BillingScreen extends StatefulWidget {
  final bool? isSuperUser;
  const BillingScreen({super.key, this.isSuperUser = false});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  DateTimeRange? selectedDateRange;
  String? selectedStatus;

  List<Map<String, String>> factoryList = [];
  String? _selectedFactoryId;
  bool isLoadingFactory = false;

  List<dynamic> billingList = [];
  bool isLoading = false;
  bool hasMore = true;
  int currentPage = 1;
  final int limit = 10;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    if (widget.isSuperUser == true) {
      context.read<FactoryBloc>().add(FactoryEventHandler());
    }
    _fetchBilling(refresh: true);
    _setupScrollListener();
  }

  void _setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100 &&
          !isLoading &&
          hasMore) {
        _fetchBilling();
      }
    });
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      _fetchBilling(refresh: true);
    });
  }

  void _pickDate() async {
    final picked = await pickDateRange(
      context: context,
      initialRange: selectedDateRange,
    );

    if (picked != null) {
      setState(() => selectedDateRange = picked);
      _fetchBilling(refresh: true);
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

    _fetchBilling(refresh: true);
  }

  void _fetchBilling({bool refresh = false}) {
    if (refresh) {
      billingList.clear();
      currentPage = 1;
      hasMore = true;
    }
    String? normalizedStatus;
    if (selectedStatus != null && selectedStatus!.isNotEmpty) {
      if (selectedStatus!.toLowerCase().contains('pending')) {
        normalizedStatus = 'Pending';
      } else if (selectedStatus!.toLowerCase().contains('approved')) {
        normalizedStatus = 'Approve';
      }
    }
    context.read<QcBloc>().add(getFinalQcEventHandler(
      page: currentPage,
      limit: limit,
      search: searchController.text.trim(),
      fromDate: selectedDateRange?.start.toIso8601String(),
      toDate: selectedDateRange?.end.toIso8601String(),
      factory: _selectedFactoryId,
      status: normalizedStatus,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return MultiBlocListener(
      listeners: [
        /// 🔸 Billing Listener
        BlocListener<QcBloc, QcState>(
          listener: (context, state) {
            if (state is getFinalQcLoadingState) {
              setState(() => isLoading = true);
            } else {
              setState(() => isLoading = false);
            }

            if (state is getFinalQcSuccessState) {
              developer.log('getFinalQcSuccessState: ${state.responseData}');
              final newData = state.responseData['data'] ?? [];
              if (newData.length < limit) hasMore = false;
              billingList.addAll(newData);
              currentPage++;
              setState(() {});
            }

            if (state is getFinalQcErrorState) {
              CustomSnackBar.show(context,
                  message: state.message, isError: true);
            }
          },
        ),

        /// 🔸 Factory Listener
        BlocListener<FactoryBloc, FactoryState>(
          listener: (context, state) {
            if (state is FactoryLoadingState) {
              setState(() => isLoadingFactory = true);
            } else {
              setState(() => isLoadingFactory = false);
            }

            if (state is FactorySuccessState) {
              final dataList = state.factoryData['data'] as List;
              factoryList = dataList
                  .map((e) => {
                '_id': e['_id'].toString(),
                'name': e['factoryname'].toString(),
              })
                  .toList();
              // if (factoryList.isNotEmpty) {
              //   _selectedFactoryId = factoryList.first['_id'];
              // }
              _selectedFactoryId = null;
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
          title: 'Billing',
          preferredHeight: height * 0.12,
        ),
        body: RefreshIndicator(
          onRefresh: () async => _fetchBilling(refresh: true),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.035,
              vertical: height * 0.015,
            ),
            child: Column(
              children: [
                // 🔍 Search Field
                ReusableSearchField(
                  controller: searchController,
                  hintText: 'Search Sample No./Farmer/Broker',
                  onChanged: _onSearchChanged,
                ),

                AppDimensions.h20(context),

                // 📅 Date picker + Filter + Factory
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
                              value: _selectedFactoryId,
                              hint: Row(
                                children: [
                                  Image.asset(
                                    ImageAssets.factoryPNG,
                                    height: 18,
                                    width: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text("Factory",
                                      style: AppTextStyles.bodyText),
                                ],
                              ),
                              items: factoryList.map((factory) {
                                return DropdownMenuItem<String>(
                                  value: factory['_id'],
                                  child: Text(factory['name'] ?? '-',
                                      style: AppTextStyles.hintText),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() => _selectedFactoryId = val);
                                _fetchBilling(refresh: true);
                              },
                              icon: const Icon(Icons.arrow_drop_down_rounded),
                            ),
                          ),
                        ),
                      ],
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

                // 🧾 Billing Cards List
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: billingList.length + (hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= billingList.length) {
                        return const Padding(
                          padding: EdgeInsets.all(10),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final data = billingList[index];
                      final transport = data['transportId'] ?? {};
                      final broker = transport['brokerId'] ?? {};
                      final farmer = transport['purchaseId'] ?? {};


                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: HomeInfoCard(
                          cardType: CardType.billing,
                          id: data['_id'] ?? '',
                          weight: transport['weight'] ?? '',
                          farmerName: farmer?['name'] ?? '',
                          date: transport['deliverydate'] ?? '',
                          vehicleNumber: transport['vehicleno'] ?? '',
                          brokerName: broker['name'] ?? '',
                          status: data['billing'] ?? '',
                          height: height,
                          width: width,
                          onPressed: () {
                            String status = data['billing']?.toString() ?? '';

                            String route;

                            if (status.toLowerCase().contains('pending')) {
                              // Pending status → Pending screen
                              route = widget.isSuperUser!
                                  ? AppRoutes.billingFillDetailsSuperUser // SuperUser Pending
                                  : AppRoutes.billingFillDetailsSuperUser;       // Normal Pending
                            } else {
                              // Other statuses → Completed/Approved screen
                              route = widget.isSuperUser!
                                  ? AppRoutes.billingDetailScreenSuperUser // SuperUser Completed
                                  : AppRoutes.billingDetailScreenSuperUser;   // Normal Completed
                            }

                            Navigator.pushNamed(context, route, arguments: data)
                                .then((value) {
                              if (value == true) _fetchBilling(refresh: true);
                            });
                          },

                          isSuperUser: widget.isSuperUser ?? false,
                        ),
                      );
                    },
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
