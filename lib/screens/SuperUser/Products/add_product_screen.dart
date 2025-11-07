import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shree_ram_staff/Constants/app_dimensions.dart';
import 'package:shree_ram_staff/widgets/custom_app_bar.dart';
import 'package:shree_ram_staff/widgets/primary_and_outlined_button.dart';
import '../../../Bloc/QCBloc/qc_bloc.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../Bloc/ProductBloc/product_bloc.dart';
import '../../../utils/flutter_font_styles.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isSubmitting = false;
  bool isLoading = false;

  String? selectedQcId;
  List<Map<String, String>> qcItems = [];

  @override
  void initState() {
    super.initState();
    context.read<QcBloc>().add(getFinalQcEventHandler(page: 1, limit: 20));
  }

  void _submitProduct() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSubmitting = true);

    context.read<ProductBloc>().add(
      CreateProductEvent(name: selectedQcId!),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return MultiBlocListener(
      listeners: [
        BlocListener<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state is ProductCreateSuccessState) {
              setState(() => isSubmitting = false);
              CustomSnackBar.show(context, message: 'Product created successfully!');
              Navigator.pop(context, true);
            }
            if (state is ProductErrorState) {
              setState(() => isSubmitting = false);
              CustomSnackBar.show(context, message: state.message, isError: true);
            }
          },
        ),
        BlocListener<QcBloc, QcState>(
          listener: (context, state) {
            if (state is getFinalQcLoadingState) {
              setState(() => isLoading = true);
            } else if (state is getFinalQcSuccessState) {
              developer.log('QC Data: ${state.responseData}');
              setState(() {
                isLoading = false;

                final data = state.responseData['data'] as List<dynamic>? ?? [];
                final Set<String> typeSet = {};
                final List<Map<String, String>> items = [];

                for (var item in data) {
                  final paddyQC = item['paddyQC'] as List<dynamic>? ?? [];
                  final riceQC = item['riceQC'] as List<dynamic>? ?? [];

                  for (var qc in [...paddyQC, ...riceQC]) {
                    final typeName = qc['type']?.toString() ?? '';
                    final id = qc['_id']?.toString() ?? '';
                    if (typeName.isNotEmpty && !typeSet.contains(typeName)) {
                      typeSet.add(typeName);
                      items.add({'id': id, 'name': typeName});
                    }
                  }
                }

                qcItems = items;
              });
            } else if (state is getFinalQcErrorState) {
              setState(() => isLoading = false);
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Add Product',
          preferredHeight: height * 0.12,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.035, vertical: height * 0.015),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                isLoading
                    ? const CircularProgressIndicator()
                    : DropdownButtonFormField<String>(
                  value: selectedQcId,
                  decoration: InputDecoration(
                    labelText: 'Select Product Type',
                    labelStyle: AppTextStyles.bodyText,
                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: height * 0.01),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.grey, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.grey, width: 1),
                    ),
                  ),
                  style: AppTextStyles.bodyText,
                  items: qcItems
                      .map((e) => DropdownMenuItem<String>(
                    value: e['id'],
                    child: Text(e['name'] ?? '-', style: AppTextStyles.hintText),
                  ))
                      .toList(),
                  onChanged: (val) => setState(() => selectedQcId = val),
                  validator: (val) => val == null || val.isEmpty ? 'Please select a product' : null,
                ),
                const Spacer(),
                PrimaryButton(
                  text: 'Submit',
                  onPressed: isSubmitting ? null : _submitProduct,
                  isLoading: isSubmitting,
                ),
                AppDimensions.h30(context)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
