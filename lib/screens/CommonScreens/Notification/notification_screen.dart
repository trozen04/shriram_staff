import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shree_ram_staff/utils/flutter_font_styles.dart';
import '../../../Bloc/NotificationBloc/notification_bloc.dart';
import '../../../widgets/reusable_appbar.dart';
import '../../../widgets/reusable_functions.dart';
import '../../../utils/pref_utils.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isLoading = true;
  dynamic notifications = [];

  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(NotificationEventHandler());
  }

  String formatDate(String isoDate) {
    try {
      final dateTime = DateTime.parse(isoDate).toLocal();
      return DateFormat('dd MMM, yyyy – hh:mm a').format(dateTime);
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final myUserId = PrefUtils.getUserId();

    return Scaffold(
      appBar: const ReusableAppBar(title: 'Notification'),
      body: BlocListener<NotificationBloc, NotificationState>(
        listener: (context, state) {
          if (state is NotificationLoading) {
            setState(() {
              isLoading = true;
            });
          } else if (state is NotificationSuccess) {
            notifications = state.notificationData['data'] ?? {};
            setState(() {
              isLoading = false;
            });
          } else if (state is NotificationError) {
            setState(() {
              isLoading = false;
            });
          }
        },
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : notifications.length == 0
        ? Center(child: Text('No notifications are available for you.', style: AppTextStyles.label,),)
        : ListView.builder(
          itemCount: notifications.length,
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.035,
            vertical: height * 0.015,
          ),
          itemBuilder: (context, index) {
            final notification = notifications[index];
            final isRead = (notification['readBy'] as List<dynamic>)
                .contains(myUserId);

            return GestureDetector(
              onTap: () => _onNotificationTap(notification),
              child: ReusableNotificationCard(
                title: notification['title'],
                height: height,
                width: width,
                date: notification['createdAt'],
                isRead: true,
              ),
            );
          },
        ),
      ),
    );
  }

  void _onNotificationTap(dynamic notification) {
    final myUserId = PrefUtils.getUserId();
    // final isRead = (notification['readBy'] as List<dynamic>).contains(myUserId);
    final isRead = true;

    // Show popup with title & description
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification['title'], style: AppTextStyles.appbarTitle),
        content: Text(notification['description'], style: AppTextStyles.bodyText),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );

    if (!isRead) {
      // Locally mark as read first so the dot disappears immediately
      setState(() {
        (notification['readBy'] as List).add(myUserId);
      });

      // Then call the API in background
      context.read<NotificationBloc>().add(
        NotificationMarkReadEventHandler(notification['_id']),
      );
    }
  }

}
