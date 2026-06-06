// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:qrpay/routes/routes.dart';

import '../../../widgets/appbar/appbar_widget.dart';
import '../../backend/local_storage/local_storage.dart';

class WebScreen extends StatelessWidget {
  const WebScreen({super.key, required this.url, required this.title});

  final String url, title;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBarWidget(
          homeButtonShow: LocalStorages.isLoggedIn() ? true : false,
          text: title.tr,
          onTapAction: () {
            Get.offAllNamed(Routes.bottomNavBarScreen);
          },
          onTapLeading: () {
            Navigator.pop(context);
          },
        ),
        body: _bodyWidget(context),
      ),
    );
  }

  InAppWebView _bodyWidget(BuildContext context) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(url)),
      onWebViewCreated: (InAppWebViewController controller) {},
      onProgressChanged: (InAppWebViewController controller, int progress) {},
    );
  }
}
