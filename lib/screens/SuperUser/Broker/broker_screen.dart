import 'package:flutter/material.dart';
import '../../../Constants/app_dimensions.dart';
import '../../../Utils/image_assets.dart';
import '../../../utils/app_routes.dart';
import '../../../widgets/CustomCards/SuperUser/broker_card.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/reusable_functions.dart';

class BrokerScreen extends StatefulWidget {
  const BrokerScreen({super.key});

  @override
  State<BrokerScreen> createState() => _BrokerScreenState();
}

class _BrokerScreenState extends State<BrokerScreen> {
  TextEditingController searchController = TextEditingController();
  DateTimeRange? selectedDateRange;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  dynamic brokerData = [
    {
      'name': 'Suresh Kumar',
      'brokerName': 'Sunil Pal',
      'paddy': 'Basmati',
      'date': '21-09-25',
      'location': 'Lucknow, UP',
      'quantity': '30 Qntl',
      'item': 'Wheat',
      'price': '15,000',
      'vehicleNumber': 'DL 12 AB 2198',
    },
    {
      'name': 'Suresh Kumar',
      'brokerName': 'Sunil Pal',
      'paddy': 'Basmati',
      'date': '21-09-25',
      'location': 'Lucknow, UP',
      'quantity': '30 Qntl',
      'item': 'Wheat',
      'price': '15,000',
      'vehicleNumber': 'DL 12 AB 2198',
    },
  ];

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


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(
        isHomePage: false,
        title: 'Broker',
        preferredHeight: height * 0.12,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.035,
          vertical: height * 0.015,
        ),
        child: Column(
          children: [
            // Custom search field
            ReusableSearchField(
              controller: searchController,
              hintText: 'Search by Broker',
              onChanged: (value) {
                // handle search logic
              },
            ),

            AppDimensions.h20(context),

            // Date picker and Add New Leads button
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth:
                      MediaQuery.of(context).size.width -
                      (width * 0.07), // subtract total horizontal padding
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIconButton(
                      text: formatDateRange(selectedDateRange),
                      imagePath: ImageAssets.calender,
                      width: width,
                      height: height,
                      onTap: () => _pickDate(),
                    ),
                    SizedBox(width: width * 0.045),
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
                    SizedBox(width: width * 0.045),
                    CustomIconButton(
                      text: 'Filter',
                      iconData: Icons.tune,
                      onTap: () {},
                      showIconOnRight: true,
                    ),
                  ],
                ),
              ),
            ),

            AppDimensions.h20(context),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(brokerData.length, (index) {
                    final data = brokerData[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: BrokerCard(
                        brokerName: 'Suresh Traders',
                        contactNumber: '+91 9828821922',
                        date: '28-09-2025',
                        paddy: 'Basmati 1121',
                        height: height,
                        width: width,
                        isPending: true,
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.brokerDetailScreen,
                          );
                        },
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
