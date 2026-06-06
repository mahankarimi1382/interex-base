import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qrpay/utils/custom_color.dart';
import 'package:qrpay/widgets/animation/lottie.dart';
import 'package:qrpay/widgets/bottom_navbar/notification_widget.dart';

import '../../backend/utils/custom_loading_api.dart';
import '../../controller/navbar/notification_controller.dart';
import '../../utils/responsive_layout.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        body: Obx(() => controller.isLoading
            ? const CustomLoadingAPI()
            : _bodyWidget(context)),
      ),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return controller.notificationModelData.data.notifications.isNotEmpty
        ? RefreshIndicator(
            color: CustomColor.primaryLightColor,
            onRefresh: () async {
              controller.getNotificationData();
            },
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount:
                    controller.notificationModelData.data.notifications.length,
                itemBuilder: (context, index) {
                  var data = controller
                      .notificationModelData.data.notifications[index];

                  return NotificationWidget(
                    subtitle: data.message,
                    title: data.title,
                    dateText: DateFormat.d().format(data.createdAt),
                    monthText: DateFormat.MMMM().format(data.createdAt),
                  );
                }),
          )
        : const Align(
            alignment: Alignment.center,
            child: LottieAnimation(),
          );
  }
}
