import 'package:flutter/material.dart';

import '../../../widgets/reusable_appbar.dart';
import '../../../widgets/reusable_functions.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, String>> notifications = [
    {"title": "Order #1234", "time": "2 mins ago"},
    {"title": "Shipment Dispatched", "time": "10 mins ago"},
    {"title": "Quality Check Completed", "time": "1 hour ago"},
    {"title": "New Message", "time": "Yesterday"},
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: const ReusableAppBar(title: 'Notification'),
      body: ListView.builder(
        itemCount: notifications.length,
        padding: EdgeInsets.symmetric(horizontal: width * 0.035, vertical: height * 0.015),
        itemBuilder: (context, index) {
          return ReusableNotificationCard(
            title: 'Notification1',
            time: '4:41 PM',
            height: height,
            width: width,
          );
        },
      ),
    );
  }
}
