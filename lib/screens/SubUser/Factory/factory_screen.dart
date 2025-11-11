import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shree_ram_staff/widgets/custom_app_bar.dart';
import 'package:intl/intl.dart';
import '../../../Bloc/FactoryBloc/factory_bloc.dart';
import '../../../Bloc/ProductBloc/product_bloc.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../Utils/image_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/flutter_font_styles.dart';
import '../../../widgets/reusable_functions.dart';
import '../../../widgets/custom_snackbar.dart';

class FactoryScreen extends StatefulWidget {
  const FactoryScreen({super.key});

  @override
  State<FactoryScreen> createState() => _FactoryScreenState();
}

class _FactoryScreenState extends State<FactoryScreen> {
  DateTimeRange? selectedDateRange;
  List<Map<String, dynamic>> items = [
    {'item': null, 'quantity': '', 'bags': '', 'quintal': ''}
  ];

  bool isSaving = false;
  List<dynamic> productList = [];
  List<Map<String, dynamic>> savedItems = []; // ← holds saved inventory from API

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(GetAllProductEventHandler());
  }

  void _pickDate() async {
    final DateTimeRange? picked = await pickDateRange(
      context: context,
      initialRange: selectedDateRange,
    );
    if (picked != null) {
      setState(() => selectedDateRange = picked);
    }
  }

  void _addItem() {
    setState(() {
      items.add({'item': null, 'quantity': '', 'bags': '', 'quintal': ''});
    });
  }

  void _removeItem(int index) {
    setState(() => items.removeAt(index));
  }

  void _saveInventory(int index) {
    final item = items[index];

    if (item['item'] == null ||
        item['quantity']!.isEmpty ||
        item['bags']!.isEmpty ||
        item['quintal']!.isEmpty) {
      CustomSnackBar.show(context, message: 'Please fill all fields', isError: true);
      return;
    }

    final inventoryItem = {
      "item": item['item'], // send only the _id
      "quantity": int.tryParse(item['quantity']) ?? 0,
      "bags": int.tryParse(item['bags']) ?? 0,
      "quintal": item['quintal'],
    };

    developer.log("📦 Sending inventory item: $inventoryItem");

    context.read<FactoryBloc>().add(
      InsertFactoryInventoryEvent(
        inventoryData: inventoryItem, // send only one item
      ),
    );
  }

  int getTotal(String key) {
    int total = 0;
    for (var item in items) {
      final val = int.tryParse(item[key]?.toString() ?? '0') ?? 0;
      total += val;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppBar(title: 'Factory', preferredHeight: height * 0.12),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.035, vertical: height * 0.015),
          child: MultiBlocListener(
            listeners: [
              BlocListener<FactoryBloc, FactoryState>(
                listener: (context, state) {
                  if (state is FactoryLoadingState) {
                    setState(() => isSaving = true);
                  } else if (state is FactoryInventorySuccessState) {
                    setState(() {
                      isSaving = false;

                      // Map item ID to product name
                      final itemId = state.responseData['data']['item'];
                      final productName = productList
                          .firstWhere(
                            (p) => p['_id'] == itemId,
                        orElse: () => {'name': 'Unknown'},
                      )['name'] ??
                          'Unknown';

                      // Add to saved items
                      savedItems.add({
                        'id': state.responseData['data']['_id'],
                        'itemId': itemId,
                        'name': productName,
                        'quantity': state.responseData['data']['quantity'],
                        'bags': state.responseData['data']['bags'],
                        'quintal': state.responseData['data']['quintal'],
                      });
                    });

                    CustomSnackBar.show(context, message: 'Inventory saved successfully!');
                  } else if (state is FactoryErrorState) {
                    setState(() => isSaving = false);
                    CustomSnackBar.show(context, message: state.message, isError: true);
                  } else {
                    setState(() => isSaving = false);
                  }
                },
              ),
              BlocListener<ProductBloc, ProductState>(
                listener: (context, state) {
                  if (state is ProductSuccessState) {
                    setState(() => productList = state.products);
                  } else if (state is ProductErrorState) {
                    CustomSnackBar.show(context, message: state.message, isError: true);
                  }
                },
              ),
            ],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomIconButton(
                  text: formatDateRange(selectedDateRange),
                  imagePath: ImageAssets.calender,
                  width: width,
                  height: height,
                  onTap: () => _pickDate(),
                ),
                AppDimensions.h20(context),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return Container(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text('Add Item', style: AppTextStyles.label),
                                          AppDimensions.w10(context),
                                          if (index == items.length - 1)
                                            InkWell(
                                              onTap: _addItem,
                                              child: Text('Add Item', style: AppTextStyles.underlineText),
                                            ),
                                          if (index != items.length - 1)
                                            InkWell(
                                              onTap: () => _removeItem(index),
                                              child: Icon(Icons.remove_circle, color: Colors.red),
                                            ),
                                        ],
                                      ),

                                      GestureDetector(
                                        onTap: () => _saveInventory(index),
                                        child: Container(
                                          height: 30,
                                          padding: EdgeInsets.symmetric(horizontal: 12),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryColor.withAlpha((0.16 * 255).toInt()),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          alignment: Alignment.center,
                                          child: isSaving
                                              ? SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          )
                                              : Text('Save',
                                              style: AppTextStyles.dateText.copyWith(fontSize: 12)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  AppDimensions.h10(context),
                                  ReusableDropdown(
                                    items: productList.map((p) => p['name'].toString()).toList(),
                                    value: productList
                                        .firstWhere(
                                          (p) => p['_id'] == item['item'],
                                      orElse: () => null,
                                    )?['name'],
                                    onChanged: (val) {
                                      final selected = productList.firstWhere(
                                            (p) => p['name'] == val,
                                        orElse: () => null,
                                      );
                                      setState(() {
                                        item['item'] = selected != null ? selected['_id'] : null;
                                      });
                                    },
                                    validator: (val) => val == null ? 'Please select a product' : null,
                                    hintText: 'Select Product',
                                  ),
                                  AppDimensions.h10(context),
                                  ReusableTextField(
                                    label: 'Quantity',
                                    hint: 'Enter Quantity',
                                    keyboardType: TextInputType.number,
                                    onChanged: (val) => item['quantity'] = val,
                                    validator: (val) => val!.isEmpty ? 'Please enter quantity' : null,
                                  ),
                                  AppDimensions.h10(context),
                                  ReusableTextField(
                                    label: 'Bags',
                                    hint: 'Enter number of bags',
                                    keyboardType: TextInputType.number,
                                    onChanged: (val) => item['bags'] = val,
                                    validator: (val) => val!.isEmpty ? 'Please enter bags' : null,
                                  ),
                                  AppDimensions.h10(context),
                                  ReusableTextField(
                                    label: 'Quintal',
                                    hint: 'Enter Quintal',
                                    keyboardType: TextInputType.number,
                                    onChanged: (val) => item['quintal'] = val,
                                    validator: (val) => val!.isEmpty ? 'Please enter quintal' : null,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        AppDimensions.h20(context),

                        // Display all saved cards
                        Column(
                          children: savedItems.map((saved) {
                            return _buildSavedCard(saved, width, height);
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSavedCard(Map<String, dynamic> saved, double width, double height) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: width * 0.035, vertical: height * 0.015),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Item: ${saved['name']}', style: AppTextStyles.bodyText),
          AppDimensions.h10(context),
          Text('Quantity: ${saved['quantity']}', style: AppTextStyles.bodyText),
          AppDimensions.h10(context),
          Text('Bags: ${saved['bags']}', style: AppTextStyles.bodyText),
          AppDimensions.h10(context),
          Text('Quintal: ${saved['quintal']}', style: AppTextStyles.bodyText),
        ],
      ),
    );
  }
}
