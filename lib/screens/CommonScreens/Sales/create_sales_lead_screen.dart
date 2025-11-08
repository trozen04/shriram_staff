import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shree_ram_staff/utils/app_colors.dart';
import 'package:shree_ram_staff/utils/flutter_font_styles.dart';
import 'package:shree_ram_staff/Constants/app_dimensions.dart';
import 'package:shree_ram_staff/widgets/primary_and_outlined_button.dart';
import 'package:shree_ram_staff/widgets/reusable_appbar.dart';
import '../../../Bloc/ProductBloc/product_bloc.dart';
import '../../../Bloc/FactoryBloc/factory_bloc.dart';
import '../../../Bloc/SalesBloc/sales_bloc.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../widgets/reusable_functions.dart';

class CreateSalesLeadScreen extends StatefulWidget {
  const CreateSalesLeadScreen({super.key});

  @override
  State<CreateSalesLeadScreen> createState() => _CreateSalesLeadScreenState();
}

class ItemField {
  final TextEditingController bagsController;
  final TextEditingController qtyController;
  String? productId;
  String? productName;

  ItemField({
    required this.bagsController,
    required this.qtyController,
    this.productId,
    this.productName,
  });

  void dispose() {
    bagsController.dispose();
    qtyController.dispose();
  }
}

class _CreateSalesLeadScreenState extends State<CreateSalesLeadScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();

  List<Map<String, String>> factoryList = [];
  String? _selectedFactory;
  bool isLoadingFactory = false;

  List<ItemField> _items = [
    ItemField(
      bagsController: TextEditingController(),
      qtyController: TextEditingController(),
    ),
  ];

  List<Map<String, dynamic>> productList = [];
  bool isLoadingProducts = false;

  @override
  void initState() {
    super.initState();
    context.read<FactoryBloc>().add(FactoryEventHandler());
    context.read<ProductBloc>().add(GetAllProductEventHandler());
  }

  @override
  void dispose() {
    for (var item in _items) {
      item.dispose();
    }
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _addNewItem() {
    setState(() {
      _items.add(ItemField(
        bagsController: TextEditingController(),
        qtyController: TextEditingController(),
      ));
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items[index].dispose();
      _items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return MultiBlocListener(
      listeners: [
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
              factoryList = dataList
                  .map((e) => {
                '_id': e['_id'].toString(),
                'name': e['factoryname'].toString(),
              })
                  .toList();
              _selectedFactory = null;
              setState(() {});
            }

            if (state is FactoryErrorState) {
              CustomSnackBar.show(context,
                  message: state.message, isError: true);
            }
          },
        ),

        // 🔹 Product Bloc Listener
        BlocListener<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state is ProductLoadingState) {
              setState(() => isLoadingProducts = true);
            } else {
              setState(() => isLoadingProducts = false);
            }

            if (state is ProductSuccessState) {
              developer.log('products: ${state.products}');

              // Convert safely to a typed list
              final rawList = (state.products as List)
                  .map((e) => Map<String, dynamic>.from(e as Map))
                  .toList();

              // Remove duplicates by name (safe way)
              final seenNames = <String>{};
              productList = [];
              for (var e in rawList) {
                final name = e['name']?.toString() ?? '';
                if (!seenNames.contains(name)) {
                  seenNames.add(name);
                  productList.add({
                    '_id': e['_id']?.toString() ?? '',
                    'name': name,
                  });
                }
              }

              setState(() {});
            }


            if (state is ProductErrorState) {
              CustomSnackBar.show(context,
                  message: state.message, isError: true);
            }
          },
        ),

        // 🔹 Sales Bloc Listener
        BlocListener<SalesBloc, SalesState>(
          listener: (context, state) {
            if (state is SalesCreateSuccess) {
              Navigator.pop(context, true);
            } else if (state is SalesError) {
              CustomSnackBar.show(context,
                  message: state.message, isError: true);
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: const ReusableAppBar(title: 'Create Sales Lead'),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.035, vertical: height * 0.015),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🧾 Customer Info
                ReusableTextField(
                  label: 'Customer Name',
                  hint: 'Enter Name',
                  controller: _nameController,
                  validator: (val) => val == null || val.isEmpty
                      ? 'Customer name is required'
                      : null,
                ),
                AppDimensions.h10(context),
                ReusableTextField(
                  label: 'Phone Number',
                  hint: 'Enter Phone Number',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Enter phone number';
                    if (val.length < 10) return 'Enter valid number';
                    return null;
                  },
                ),
                AppDimensions.h10(context),
                ReusableTextField(
                  label: 'Address',
                  hint: 'Enter Address',
                  controller: _addressController,
                  validator: (val) =>
                  val == null || val.isEmpty ? 'Enter address' : null,
                ),
                AppDimensions.h10(context),
                ReusableTextField(
                  label: 'City/Town',
                  hint: 'Enter City/Town',
                  controller: _cityController,
                  validator: (val) =>
                  val == null || val.isEmpty ? 'Enter city/town' : null,
                ),
                AppDimensions.h10(context),

                // 🏭 Factory Dropdown
                Text('Factory', style: AppTextStyles.label),
                AppDimensions.h5(context),
                isLoadingFactory
                    ? const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColors.borderColor, width: 1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedFactory,
                    hint: Text('Select Factory',
                        style: AppTextStyles.bodyText),
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down),
                    style: AppTextStyles.bodyText,
                    items: factoryList
                        .map((f) => DropdownMenuItem<String>(
                      value: f['_id'],
                      child: Text(f['name']!,
                          style: AppTextStyles.bodyText),
                    ))
                        .toList(),
                    onChanged: (val) =>
                        setState(() => _selectedFactory = val),
                    validator: (val) => val == null || val.isEmpty
                        ? 'Select factory'
                        : null,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero),
                  ),
                ),
                AppDimensions.h10(context),

                // 🧩 Product Items
                ..._items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Item ${index + 1}',
                              style: AppTextStyles.label),
                          if (_items.length > 1)
                            IconButton(
                              icon:
                              const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeItem(index),
                            ),
                        ],
                      ),
                      isLoadingProducts
                          ? const Center(
                        child:
                        CircularProgressIndicator(strokeWidth: 2),
                      )
                          : Container(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors.borderColor, width: 1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: item.productId,
                          hint: Text('Select Product',
                              style: AppTextStyles.bodyText),
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
                          style: AppTextStyles.bodyText,
                          items: productList
                              .where((p) {
                            final selectedIds = _items
                                .where((it) => it.productId != null)
                                .map((it) => it.productId)
                                .toSet();
                            return !selectedIds.contains(p['_id']) ||
                                item.productId == p['_id'];
                          })
                              .map((product) => DropdownMenuItem<String>(
                            value: product['_id'],
                            child: Text(product['name'] ?? ''),
                          ))
                              .toList(),
                          onChanged: (val) {
                            final selected = productList.firstWhere(
                                  (p) => p['_id'] == val,
                              orElse: () => <String, dynamic>{}, // ✅ FIXED
                            );
                            setState(() {
                              item.productId = val;
                              item.productName =
                                  selected['name'] ?? '';
                            });
                          },
                          validator: (val) => val == null || val.isEmpty
                              ? 'Select product'
                              : null,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      AppDimensions.h10(context),
                      ReusableTextField(
                        label: 'Bags',
                        hint: 'Enter No. of Bags',
                        controller: item.bagsController,
                        keyboardType: TextInputType.number,
                        validator: (val) => val == null || val.isEmpty
                            ? 'Enter number of bags'
                            : null,
                      ),
                      AppDimensions.h10(context),
                      ReusableTextField(
                        label: 'Weight',
                        hint: 'Enter Weight',
                        controller: item.qtyController,
                        keyboardType: TextInputType.number,
                        validator: (val) =>
                        val == null || val.isEmpty ? 'Enter weight' : null,
                      ),
                      AppDimensions.h20(context),
                    ],
                  );
                }).toList(),

                // ➕ Add Item
                Center(
                  child: OutlinedButton.icon(
                    onPressed: _addNewItem,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Another Item'),
                    style: OutlinedButton.styleFrom(
                      side:
                      const BorderSide(color: AppColors.primaryColor),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
                AppDimensions.h30(context),

                // ✅ Submit Button
                PrimaryButton(
                  text: 'Submit',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final itemsPayload = _items.map((item) {
                        return {
                          'item': item.productId ?? '',
                          'bags':
                          int.tryParse(item.bagsController.text) ?? 0,
                          'weight':
                          int.tryParse(item.qtyController.text) ?? 0,
                        };
                      }).toList();

                      final payload = {
                        'customername': _nameController.text,
                        'phoneno': _phoneController.text,
                        'address': _addressController.text,
                        'city': _cityController.text,
                        'factory': _selectedFactory ?? '',
                        'items': itemsPayload,
                      };

                      developer.log('📤 Payload: $payload');

                      context.read<SalesBloc>().add(
                        CreateSalesLeadEvent(
                          customerName: _nameController.text,
                          phoneNo: _phoneController.text,
                          address: _addressController.text,
                          city: _cityController.text,
                          factoryId: _selectedFactory ?? '',
                          finalQCItems: itemsPayload,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
