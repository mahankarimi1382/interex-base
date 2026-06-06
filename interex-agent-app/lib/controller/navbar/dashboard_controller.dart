import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import 'package:pusher_beams/pusher_beams.dart';

import '../../backend/local_storage/local_storage.dart';
import '../../backend/model/bottom_navbar_model/dashboard_model.dart';
import '../../backend/model/pusher/pusher_beams_model.dart';
// import '../../backend/services/api_endpoint.dart';
import '../../backend/services/api_services.dart';
import '../../backend/services/pusher/pusher_api_services.dart';
import '../../custom_assets/assets.gen.dart';
import '../../language/english.dart';
import '../../model/categories_model.dart';
import '../../routes/routes.dart';
import '../wallet/wallets_controller.dart';

class DashBoardController extends GetxController {
  List<CategoriesModel> categoriesData = [];
  final CarouselController carouselController = CarouselController();
  final walletController = Get.put(WalletsController());
  RxInt switchCurrency = 0.obs;
  RxInt current = 0.obs;
  RxString totalReceive = ''.obs;
  RxInt kycStatus = 0.obs;
  RxString profitBalance = ''.obs;

  // Timer? _timer;

  @override
  void dispose() {
    // _timer?.cancel();
    super.dispose();
  }

  @override
  void onInit() {
    getDashboardData();
    // _timer = Timer.periodic(Duration(seconds: 10), (Timer timer) {
    //   getDashboardData2();
    // });
    super.onInit();
  }

  // RxString pinCode = "".obs;
  RxBool pinStatus = false.obs;
  RxBool pinVerification = false.obs;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  late DashboardModel _dashboardModel;
  DashboardModel get dashBoardModel => _dashboardModel;

  Future<DashboardModel> getDashboardData() async {
    _isLoading.value = true;

    update();

    // calling  from api service
    await ApiServices.dashboardApi()
        .then((value) async {
          _dashboardModel = value!;

          pinStatus.value = _dashboardModel.data.agent.pinStatus;
          pinVerification.value = _dashboardModel.data.pinVerification;
          // pinCode.value = _dashboardModel.data.agent.pinCode.toString();

          final data = _dashboardModel.data.moduleAccess;
          totalReceive.value = _dashboardModel.data.totalReceiveMoney;
          profitBalance.value = _dashboardModel.data.agentProfits;
          categoriesData.clear();
          await getPusherAuth();
          // await PusherBeams.instance.start(
          //   _dashboardModel.data.pusherCredentials.instanceId,
          // );
          if (data.transferMoney) {
            categoriesData.add(
              CategoriesModel(Assets.icon.send, Strings.send, () {
                Get.toNamed(Routes.moneyTransferScreen);
              }),
            );
          }

          if (data.receiveMoney) {
            categoriesData.add(
              CategoriesModel(Assets.icon.receive, Strings.receive, () {
                Get.toNamed(Routes.moneyReceiveScreen);
              }),
            );
          }

          if (data.remittanceMoney) {
            categoriesData.add(
              CategoriesModel(Assets.icon.remittance, Strings.remittance, () {
                Get.toNamed(Routes.remittanceScreen);
              }),
            );
          }

          if (data.addMoney) {
            categoriesData.add(
              CategoriesModel(Assets.icon.deposit, Strings.addMoney, () {
                Get.toNamed(Routes.addMoneyScreen);
              }),
            );
          }

          if (data.moneyIn) {
            categoriesData.add(
              CategoriesModel(Assets.icon.deposit, Strings.moneyIn, () {
                Get.toNamed(Routes.moneyInScreen);
              }),
            );
          }
          if (data.withdrawMoney) {
            categoriesData.add(
              CategoriesModel(Assets.icon.withdraw, Strings.withdraw, () {
                Get.toNamed(Routes.withdrawScreen);
              }),
            );
          }

          if (data.billPay) {
            categoriesData.add(
              CategoriesModel(Assets.icon.billPay, Strings.billPay, () {
                Get.toNamed(Routes.billPayScreen);
              }),
            );
          }

          if (data.mobileTopUp) {
            categoriesData.add(
              CategoriesModel(Assets.icon.mobileTopUp, Strings.mobileTopUp, () {
                Get.toNamed(Routes.mobileToUpScreen);
              }),
            );
          }
          kycStatus.value = _dashboardModel.data.agent.kycVerified;

          _isLoading.value = false;
          update();
        })
        .catchError((onError) {
          log.e(onError);
        });
    update();
    return _dashboardModel;
  }

  Future<DashboardModel> getDashboardData2() async {
    // _isLoading.value = true;

    update();

    // calling  from api service
    await ApiServices.dashboardApi()
        .then((value) async {
          _dashboardModel = value!;

          pinStatus.value = _dashboardModel.data.agent.pinStatus;
          pinVerification.value = _dashboardModel.data.pinVerification;
          // pinCode.value = _dashboardModel.data.agent.pinCode.toString();

          kycStatus.value = _dashboardModel.data.agent.kycVerified;

          _isLoading.value = false;
          update();
        })
        .catchError((onError) {
          log.e(onError);
        });
    update();
    return _dashboardModel;
  }

  // Register Pusher Beams
  final _isPusherBeamsLoading = false.obs;
  bool get isPusherBeamsLoading => _isPusherBeamsLoading.value;
  late PusherBeamsModel _pusherBeamsModel;

  PusherBeamsModel get pusherBeamsModel => _pusherBeamsModel;

  Future<PusherBeamsModel> getPusherAuth() async {
    _isPusherBeamsLoading.value = true;

    update();
    await PusherApiServices.getPusherBeamsAuth(LocalStorage.getId()!)
        .then((value) {
          _pusherBeamsModel = value!;
          // getSecure();
          LocalStorage.savePusherAuthenticationKey(
            pusherAuthenticationKey: true,
          );
          _isPusherBeamsLoading.value = false;
          update();
        })
        .catchError((onError) {
          log.e(onError);
        });
    update();
    return _pusherBeamsModel;
  }

  // getSecure() async {
  //   final BeamsAuthProvider provider = BeamsAuthProvider()
  //     ..authUrl = ApiEndpoint.pusherBeamsAuthMain
  //     ..headers = {'Content-Type': 'application/json'}
  //     ..queryParams = {'user_id': '1'}
  //     ..credentials = 'omit';
  //
  //   await PusherBeams.instance.setUserId(
  //     '1',
  //     provider,
  //     (error) => {
  //       if (error != null) {debugPrint("----------$error---------")}
  //     },
  //   );
  // }
}
