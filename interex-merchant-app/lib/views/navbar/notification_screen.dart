import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qrpay/widgets/bottom_navbar/notification_widget.dart';
import '../../backend/utils/no_data_widget.dart';
import '../../controller/navbar/notification_controller.dart';
import '../../utils/responsive_layout.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(body: _bodyWidget(context)),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return controller.notificationModelData.data.notifications.isNotEmpty
        ? RefreshIndicator(
            color: Theme.of(context).primaryColor,
            onRefresh: () async {
              await controller.getNotificationData();
            },
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount:
                  controller.notificationModelData.data.notifications.length,
              itemBuilder: (context, index) {
                final data =
                    controller.notificationModelData.data.notifications[index];

                return NotificationWidget(
                  subtitle: data.message,
                  title: data.type,
                  dateText: DateFormat.d().format(data.createdAt),
                  monthText: DateFormat.MMM().format(data.createdAt),
                );
              },
            ),
          )
        : const NoDataWidget();
  }
}
