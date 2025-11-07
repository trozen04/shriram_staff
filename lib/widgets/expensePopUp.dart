import 'package:flutter/material.dart';
import 'package:shree_ram_staff/Constants/app_dimensions.dart';
import 'package:shree_ram_staff/utils/app_colors.dart';
import 'package:shree_ram_staff/utils/flutter_font_styles.dart';
import 'package:shree_ram_staff/utils/image_assets.dart';
import 'package:shree_ram_staff/widgets/primary_and_outlined_button.dart';
import 'package:shree_ram_staff/widgets/reusable_functions.dart';

class ExpensePopup extends StatefulWidget {
  final void Function(String amount, String reason)? onSubmit;

  const ExpensePopup({Key? key, this.onSubmit}) : super(key: key);

  @override
  State<ExpensePopup> createState() => _ExpensePopupState();
}

class _ExpensePopupState extends State<ExpensePopup> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _amountController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: EdgeInsets.symmetric(
        horizontal: width * 0.06,
        vertical: height * 0.03,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.06,
          vertical: height * 0.03,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(ImageAssets.expense, height: height * 0.08),
                AppDimensions.h20(context),
                Align(
                  alignment: AlignmentGeometry.centerLeft,
                  child: Text(
                    'Enter Expense',
                    style: AppTextStyles.appbarTitle,
                    textAlign: TextAlign.left,
                  ),
                ),
                AppDimensions.h20(context),

                ReusableTextField(
                  label: 'Amount',
                  hint: 'Enter Amount',
                  controller: _amountController,
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Please enter amount' : null,
                  keyboardType: TextInputType.number,
                ),
                AppDimensions.h10(context),

                ReusableTextField(
                  label: 'Reason',
                  hint: 'Enter Reason',
                  controller: _reasonController,
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Please enter reason' : null,
                ),

                AppDimensions.h20(context),

                // Submit Button
                PrimaryButton(
                  text: 'Submit',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onSubmit?.call(
                        _amountController.text,
                        _reasonController.text,
                      );
                      Navigator.pop(context);
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
