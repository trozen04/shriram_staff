import 'package:flutter/material.dart';
import 'package:shree_ram_staff/widgets/custom_app_bar.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../Utils/image_assets.dart';
import '../../../utils/app_routes.dart';
import '../../../widgets/reusable_functions.dart';

class ReportScreen extends StatefulWidget {
  final reportData;
  final bool isSuperUser;
  const ReportScreen({
    super.key,
    required this.reportData,
    this.isSuperUser = false,
  });

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  DateTimeRange? selectedDateRange;
  DateTime? fromDate;
  DateTime? toDate;


  void _pickDate() async {
    final DateTimeRange? picked = await pickDateRange(
      context: context,
      initialRange: selectedDateRange,
    );

    if (picked != null) {
      setState(() {
        selectedDateRange = picked;
      });
    }
  }

  final reportData = [
    {
      'item': 'Paddy',
      'qtyIn': '33 Qntl',
      'qtyOut': '13 Qntl',
      'stockLeft': '20 Qntl',
    },
    {
      'item': 'Paddy',
      'qtyIn': '33 Qntl',
      'qtyOut': '13 Qntl',
      'stockLeft': '20 Qntl',
    },
    {
      'item': 'Paddy',
      'qtyIn': '33 Qntl',
      'qtyOut': '13 Qntl',
      'stockLeft': '20 Qntl',
    },
    {
      'item': 'Paddy',
      'qtyIn': '33 Qntl',
      'qtyOut': '13 Qntl',
      'stockLeft': '20 Qntl',
    },
    {
      'item': 'Paddy',
      'qtyIn': '33 Qntl',
      'qtyOut': '13 Qntl',
      'stockLeft': '20 Qntl',
    },
    {
      'item': 'Paddy',
      'qtyIn': '33 Qntl',
      'qtyOut': '13 Qntl',
      'stockLeft': '20 Qntl',
    },
    {
      'item': 'Paddy',
      'qtyIn': '33 Qntl',
      'qtyOut': '13 Qntl',
      'stockLeft': '20 Qntl',
    },
    {
      'item': 'Paddy',
      'qtyIn': '33 Qntl',
      'qtyOut': '13 Qntl',
      'stockLeft': '20 Qntl',
    },
  ];


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(title: 'Report', preferredHeight: height * 0.12),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.035,
          vertical: height * 0.015,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomIconButton(
                  text: formatDateRange(selectedDateRange),
                  imagePath: ImageAssets.calender,
                  width: width,
                  height: height,
                  onTap: () => _pickDate(),
                ),
                if (widget.isSuperUser) ...[
                  AppDimensions.w20(context),
                  CustomIconButton(
                    text: 'Factory',
                    imagePath: ImageAssets.factoryPNG,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.factoryScreen,
                        arguments: null,
                      );
                    },
                    showIconOnRight: true,
                  ),
                ],

              ],
            ),

            AppDimensions.h20(context),
            Expanded(
              child: SingleChildScrollView(
                child: ReportTable(data: reportData),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
