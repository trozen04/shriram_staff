import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shree_ram_staff/widgets/primary_and_outlined_button.dart';
import 'package:shree_ram_staff/widgets/reusable_appbar.dart';
import '../../../Bloc/BillingBloc/billing_bloc.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../Utils/app_routes.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/flutter_font_styles.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../widgets/reusable_functions.dart';

class BillingFillDetailsSuperUser extends StatefulWidget {
  final dynamic billingData;
  const BillingFillDetailsSuperUser({super.key, required this.billingData});

  @override
  State<BillingFillDetailsSuperUser> createState() =>
      _BillingFillDetailsSuperUserState();
}

class _BillingFillDetailsSuperUserState
    extends State<BillingFillDetailsSuperUser> {
  // -----------------------------------------------------------------
  //  UI state
  // -----------------------------------------------------------------
  List<Map<String, dynamic>> billingItems = [
    {'itemId': '', 'itemName': '', 'weight': '', 'bags': '', 'price': '', 'amount': ''}
  ];
  bool isButtonLoading = false;
  List<Map<String, dynamic>> savedSummaryList = [];
  List<Map<String, dynamic>> deductions = [];

  final TextEditingController totalAmountController = TextEditingController();

  // Controllers
  List<TextEditingController> weightControllers = [];
  List<TextEditingController> bagsControllers = [];
  List<TextEditingController> priceControllers = [];
  List<TextEditingController> amountControllers = [];

  // -----------------------------------------------------------------
  //  Data prepared from API
  // -----------------------------------------------------------------
  // Each entry:  { id: <QC _id>, name: <type>, data: <full QC map> }
  List<Map<String, dynamic>> allQcItems = [];
  // Set of used QC _id s (to avoid duplicate selection)
  Set<String> usedQcIds = {};

  // -----------------------------------------------------------------
  //  Lifecycle
  // -----------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _initControllers();
    _prepareQcItems();
    _initDeductions();
    _updateTotalAmount();
  }

  void _initControllers() {
    weightControllers = billingItems.map((e) => TextEditingController()).toList();
    bagsControllers   = billingItems.map((e) => TextEditingController()).toList();
    priceControllers  = billingItems.map((e) => TextEditingController()).toList();
    amountControllers = billingItems.map((e) => TextEditingController()).toList();

    for (int i = 0; i < billingItems.length; i++) {
      weightControllers[i].addListener(() => _updateAmount(i));
      priceControllers[i].addListener(() => _updateAmount(i));
    }
  }

// ----- Inside _prepareQcItems() -----
  void _prepareQcItems() {
    final List<dynamic> paddyQC = widget.billingData['paddyQC'] ?? [];
    final List<dynamic> riceQC  = widget.billingData['riceQC']  ?? [];

    final Set<String> addedIds = {};

    void addQc(Map<String, dynamic> qc) {
      final id   = qc['_id']?.toString() ?? '';
      final name = qc['type']?.toString() ?? '';
      if (id.isNotEmpty && name.isNotEmpty && !addedIds.contains(id)) {
        addedIds.add(id);
        allQcItems.add({'id': id, 'name': name, 'data': qc});
      }
    }

    // Fixed forEach
    for (var qc in paddyQC) addQc(qc as Map<String, dynamic>);
    for (var qc in riceQC)  addQc(qc as Map<String, dynamic>);
  }

  void _initDeductions() {
    deductions = [
      {'label': 'Labour Charge', 'value': '', 'readOnly': false},
      {'label': 'Brokerage',      'value': '', 'readOnly': false},
      {'label': 'Other Charges',  'value': '', 'readOnly': false},
    ];
  }

  // -----------------------------------------------------------------
  //  Calculations
  // -----------------------------------------------------------------
  void _updateAmount(int index) {
    final weight = double.tryParse(weightControllers[index].text) ?? 0;
    final price  = double.tryParse(priceControllers[index].text)  ?? 0;
    final amount = weight * price;
    amountControllers[index].text = amount.toStringAsFixed(2);
    _updateTotalAmount();
  }

// ----- Inside _updateTotalAmount() -----
  void _updateTotalAmount() {
    double total = savedSummaryList.fold<double>(
      0.0,
          (double sum, item) => sum + ((item['amount'] as num?)?.toDouble() ?? 0.0),
    );

    for (var d in deductions) {
      total -= double.tryParse(d['value']?.toString() ?? '0') ?? 0;
    }
    totalAmountController.text = total.toStringAsFixed(2);
  }

  // -----------------------------------------------------------------
  //  Billing item management
  // -----------------------------------------------------------------
  void _addBillingItem() {
    setState(() {
      billingItems.add(
          {'itemId': '', 'itemName': '', 'weight': '', 'bags': '', 'price': '', 'amount': ''});
      final idx = billingItems.length - 1;
      weightControllers.add(TextEditingController()
        ..addListener(() => _updateAmount(idx)));
      bagsControllers.add(TextEditingController());
      priceControllers.add(TextEditingController()
        ..addListener(() => _updateAmount(idx)));
      amountControllers.add(TextEditingController());
    });
  }

  void _removeBillingItem(int index) {
    setState(() {
      final id = billingItems[index]['itemId']?.toString() ?? '';
      if (id.isNotEmpty) usedQcIds.remove(id);
      billingItems.removeAt(index);
      weightControllers.removeAt(index);
      bagsControllers.removeAt(index);
      priceControllers.removeAt(index);
      amountControllers.removeAt(index);
    });
  }

  void _saveBillingItem(int index) {
    final map = billingItems[index];
    final id  = map['itemId']?.toString() ?? '';
    final name  = map['itemName']?.toString() ?? '';
    final weight = double.tryParse(weightControllers[index].text) ?? 0;
    final bags   = bagsControllers[index].text.trim();
    final price  = double.tryParse(priceControllers[index].text) ?? 0;
    final amount = weight * price;

    if (id.isEmpty || name.isEmpty) {
      _showSnackBar('Please select an item');
      return;
    }
    if (weight <= 0) {
      _showSnackBar('Enter a valid weight for $name');
      return;
    }
    if (price <= 0) {
      _showSnackBar('Enter a valid price for $name');
      return;
    }

    setState(() {
      savedSummaryList.add({
        'item': name,
        'weight': weight,
        'bags': bags.isEmpty ? '-' : bags,
        'price': price,
        'amount': amount,
      });
      usedQcIds.add(id);

      // reset row
      billingItems[index] = {
        'itemId': '',
        'itemName': '',
        'weight': '',
        'bags': '',
        'price': '',
        'amount': ''
      };
      weightControllers[index].clear();
      bagsControllers[index].clear();
      priceControllers[index].clear();
      amountControllers[index].clear();

      _updateTotalAmount();
    });
  }

  void _showSnackBar(String msg) {
    CustomSnackBar.show(context, message: msg, isError: true);
  }

  // -----------------------------------------------------------------
  //  UI
  // -----------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width  = MediaQuery.of(context).size.width;
    final billing = widget.billingData;
    final finalQC = billing['finalQCId'] ?? {};
    final transport = billing['transportId'] ?? {};
    final farmer = transport['purchaseId'] ?? {};
    final broker = transport['brokerId'] ?? {};


    final String unitId = billing['_id']?.toString() ?? '-';
    final String factoryName = transport['factory']?.toString() ?? '-';
    final String transportMode = transport['transportmode']?.toString() ?? '-';
    final String vehicleNo = transport['vehicleno']?.toString() ?? '-';
    final String driverName = transport['drivername']?.toString() ?? '-';
    final String farmerName = farmer['name']?.toString() ?? '-';
    final String brokerName = broker['name']?.toString() ?? '-';
    final String brokerMobile = broker['mobileno']?.toString() ?? '-';
    final String deliveryDate = transport['deliverydate']?.toString() ?? '-';
    final String initialWeight = billing['initialweight']?.toString() ?? '-';
    final String finalWeight = billing['finalweight']?.toString() ?? '-';
    final String billingStatus = billing['billing']?.toString() ?? '-';

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: ReusableAppBar(title: '#$unitId'),
        body: BlocListener<BillingBloc, BillingState>(
          listener: (context, state) {
            if (state is BillingGenerateLoadingState) {
              setState(() => isButtonLoading = true);
            } else if (state is BillingGenerateSuccessState) {
              setState(() => isButtonLoading = false);
              CustomSnackBar.show(context,
                  message: 'Bill generated successfully', isError: false);
              Navigator.pushNamed(
                context,
                AppRoutes.billingDetailScreenSuperUser,
                arguments: state.billingData
              );
            } else if (state is BillingGenerateErrorState) {
              setState(() => isButtonLoading = false);
              CustomSnackBar.show(context,
                  message: state.message, isError: true);
            }
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.035, vertical: height * 0.015),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileRow(label: 'Unit ID', value: '#$unitId'),
                ProfileRow(label: 'Farmer', value: farmerName),
                ProfileRow(label: 'Broker', value: brokerName),
                ProfileRow(label: 'Initial Weight', value: '$initialWeight'),
                ProfileRow(label: 'Net Weight', value: '$finalWeight'),
                AppDimensions.h10(context),
                Text('Enter Billing Details', style: AppTextStyles.appbarTitle),
                AppDimensions.h10(context),

                // ----- Billing rows -----
                ..._buildBillingItems(),

                AppDimensions.h20(context),
                ReusableOutlinedButton(
                  text: 'Save',
                  onPressed: () {
                    for (int i = 0; i < billingItems.length; i++) {
                      _saveBillingItem(i);
                    }
                  },
                ),
                AppDimensions.h20(context),

                // ----- Saved summary -----
                if (savedSummaryList.isNotEmpty)
                  ...savedSummaryList.map((data) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildSummaryCard(data, height, width),
                  )),

                AppDimensions.h20(context),
                Text('Extra Charges', style: AppTextStyles.appbarTitle),
                AppDimensions.h10(context),
                ..._buildDeductionFields(),
                AppDimensions.h20(context),

                ReusableTextField(
                  label: 'Total Amount',
                  hint: 'Total Amount',
                  controller: totalAmountController,
                  readOnly: true,
                ),
                AppDimensions.h30(context),

                PrimaryButton(
                  text: 'Submit',
                  isLoading: isButtonLoading,
                  onPressed: _onSubmitPressed,
                ),
                AppDimensions.h20(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -----------------------------------------------------------------
  //  Billing row builder
  // -----------------------------------------------------------------
  List<Widget> _buildBillingItems() {
    return List.generate(billingItems.length, (index) {
      final map = billingItems[index];
      final currentId = map['itemId']?.toString() ?? '';

      // Available QC items (exclude already used ones, keep current)
      final available = allQcItems
          .where((e) => !usedQcIds.contains(e['id']) || e['id'] == currentId)
          .toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------- ITEM DROPDOWN (FULL BORDER) ----------
          DropdownButtonFormField<String>(
            value: currentId.isEmpty ? null : currentId,
            decoration: InputDecoration(
              labelText: 'Item Name',
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
            ),
            items: available
                .map((e) => DropdownMenuItem<String>(
              value: e['id'] as String,
              child: Text(e['name'] as String),
            ))
                .toList(),
            onChanged: (String? newId) {
              if (newId == null) return;
              final qc = allQcItems.firstWhere((e) => e['id'] == newId);
              final data = qc['data'] as Map<String, dynamic>;

              setState(() {
                billingItems[index]['itemId']   = newId;
                billingItems[index]['itemName'] = qc['name'];

                // Prefill bags & weight
                bagsControllers[index].text =
                    data['bags']?.toString() ?? '';
                weightControllers[index].text =
                    (data['weight']?.toString() ?? '').replaceAll('qtl', '').trim();

                // Re-calculate used IDs
                usedQcIds = billingItems
                    .where((m) => (m['itemId']?.toString() ?? '').isNotEmpty)
                    .map((m) => m['itemId'].toString())
                    .toSet();

                _updateAmount(index);
              });
            },
          ),

          AppDimensions.h10(context),

          // ---------- WEIGHT ----------
          ReusableTextField(
            label: 'Weight',
            hint: 'Enter Weight',
            controller: weightControllers[index],
            keyboardType: TextInputType.number,
            onChanged: (_) => _updateAmount(index),
          ),

          AppDimensions.h10(context),

          // ---------- BAGS (READ-ONLY) ----------
          ReusableTextField(
            label: 'Bags',
            hint: 'Bags',
            controller: bagsControllers[index],
            readOnly: true,
          ),

          AppDimensions.h10(context),

          // ---------- PRICE ----------
          ReusableTextField(
            label: 'Price',
            hint: 'Enter Price',
            controller: priceControllers[index],
            keyboardType: TextInputType.number,
            onChanged: (_) => _updateAmount(index),
          ),

          AppDimensions.h10(context),

          // ---------- AMOUNT (AUTO) ----------
          ReusableTextField(
            label: 'Amount',
            hint: 'Amount',
            controller: amountControllers[index],
            readOnly: true,
          ),

          AppDimensions.h10(context),

          // ---------- ADD / REMOVE ----------
          if (index == 0)
            GestureDetector(
              onTap: _addBillingItem,
              child: Text('+ Add another item',
                  style: AppTextStyles.underlineText),
            )
          else
            GestureDetector(
              onTap: () => _removeBillingItem(index),
              child: Text('- Remove item',
                  style: AppTextStyles.underlineText
                      .copyWith(color: Colors.red)),
            ),

          AppDimensions.h20(context),
        ],
      );
    });
  }

  // -----------------------------------------------------------------
  //  Summary card
  // -----------------------------------------------------------------
  Widget _buildSummaryCard(Map<String, dynamic> data, double h, double w) {
    return Container(
      padding:
      EdgeInsets.symmetric(horizontal: w * 0.035, vertical: h * 0.015),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Item: ${data['item']}', style: AppTextStyles.bodyText),
              Text('₹ ${data['amount']}', style: AppTextStyles.bodyText),
            ],
          ),
          AppDimensions.h10(context),
          Text('Weight: ${data['weight']}', style: AppTextStyles.bodyText),
          AppDimensions.h10(context),
          Text('Bags: ${data['bags']}', style: AppTextStyles.bodyText),
          AppDimensions.h10(context),
          Text('Price: ₹ ${data['price']}', style: AppTextStyles.bodyText),
        ],
      ),
    );
  }

  // -----------------------------------------------------------------
  //  Deduction fields
  // -----------------------------------------------------------------
  List<Widget> _buildDeductionFields() {
    return List.generate(deductions.length, (i) {
      final d = deductions[i];
      final ctrl = TextEditingController(text: d['value']?.toString() ?? '');
      ctrl.addListener(() {
        deductions[i]['value'] = ctrl.text;
        _updateTotalAmount();
      });
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: ReusableTextField(
          label: d['label'] ?? '',
          hint: d['label'] ?? '',
          controller: ctrl,
          readOnly: d['readOnly'] == true,
          keyboardType: TextInputType.number,
        ),
      );
    });
  }

  // -----------------------------------------------------------------
  //  Submit
  // -----------------------------------------------------------------
  void _onSubmitPressed() {
    if (savedSummaryList.isEmpty) {
      _showSnackBar('Please save at least one billing item');
      return;
    }

    final billingItemsPayload = savedSummaryList.map((item) => {
      'itemName': item['item'],
      'weight': item['weight'],
      'bags':
      int.tryParse(item['bags']?.toString().replaceAll('-', '0') ?? '0') ?? 0,
      'price': item['price'],
      'amount': item['amount'],
    }).toList();

    double labour = 0, brokerage = 0, other = 0;
    for (var d in deductions) {
      final v = double.tryParse(d['value']?.toString() ?? '0') ?? 0;
      switch (d['label']) {
        case 'Labour Charge':
          labour = v;
          break;
        case 'Brokerage':
          brokerage = v;
          break;
        default:
          other += v;
      }
    }

    final deductionsPayload = [
      {
        'labourcharge': labour,
        'brokerage': brokerage,
        'enteramount': other,
      }
    ];

    final finalQCId = widget.billingData['_id'];
    context.read<BillingBloc>().add(GenerateBillingEvent(
      finalQCId: finalQCId,
      billingItems: billingItemsPayload,
      deductions: deductionsPayload,
    ));
  }
}