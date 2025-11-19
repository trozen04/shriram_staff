import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Bloc/ExpenseBloc/expense_bloc.dart';
import '../../../Bloc/FactoryBloc/factory_bloc.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../Utils/image_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_routes.dart';
import '../../../utils/flutter_font_styles.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/primary_and_outlined_button.dart';
import '../../../widgets/reusable_functions.dart';
import '../../../widgets/expensePopUp.dart';
import '../../../widgets/custom_snackbar.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  DateTimeRange? selectedDateRange;
  Timer? _debounce;
  ScrollController scrollController = ScrollController();
  bool isDownload = false;
  // Factories
  Map<String, String> factoryMap = {}; // name -> id (not needed now)
  Set<String> factoryNames = {};
  String? selectedFactoryName;
  bool isLoadingFactory = false;

  // Pagination
  bool isLoadingMore = false;
  int currentPage = 1;
  int limit = 20;
  bool hasMore = true;

  List<dynamic> expenseData = [];

  @override
  void initState() {
    super.initState();
    context.read<FactoryBloc>().add(FactoryEventHandler());
    _fetchExpenses(reset: true);

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 300 &&
          !isLoadingMore &&
          hasMore) {
        _fetchExpenses();
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
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
      _fetchExpenses(reset: true);
    }
  }

  void _fetchExpenses({bool reset = false, bool isDownload = false}) {
    if (reset) {
      currentPage = 1;
      hasMore = true;
      expenseData.clear();
    }

    if (!isDownload) {
      setState(() => isLoadingMore = true);
    }

    final fromDate = selectedDateRange?.start.toIso8601String();
    final toDate = selectedDateRange?.end.toIso8601String();
    final factoryName = selectedFactoryName;

    developer.log(
        'Fetching expenses page $currentPage: from=$fromDate, to=$toDate, factoryname=$factoryName');

    context.read<ExpenseBloc>().add(GetAllExpenseEventHandler(
      page: currentPage,
      limit: limit,
      fromDate: fromDate,
      toDate: toDate,
      factoryName: factoryName,
      isDownload: isDownload,
    ));
  }

  void _onFetchMoreSuccess(List<dynamic> newData) {
    setState(() {
      isLoadingMore = false;
      if (newData.length < limit) hasMore = false;
      else currentPage++;
      expenseData.addAll(newData);
    });
  }

  void _showAddExpensePopup() {
    showDialog(
      context: context,
      builder: (context) => ExpensePopup(
        onSubmit: (amount, reason) {
          // Parse the amount from String to int
          final parsedAmount = int.tryParse(amount.trim()) ?? 0;

          if (parsedAmount <= 0 || reason.trim().isEmpty) {
            // Show error if invalid
            CustomSnackBar.show(context, message: "Please enter a valid amount and reason", isError: true);
            return;
          }

          developer.log('CreateExpense API Body: amount=$parsedAmount, reason=$reason');

          // Fire the Bloc event
          context.read<ExpenseBloc>().add(
            CreateExpenseEventHandler(
              amount: parsedAmount,
              reason: reason.trim(),
            ),
          );
        },


      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Expenses',
        preferredHeight: height * 0.12,
      ),
      body: MultiBlocListener(
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
          BlocListener<ExpenseBloc, ExpenseState>(
            listener: (context, state) {
              if (state is ExpenseSuccessState) {
                if (state.isCreate) {
                  CustomSnackBar.show(context, message: 'Expense added successfully');
                  _fetchExpenses(reset: true);
                } else {
                  _onFetchMoreSuccess(state.expenseData ?? []);
                }
              }
              if (state is ExpenseErrorState) {
                setState(() => isLoadingMore = false);
                CustomSnackBar.show(context, message: state.message, isError: true);
              }
            },
          ),
        ],
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.035, vertical: height * 0.015),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date + Factory buttons
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
                    AppDimensions.w20(context),
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
                            _fetchExpenses(reset: true);
                          },
                          icon: const Icon(Icons.arrow_drop_down_rounded, color: AppColors.primaryColor),
                        ),
                      ),
                    ),
                    AppDimensions.w20(context),
                    SizedBox(
                      width: width * 0.25,
                      child: PrimaryButton(
                        text: 'Save',
                        onPressed: () {
                          setState(() {
                            isDownload = true;
                          });

                          _fetchExpenses(
                            isDownload: true,
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              AppDimensions.h20(context),

              // Header row
              ProfileRow(label: 'Reason', value: 'Amount'),

              // Expense list with pagination
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: expenseData.length + (hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= expenseData.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final item = expenseData[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item['reason'] ?? '',
                              style: AppTextStyles.profileDataText,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ),
                          Text(
                            formatAmount(item['amount'] ?? 0),
                            style: AppTextStyles.profileDataText,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: CustomFAB(onTap: _showAddExpensePopup),
    );

  }
}
