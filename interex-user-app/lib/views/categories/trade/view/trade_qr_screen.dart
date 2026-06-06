// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:qrpaypro/widgets/appbar/appbar_widget.dart';
import 'package:screenshot/screenshot.dart';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/basic_screen_imports.dart';
import '../../../../utils/basic_screen_imports.dart' as ui;
import '../../../../widgets/text_labels/title_subtitle_widget.dart';
import '../controller/trade_controller.dart';

class TradeQrScreen extends StatefulWidget {
  const TradeQrScreen({super.key});

  @override
  State<TradeQrScreen> createState() => _TradeQrScreenState();
}

class _TradeQrScreenState extends State<TradeQrScreen> {
  final controller = Get.find<TradeController>();

  ScreenshotController screenshotController = ScreenshotController();

  Future<void> captureAndShare() async {
    try {
      // Capture the widget as image
      Uint8List? image = await screenshotController.capture();

      if (image != null) {
        // Get temporary directory
        final directory = await getTemporaryDirectory();
        final imagePath = await File(
          '${directory.path}/screenshot.png',
        ).create();

        // Write the image bytes to the file
        await imagePath.writeAsBytes(image);

        // Share the image file
        await Share.shareXFiles([
          XFile(imagePath.path),
        ], text: 'Check out this image!');
      }
    } catch (e) {
      print('Error capturing and sharing image: $e');
    }
  }

  // final GlobalKey previewContainer = GlobalKey();
  @override
  Widget build(BuildContext context) {
    // Future<bool> onWillPop() async {
    //   Get.offAllNamed(Routes.bottomNavBarScreen);
    //   return Future.value(true);
    // }

    return Scaffold(
      appBar: AppBarWidget(text: ""),
      body: _bodyWidget(context),
    );
  }

  SafeArea _bodyWidget(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: mainCenter,
        children: [
          _titleSubTitleWidget(context),

          Screenshot(
            controller: screenshotController,
            child: Column(
              children: [_qrCodeWidget(context), _copyLinkWidget(context)],
            ),
          ),

          _shareButtonWidget(context),
        ],
      ),
    );
  }

  Column _shareButtonWidget(BuildContext context) {
    return Column(
      children: [
        PrimaryButton(
          title: Strings.share,
          onPressed: captureAndShare,
        ).marginSymmetric(horizontal: Dimensions.marginSizeHorizontal * 0.8),

        verticalSpace(Dimensions.paddingVerticalSize * .7),

        TextButton(
          onPressed: () {
            Get.offAllNamed(Routes.bottomNavBarScreen);
          },
          child: TitleHeading4Widget(text: Strings.backtoHome),
        ).marginSymmetric(horizontal: Dimensions.marginSizeHorizontal * 0.8),
      ],
    );
  }

  Widget _copyLinkWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.paddingSize * 0.666),
      margin: EdgeInsets.only(bottom: Dimensions.paddingSize * 0.666),
      decoration: BoxDecoration(
        border: Border.all(color: CustomColor.blackColor),
        borderRadius: BorderRadius.circular(Dimensions.radius * 1.2),
        color: Get.isDarkMode
            ? CustomColor.whiteColor.withValues(alpha: .05)
            : CustomColor.whiteColor,
      ),
      child: Row(
        mainAxisAlignment: mainSpaceBet,
        children: [
          Expanded(
            flex: 10,
            child: TitleHeading4Widget(
              text:
                  Uri.parse(
                    controller.tradeSubmitModel.data.preview.qrcode,
                  ).queryParameters['data'] ??
                  "",
              opacity: 0.70,
              color: Get.isDarkMode ? CustomColor.whiteColor : null,
            ),
          ),
          Expanded(
            child: InkWell(
              child: Icon(Icons.copy),
              onTap: () async {
                await Clipboard.setData(
                  ClipboardData(
                    text:
                        Uri.parse(
                          controller.tradeSubmitModel.data.preview.qrcode,
                        ).queryParameters['data'] ??
                        "",
                  ),
                ).then((value) {
                  // CustomSnackBar.success(Strings.copyQrUrl);
                });
              },
            ),
          ),
        ],
      ),
    ).marginSymmetric(horizontal: Dimensions.marginSizeHorizontal * 0.8);
  }

  Widget _titleSubTitleWidget(BuildContext context) {
    return TitleSubTitleWidget(
      title: controller.tradeSubmitModel.data.preview.message,
      subtitle: controller.tradeSubmitModel.data.preview.details,
      crossAxisAlignment: crossCenter,
    ).paddingSymmetric(horizontal: Dimensions.marginSizeHorizontal * 0.7);
  }

  Container _qrCodeWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Dimensions.paddingHorizontalSize * .8,
        vertical: Dimensions.paddingVerticalSize * .6,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius * 1.2),
        color: Get.isDarkMode
            ? CustomColor.whiteColor.withValues(alpha: .05)
            : CustomColor.whiteColor,
      ),
      child:
          Image.network(
            controller.tradeSubmitModel.data.preview.qrcode,
            height: Dimensions.heightSize * 15,
          ).paddingSymmetric(
            vertical: Dimensions.marginSizeVertical * 1.3,
            horizontal: Dimensions.marginSizeHorizontal * 0.4,
          ),
    );
  }
}
