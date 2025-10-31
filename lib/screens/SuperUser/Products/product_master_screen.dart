import 'package:flutter/material.dart';
import 'package:shree_ram_staff/Constants/app_dimensions.dart';
import 'package:shree_ram_staff/utils/app_routes.dart';
import 'package:shree_ram_staff/widgets/custom_app_bar.dart';

import '../../../widgets/reusable_functions.dart';

class ProductMasterScreen extends StatefulWidget {
  const ProductMasterScreen({super.key});

  @override
  State<ProductMasterScreen> createState() => _ProductMasterScreenState();
}

class _ProductMasterScreenState extends State<ProductMasterScreen> {
  TextEditingController searchController = TextEditingController();
  dynamic productData = [
    {'paddyName': 'Paddy A'},
    {'paddyName': 'Paddy B'},
    {'paddyName': 'Paddy C'},
    {'paddyName': 'Paddy D'},
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
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
                  hintText: 'Search by Product',
                  onChanged: (value) {
                    // handle search logic
                  },
                ),
                AppDimensions.h20(context),
                Expanded(
                  child: ListView.builder(
                    itemCount: productData.length,
                    itemBuilder: (context, index) {
                      dynamic product = productData[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(product['paddyName']),
                      );
                    },
                  ),
                ),
              ],
            ),
            CustomFAB(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.addProductScreen);
              },
            ),
          ],
        ),
      ),
    );
  }
}
