import 'package:flutter/material.dart';
import 'package:shree_ram_staff/widgets/custom_app_bar.dart';
import 'package:shree_ram_staff/widgets/primary_and_outlined_button.dart';
import 'package:shree_ram_staff/widgets/reusable_functions.dart'; 

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppBar(title: 'Product Master', preferredHeight: height * 0.12),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.035, vertical: height * 0.015),
        child: Column(
          children: [
            ReusableTextField(
                label: 'Name',
              hint: 'Enter Name',
              controller: _nameController,
              validator: (val) =>
              val == null || val.isEmpty ? 'Please Enter Name' : null,
            ),
            Spacer(),
            PrimaryButton(text: 'Submit', onPressed: (){})
          ],
        ),
      ),
    );
  }
}
