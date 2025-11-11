import 'dart:developer' as developer;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shree_ram_staff/Bloc/SubUsers/subusers_bloc.dart';
import 'package:shree_ram_staff/Utils/image_assets.dart';
import 'package:shree_ram_staff/utils/app_colors.dart';
import '../../../Bloc/FactoryBloc/factory_bloc.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../utils/app_routes.dart';
import '../../../utils/flutter_font_styles.dart';
import '../../../widgets/CustomCards/SuperUser/sub_user_card.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../widgets/reusable_functions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubUsersList extends StatefulWidget {
  const SubUsersList({super.key});

  @override
  State<SubUsersList> createState() => _SubUsersListState();
}

class _SubUsersListState extends State<SubUsersList> {
  TextEditingController searchController = TextEditingController();
  List<dynamic> subUsersList = [];
  List<dynamic> factoryList = [];
  String? _selectedFactoryId;
  String? _selectedFactoryName;
  bool isFactoryLoading = false;
  bool isLoading = false;
  Timer? _debounce;
  ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _fetchSubUsers();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        if (!_isLoadingMore && _currentPage < _totalPages) {
          _fetchSubUsers(nextPage: true);
        }
      }
    });

    context.read<FactoryBloc>().add(FactoryEventHandler());
  }

  void _fetchSubUsers({bool nextPage = false}) {
    if (nextPage) _currentPage++;
    _isLoadingMore = true;

    // Send factory name instead of ID
    context.read<SubusersBloc>().add(SubUsersFetchEvent(
      page: _currentPage,
      search: searchController.text,
      factoryId: _selectedFactoryName,
    ));
  }


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(
        isHomePage: false,
        title: 'Sub Users',
        preferredHeight: height * 0.12,
      ),
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
                // Get all factory names
                final allFactories = (state.factoryData['data'] as List)
                    .where((e) => e['factoryname'] != null)
                    .map((e) => {
                  '_id': e['_id'].toString(),
                  'name': e['factoryname'].toString(),
                })
                    .toList();

                // Use a set to track unique names
                final uniqueFactoryNames = <String>{};
                factoryList = [];

                for (var f in allFactories) {
                  if (!uniqueFactoryNames.contains(f['name'])) {
                    uniqueFactoryNames.add(f['name']!);
                    factoryList.add(f);
                  }
                }

                // Default select first factory if none selected
                if (_selectedFactoryName == null && factoryList.isNotEmpty) {
                  _selectedFactoryName = factoryList.first['name'];
                  _selectedFactoryId = factoryList.first['_id'];
                }

                setState(() {});
              }

              if (state is FactoryErrorState) {
                CustomSnackBar.show(context, message: state.message, isError: true);
              }
            },
          ),

          BlocListener<SubusersBloc, SubusersState>(
            listener: (context, state) {
              if(state is SubusersLoadingState) {
                setState(() {
                  isLoading = true;
                });
              } else {
                setState(() {
                  isLoading = false;
                });
              }
              if (state is SubusersSuccessState) {
                developer.log('success: ${state.subusersData}');

                // Correct totalPages
                _totalPages = state.subusersData['totalPages'] ?? 1;

                List<dynamic> newData = state.subusersData['data'] ?? [];

                if (_currentPage == 1) {
                  subUsersList = newData;
                } else {
                  subUsersList.addAll(newData);
                }

                _isLoadingMore = false;
                setState(() {});
              }
              if (state is SubusersErrorState) {
                _isLoadingMore = false;
                CustomSnackBar.show(context, message: state.message, isError: true);
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
            // Search + Factory Dropdown Row
            Row(
              children: [
                Expanded(
                  child: ReusableSearchField(
                    controller: searchController,
                    hintText: 'Search by name',
                    onChanged: (value) {
                      if (_debounce?.isActive ?? false) _debounce!.cancel();
                      _debounce = Timer(const Duration(seconds: 1), () {
                        _currentPage = 1;
                        _fetchSubUsers();
                      });
                    },
                  ),
                ),
                AppDimensions.w10(context),
                SizedBox(
                  width: width * 0.3,
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: _selectedFactoryName,
                    items: factoryList.map<DropdownMenuItem<String>>((e) {
                      return DropdownMenuItem<String>(
                        value: e['name'], // pass name
                        child: Text(e['name'], style: AppTextStyles.hintText),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedFactoryName = val;
                        _selectedFactoryId = factoryList.firstWhere((e) => e['name'] == val)['_id'];
                        _currentPage = 1;
                        _fetchSubUsers();
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
                  ),

                ),
              ],
            ),
            AppDimensions.h20(context),

            // SubUser List
            isLoading
                ? Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
                : subUsersList.isEmpty
                ? Center(
              child: Padding(
                padding: EdgeInsets.only(top: 50),
                child: Text(
                  'No subusers found',
                  style: AppTextStyles.hintText
                ),
              ),
            )
                : Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: subUsersList.length + (_currentPage < _totalPages ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == subUsersList.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  }
                  final data = subUsersList[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.staffDetails,
                          arguments: data,
                        );
                      },
                      child: SubUserCard(
                        name: data['name'] ?? '~',
                        date: data['createdAt'] ?? '~',
                        position: data['role'] ?? '~',
                        phone: data['mobileno'] ?? '~',
                        email: data['email'] ?? '~',
                        qcType: data['authority'] ?? '~',
                       // factory: data?['factory']?['factoryname'] ?? '~',
                        height: height,
                        width: width,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
      floatingActionButton: CustomFAB(
        onTap: () async {
          final result = await Navigator.pushNamed(
            context,
            AppRoutes.createSubUserPage,
            arguments: null,
          );

          if (result == true) {
            _currentPage = 1;
            _fetchSubUsers();
          }
        },
      ),
    );
  }
}


