import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shree_ram_staff/Constants/app_dimensions.dart';
import 'package:shree_ram_staff/utils/app_routes.dart';
import 'package:shree_ram_staff/widgets/custom_app_bar.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../widgets/reusable_functions.dart';
import '../../../Bloc/ProductBloc/product_bloc.dart';

class ProductMasterScreen extends StatefulWidget {
  const ProductMasterScreen({super.key});

  @override
  State<ProductMasterScreen> createState() => _ProductMasterScreenState();
}

class _ProductMasterScreenState extends State<ProductMasterScreen> {
  TextEditingController searchController = TextEditingController();
  Timer? _debounce;
  List<dynamic> productData = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();

    // Listen to search changes with debounce
    searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        _fetchProducts(search: searchController.text.trim());
      });
    });
  }

  void _fetchProducts({String? search}) {
    context.read<ProductBloc>().add(
      GetAllProductEventHandler(search: search),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductSuccessState) {
          developer.log('ProductSuccessState: ${state.products}');
          setState(() => productData = state.products);
        } else if (state is ProductErrorState) {
          CustomSnackBar.show(
            context,
            message: state.message,
            isError: true,
          );
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Product Master',
          preferredHeight: height * 0.12,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.035,
            vertical: height * 0.015,
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  ReusableSearchField(
                    controller: searchController,
                    hintText: 'Search by Product Name',
                  ),
                  AppDimensions.h20(context),
                  Expanded(
                    child: BlocBuilder<ProductBloc, ProductState>(
                      builder: (context, state) {
                        if (state is ProductLoadingState) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (productData.isEmpty) {
                          return const Center(
                            child: Text("No products found"),
                          );
                        }

                        return ListView.separated(
                          itemCount: productData.length,
                          separatorBuilder: (_, __) =>
                          const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final product = productData[index];
                            return ListTile(
                              title: Text(product['name'] ?? '-'),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              CustomFAB(
                onTap: () async {
                  final result =
                  await Navigator.pushNamed(context, AppRoutes.addProductScreen);
                  if (result == true) {
                    _fetchProducts(search: searchController.text.trim());
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
