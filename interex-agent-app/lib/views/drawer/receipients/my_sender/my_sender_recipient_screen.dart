import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/routes/routes.dart';
import 'package:qrpay/utils/custom_color.dart';
import 'package:qrpay/utils/dimensions.dart';
import 'package:qrpay/utils/responsive_layout.dart';
import 'package:qrpay/widgets/appbar/appbar_widget.dart';
import 'package:qrpay/widgets/drawer/save_recipients_widget.dart';

import '../../../../backend/utils/custom_loading_api.dart';
import '../../../../backend/utils/status_data_widget.dart';
import '../../../../controller/drawer/recipient/my_sender_recipient/my_sender_recipient_controller.dart';
import '../../../../language/english.dart';

class MySenderRecipientScreen extends StatelessWidget {
  MySenderRecipientScreen({super.key});

  final controller = Get.put(MySenderRecipientController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.add, color: CustomColor.whiteColor, size: 30),
          onPressed: () {
            Get.toNamed(Routes.addMySenderRecipientScreen);
          },
        ),
        appBar: const AppBarWidget(text: Strings.mySenders),
        body: Obx(
          () => controller.isLoading
              ? const CustomLoadingAPI()
              : _bodyWidget(context),
        ),
      ),
    );
  }

  StatelessWidget _bodyWidget(BuildContext context) {
    return controller.allRecepientData.data.senderRecipients.isEmpty
        ? InkWell(
            onTap: () {
              Get.toNamed(Routes.addMySenderRecipientScreen);
            },
            child: const StatusDataWidget(
              text: "No Recipient Found! Please Add First",
              icon: Icons.person_add_alt,
            ),
          )
        : ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSize * 0.76,
            ),
            itemCount: controller.allRecepientData.data.senderRecipients.length,
            itemBuilder: (context, index) {
              final data =
                  controller.allRecepientData.data.senderRecipients[index].obs;
              return SaveRecipientWidget(
                title: "${data.value.firstname} ${data.value.lastname}",
                subTitle: data.value.mobile,
                type: data.value.trxTypeName,
                onTap: (value) {
                  if (value == "Remove Recipient") {
                    Navigator.pop(context);
                    controller
                        .recipientDeleteApiProcess(id: data.value.id.toString())
                        .then((value) => controller.getMySenderRecipientData());
                  } else if (value == "Edit Recipient") {
                    Navigator.pop(context);
                    controller.recipientEditApiProcess(
                      id: data.value.id.toString(),
                    );
                  } else if (value == "Send") {
                  } else {}
                },
              );
            },
          );
  }
}
