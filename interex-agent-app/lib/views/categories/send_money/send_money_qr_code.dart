import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:qrpay/controller/categories/send_money/send_money_controller.dart';

import '../../../custom_assets/assets.gen.dart';
import '../../../language/english.dart';
import '../../../routes/routes.dart';
import '../../../utils/custom_color.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/responsive_layout.dart';
import '../../../widgets/appbar/appbar_widget.dart';
import '../../others/custom_image_widget.dart';

class SendMoneyQRCodeScreen extends StatefulWidget {
  const SendMoneyQRCodeScreen({super.key});

  @override
  ScanScreenState createState() => ScanScreenState();
}

class ScanScreenState extends State<SendMoneyQRCodeScreen> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? barcode;
  RxBool isVisible = true.obs;
  final sendMoneyController = Get.put(SendMoneyController());

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    } else if (Platform.isIOS) {
      await controller!.resumeCamera();
    }
  }

  void readQr() async {
    if (barcode != null) {
      await controller!.pauseCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: CustomColor.primaryLightScaffoldBackgroundColor,
      ),
    );
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: const AppBarWidget(text: Strings.scanQR),
        body: _bodyWidget(context),
      ),
    );
  }

  // body widget containing all widget elements
  Center _bodyWidget(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(top: 40, child: _scanQrCodeWidget(context)),
          Positioned(
            bottom: 20,
            right: 5,
            left: 5,
            child: _iconButtonWidget(context),
          ),
        ],
      ),
    );
  }

  SizedBox _scanQrCodeWidget(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: _buildQrViewWidget(context),
    );
  }

  QRView _buildQrViewWidget(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: onQRViewCreated,
      overlay: QrScannerOverlayShape(
        cutOutSize: MediaQuery.of(context).size.width * 0.6,
        borderWidth: 8,
        borderLength: 20,
        borderRadius: 10,
        borderColor: Theme.of(context).primaryColor,
      ),
    );
  }

  void onQRViewCreated(QRViewController? controller) {
    setState(() => this.controller = controller);
    // this.controller = controller;
    controller!.scannedDataStream.listen(
      (barcode) => setState(() {
        this.barcode = barcode;
        sendMoneyController.getCheckUserWithQrCodeData(
          this.barcode!.code.toString(),
        );
        // Get.close(1);
        debugPrint(this.barcode!.code);

        sendMoneyController.copyInputController.text = this.barcode!.code!;
        Get.toNamed(Routes.moneyTransferScreen);

        readQr();
      }),
    );
  }

  Container _iconButtonWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSize * 0.8),
      margin: EdgeInsets.only(bottom: Dimensions.marginSizeVertical),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {},
            child: CircleAvatar(
              radius: 30,
              backgroundColor: CustomColor.primaryLightColor,
              child: CustomImageWidget(path: Assets.icon.scan),
            ),
          ),
        ],
      ),
    );
  }
}
