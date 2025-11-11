import 'package:flutter/material.dart';
import 'package:shree_ram_staff/utils/app_colors.dart';
import 'package:shree_ram_staff/utils/flutter_font_styles.dart';
import 'package:shree_ram_staff/widgets/reusable_appbar.dart';
import 'package:shree_ram_staff/widgets/reusable_functions.dart';
import 'package:shree_ram_staff/Constants/app_dimensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Bloc/BillingBloc/billing_bloc.dart';
import '../../../Utils/app_routes.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/primary_and_outlined_button.dart';
import '../../../widgets/custom_snackbar.dart';

class BillingFillDetailsScreen extends StatefulWidget {
  final dynamic billingData;
  const BillingFillDetailsScreen({super.key, this.billingData});

  @override
  State<BillingFillDetailsScreen> createState() =>
      _BillingFillDetailsScreenState();
}

class _BillingFillDetailsScreenState extends State<BillingFillDetailsScreen> {
  final TextEditingController finalWeightController = TextEditingController();
  final TextEditingController laborChargeController = TextEditingController();
  final TextEditingController brokerageController = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();

  late final dynamic currentBillingData;
  bool isButtonLoading = false;
  final List<Map<String, dynamic>> qcEntries = [];
  final List<Map<String, dynamic>> deductions = [];

  List<String> availableQcTypes = [];
  List<Map<String, dynamic>> allQcList = [];

  bool showSavedCard = false;
  double totalAmount = 0;

  @override
  void initState() {
    super.initState();
    currentBillingData = widget.billingData;

    allQcList = [
      ...?currentBillingData['paddyQC'],
      ...?currentBillingData['riceQC']
    ];

    availableQcTypes =
        allQcList.map((qc) => qc['type'].toString()).toSet().toList();

    finalWeightController.text =
        currentBillingData?['finalweight']?.toString() ?? '';

    laborChargeController.text =
        currentBillingData?['laborCharge']?.toString() ?? '';
    brokerageController.text =
        currentBillingData?['brokerage']?.toString() ?? '';

    // Add listeners for deduction updates
    laborChargeController.addListener(_updateTotalAmount);
    brokerageController.addListener(_updateTotalAmount);

    _addQcEntry();
  }

  // --- Add new QC entry
  void _addQcEntry() {
    if (availableQcTypes.isEmpty) return;
    setState(() {
      qcEntries.add({
        'type': null,
        'bagsController': TextEditingController(),
        'weightController': TextEditingController(),
        'priceController': TextEditingController(),
        'amountController': TextEditingController(),
      });
    });
  }

  void _removeQcEntry(int index) {
    setState(() {
      final removedType = qcEntries[index]['type'];
      if (removedType != null && !availableQcTypes.contains(removedType)) {
        availableQcTypes.add(removedType);
      }
      qcEntries.removeAt(index);
    });
  }

  void _updateAmount(int index) {
    final entry = qcEntries[index];
    final weightStr = entry['weightController'].text;
    final priceStr = entry['priceController'].text;

    final weightValue =
        double.tryParse(weightStr.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
    final priceValue = double.tryParse(priceStr) ?? 0;

    final amount = weightValue * priceValue;
    entry['amountController'].text = amount.toStringAsFixed(2);
  }

  void _onSavePressed() {
    bool allFilled = true;
    double total = 0;

    for (var entry in qcEntries) {
      if (entry['type'] == null ||
          entry['bagsController'].text.isEmpty ||
          entry['weightController'].text.isEmpty ||
          entry['priceController'].text.isEmpty ||
          entry['amountController'].text.isEmpty) {
        allFilled = false;
        break;
      }
      total += double.tryParse(entry['amountController'].text) ?? 0;
    }

    if (!allFilled) {
      CustomSnackBar.show(
        context,
        message: 'Please fill all QC details before saving.',
        isError: true,
      );
      return;
    }

    setState(() {
      showSavedCard = true;
      totalAmount = total;
      _updateTotalAmount();
    });
  }

  void _updateTotalAmount() {
    double deductionTotal = 0;

    deductionTotal += double.tryParse(laborChargeController.text) ?? 0;
    deductionTotal += double.tryParse(brokerageController.text) ?? 0;

    for (var d in deductions) {
      deductionTotal += double.tryParse(d['controller'].text) ?? 0;
    }

    final finalTotal = totalAmount - deductionTotal;
    totalAmountController.text = finalTotal.toStringAsFixed(2);
  }

  void _addDeductionField() {
    final controller = TextEditingController();
    controller.addListener(_updateTotalAmount);
    setState(() {
      deductions.add({
        'label': 'Deduction ${deductions.length + 1}',
        'controller': controller,
      });
    });
  }

  void _removeDeduction(int index) {
    setState(() {
      deductions.removeAt(index);
      _updateTotalAmount();
    });
  }

  @override
  void dispose() {
    laborChargeController.dispose();
    brokerageController.dispose();
    totalAmountController.dispose();
    for (var e in qcEntries) {
      e.values.whereType<TextEditingController>().forEach((c) => c.dispose());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: const ReusableAppBar(title: 'Billing Details'),
        body: BlocListener<BillingBloc, BillingState>(
          listener: (context, state) {
            if (state is BillingGenerateLoadingState) {
              setState(() {
                isButtonLoading = true;
              });
            } else {
              setState(() {
                isButtonLoading = false;
              });
            }

            if (state is BillingGenerateSuccessState) {
              CustomSnackBar.show(
                context,
                message: 'Billing generated successfully!',
                isError: false,
              );
              Navigator.pop(context, true);
              // Navigator.pushNamed(context, AppRoutes.billingDetailScreenSuperUser, arguments: state.billingData);
            }

            if (state is BillingGenerateErrorState) {
              CustomSnackBar.show(
                context,
                message: state.message,
                isError: true,
              );
            }
          },
  child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.035,
            vertical: height * 0.015,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileRow(label: 'Unit ID', value: currentBillingData['transportId']?['purchaseId']?['_id']?.toString() ?? '-'),
              ProfileRow(label: 'Name', value: currentBillingData['transportId']?['purchaseId']?['name'] ?? '-'),
              ProfileRow(label: 'Broker', value: currentBillingData['transportId']?['brokerId']?['name'] ?? '-'),
              ProfileRow(
                  label: 'Initial Weight',
                  value: '${currentBillingData['transportId']['weight'] ?? '-'}'),
              ProfileRow(
                  label: 'Final Weight',
                  value: '${currentBillingData['finalweight'] ?? '-'}'),

              AppDimensions.h20(context),

              Text('Enter Billing Details', style: AppTextStyles.appbarTitle),
              AppDimensions.h10(context),

              ..._buildQcEntries(),

              if (availableQcTypes.isNotEmpty)
                InkWell(
                  onTap: _addQcEntry,
                  child: Text('+ Add another type',
                      style: AppTextStyles.underlineText),
                ),
              AppDimensions.h20(context),

              ReusableOutlinedButton(text: 'Save', onPressed: _onSavePressed),

              if (showSavedCard) _buildSavedCard(),

              AppDimensions.h20(context),
              Text('Extra Charges to be deduct',
                  style: AppTextStyles.appbarTitle),
              AppDimensions.h10(context),

              Text('Labor Charge', style: AppTextStyles.label),
              CustomTextFormField(
                controller: laborChargeController,
                hintText: 'Labor Charge',
                isReadOnly:
                laborChargeController.text.isNotEmpty ? true : false,
                keyboardType: TextInputType.number,
              ),

              AppDimensions.h10(context),
              Text('Brokerage', style: AppTextStyles.label),
              CustomTextFormField(
                controller: brokerageController,
                hintText: 'Brokerage',
                isReadOnly:
                brokerageController.text.isNotEmpty ? true : false,
                keyboardType: TextInputType.number,
              ),

              ..._buildDynamicDeductions(),
              InkWell(
                onTap: _addDeductionField,
                child: Text('+ Add another deduction',
                    style: AppTextStyles.underlineText),
              ),

              AppDimensions.h20(context),
              Text('Total Amount', style: AppTextStyles.label),
              CustomTextFormField(
                controller: totalAmountController,
                hintText: 'Total Amount',
                isReadOnly: true,
              ),

              AppDimensions.h30(context),
              PrimaryButton(
                text: 'Submit',
                isLoading: isButtonLoading,
                onPressed: () {
                  // 1️⃣ Check if QC card is saved
                  if (!showSavedCard) {
                    CustomSnackBar.show(
                      context,
                      message: 'Please save QC details before submitting.',
                      isError: true,
                    );
                    return;
                  }

                  // 2️⃣ Validate each QC entry
                  bool allFilled = true;
                  for (var entry in qcEntries) {
                    if (entry['type'] == null ||
                        entry['bagsController'].text.isEmpty ||
                        entry['weightController'].text.isEmpty ||
                        entry['priceController'].text.isEmpty ||
                        entry['amountController'].text.isEmpty) {
                      allFilled = false;
                      break;
                    }
                  }

                  if (!allFilled) {
                    CustomSnackBar.show(
                      context,
                      message: 'Please complete all QC details — some fields are missing or not saved.',
                      isError: true,
                    );
                    return;
                  }

                  // 3️⃣ Check if any QC type is left unsaved (for Paddy/Rice, etc.)
                  final unsavedTypes = allQcList
                      .map((e) => e['type'].toString())
                      .where((type) => !qcEntries.any((q) => q['type'] == type))
                      .toList();

                  if (unsavedTypes.isNotEmpty) {
                    CustomSnackBar.show(
                      context,
                      message: 'Some QC types (${unsavedTypes.join(', ')}) are not filled or saved.',
                      isError: true,
                    );
                    return;
                  }

                  // 4️⃣ Check total amount validity
                  if (totalAmountController.text.isEmpty ||
                      double.tryParse(totalAmountController.text) == null) {
                    CustomSnackBar.show(
                      context,
                      message: 'Invalid total amount. Please check entered values.',
                      isError: true,
                    );
                    return;
                  }

                  // 5️⃣ Build billingItems list safely
                  final billingItems = qcEntries.map((entry) {
                    return {
                      "itemName": entry['type'] ?? '',
                      "weight": entry['weightController'].text,
                      "bags": int.tryParse(entry['bagsController'].text) ?? 0,
                      "price": double.tryParse(entry['priceController'].text) ?? 0,
                      "amount": double.tryParse(entry['amountController'].text) ?? 0,
                    };
                  }).toList();

                  // 6️⃣ Build deductions object safely (renamed to `deductionList`)
                  final deductionList = [
                    {
                      "labourcharge": double.tryParse(laborChargeController.text) ?? 0,
                      "brokerage": double.tryParse(brokerageController.text) ?? 0,
                      "enteramount": this.deductions.fold<double>(
                        0,
                            (sum, d) => sum + (double.tryParse(d['controller'].text) ?? 0),
                      ),
                    }
                  ];

                  // 7️⃣ Ensure we have valid QC ID
                  final finalQCId = currentBillingData['_id']?.toString() ?? '';
                  if (finalQCId.isEmpty) {
                    CustomSnackBar.show(
                      context,
                      message: 'Missing QC ID. Cannot generate billing.',
                      isError: true,
                    );
                    return;
                  }

                  // 8️⃣ Dispatch Bloc event
                  context.read<BillingBloc>().add(
                    GenerateBillingEvent(
                      finalQCId: finalQCId,
                      billingItems: billingItems,
                      deductions: deductionList,
                    ),
                  );

                  CustomSnackBar.show(
                    context,
                    message: 'Billing generation initiated!',
                    isError: false,
                  );
                },

              ),

            ],
          ),
        ),
),
      ),
    );
  }

  List<Widget> _buildQcEntries() {
    return qcEntries.asMap().entries.map((entry) {
      final index = entry.key;
      final qc = entry.value;

      // Add listener for price updates
      qc['priceController'].addListener(() => _updateAmount(index));

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Type ${index + 1}', style: AppTextStyles.label),
                if (qcEntries.length > 1)
                  IconButton(
                    onPressed: () => _removeQcEntry(index),
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                  ),
              ],
            ),
            _buildDropdown(
              selectedValue: qc['type'],
              onChanged: (val) {
                setState(() {
                  qc['type'] = val;
                  availableQcTypes.remove(val);

                  final qcData = allQcList
                      .firstWhere((q) => q['type'].toString() == val);

                  qc['bagsController'].text =
                      qcData['bags']?.toString() ?? '';
                  qc['weightController'].text =
                      qcData['weight']?.toString() ?? '';
                });
              },
            ),
            AppDimensions.h10(context),
            Text('Bags', style: AppTextStyles.label),
            CustomTextFormField(
              controller: qc['bagsController'],
              hintText: 'Bags',
              isReadOnly: qc['bagsController'].text.isNotEmpty,
            ),
            AppDimensions.h10(context),
            Text('Weight', style: AppTextStyles.label),
            CustomTextFormField(
              controller: qc['weightController'],
              hintText: 'Weight',
              isReadOnly: qc['weightController'].text.isNotEmpty,
            ),
            AppDimensions.h10(context),
            Text('Price', style: AppTextStyles.label),
            CustomTextFormField(
              controller: qc['priceController'],
              hintText: 'Enter Price',
              keyboardType: TextInputType.number,
            ),
            AppDimensions.h10(context),
            Text('Amount', style: AppTextStyles.label),
            CustomTextFormField(
              controller: qc['amountController'],
              hintText: 'Auto calculated amount',
              isReadOnly: true,
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildDropdown({
    String? selectedValue,
    required ValueChanged<String?> onChanged,
  }) {
    final List<String> options = selectedValue != null
        ? [selectedValue, ...availableQcTypes]
        : availableQcTypes;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          icon: const Icon(Icons.keyboard_arrow_down_outlined),
          value: selectedValue,
          hint: Text('Select QC Type', style: AppTextStyles.hintText),
          items: options
              .map(
                (type) => DropdownMenuItem<String>(
              value: type,
              child: Text(type, style: AppTextStyles.hintText),
            ),
          )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildSavedCard() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: qcEntries.map((e) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoRow('Type', e['type']?.toString() ?? ''),
                    Text(formatAmount(e['amountController']?.text ?? 0), style: AppTextStyles.cardHeading,)
                  ],
                ),
                _buildInfoRow('Bags', e['bagsController']?.text ?? ''),
                _buildInfoRow('Weight', e['weightController']?.text ?? ''),
                _buildInfoRow('Price', e['priceController']?.text ?? ''),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.15,
            child: Text(
              '$label:',
              style: AppTextStyles.bodyText,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.15,
            child: Text(
              value.isNotEmpty ? value : '-',
              style: AppTextStyles.cardText,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDynamicDeductions() {
    return deductions.asMap().entries.map((entry) {
      final index = entry.key;
      final deduction = entry.value;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: CustomTextFormField(
                hintText: deduction['label'],
                controller: deduction['controller'],
              ),
            ),
            AppDimensions.w10(context),
            IconButton(
              icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
              onPressed: () => _removeDeduction(index),
            ),
          ],
        ),
      );
    }).toList();
  }
}
