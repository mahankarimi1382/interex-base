import '../../../../routes/routes.dart';
import '../../../../utils/basic_screen_imports.dart';
import '../model/create_chat_model.dart';
import '../model/user_list_model.dart';
import '../model/user_search_model.dart';
import '../service/my_chat_services.dart';

class MyChatController extends GetxController with MyChatApiServices {
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  RxBool isEmail = true.obs;

  @override
  void onInit() {
    getUserListApi();

    /// =>> Pagination
    scrollController = ScrollController()..addListener(scrollListener);
    super.onInit();
  }

  // controller: controller.scrollController, ///=> Call It On ListView controller
  late ScrollController scrollController;
  void scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      debugPrint('Scrolled to the bottom');
      getUserListMoreApi();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  ///=> API
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  late UserListModel _userListModel;
  UserListModel get userListModel => _userListModel;

  final _isMoreLoading = false.obs;
  bool get isMoreLoading => _isMoreLoading.value;

  int page = 1;
  RxBool hasNextPage = true.obs;
  RxList<Datum> userList = <Datum>[].obs;

  //=> get payment link api Process
  Future<UserListModel> getUserListApi() async {
    userList.clear();
    hasNextPage.value = true;
    page = 1;

    _isLoading.value = true;
    update();
    await getUserListProcessApi(page.toString()).then((value) {
      _userListModel = value!;

      if (_userListModel.data.chatBox.lastPage > 1) {
        hasNextPage.value = true;
      } else {
        hasNextPage.value = false;
      }

      userList.addAll(_userListModel.data.chatBox.data);

      _isLoading.value = false;
      update();
    }).catchError((onError) {
      log.e(onError);
    });
    _isLoading.value = false;
    update();
    return _userListModel;
  }

  Future<UserListModel> getUserListMoreApi() async {
    page++;

    if (hasNextPage.value && !_isMoreLoading.value) {
      _isMoreLoading.value = true;
      update();
      await getUserListProcessApi(page.toString()).then((value) {
        _userListModel = value!;

        var data = _userListModel.data.chatBox.lastPage;
        userList.addAll(_userListModel.data.chatBox.data);

        if(page >= data){
          hasNextPage.value = false;
        }

        _isMoreLoading.value = false;
        _isLoading.value = false;
        update();
      }).catchError((onError) {
        log.e(onError);
      });

      _isMoreLoading.value = false;
      update();
    }
    return _userListModel;
  }



  /// ---------------------------------------------------------------------

  ///=>
  final _isSearchLoading = false.obs;
  bool get isSearchLoading => _isSearchLoading.value;

  late UserSearchModel _userSearchModel;
  UserSearchModel get userSearchModel => _userSearchModel;

  RxBool userFound = false.obs;
  RxBool searchField = false.obs;

  //=> get payment link api Process
  Future<UserSearchModel> userSearchApi() async {
    _isSearchLoading.value = true;
    update();
    await userCheckProcessApi(body: {
      "phone": phoneNumberController.text,
      "email": emailController.text,
    }).then((value) {
      _userSearchModel = value!;

      userFound.value = true;
      _isSearchLoading.value = false;
      update();
    }).catchError((onError) {
      log.e(onError);
      // if (emailController.text == LocalStorages.getEmail() ||
      //     phoneNumberController.text ==
      //         Get.find<UpdateProfileController>()
      //             .profileModel
      //             .data
      //             .user
      //             .mobile ||
      //     phoneNumberController.text ==
      //         Get.find<UpdateProfileController>()
      //             .profileModel
      //             .data
      //             .user
      //             .fullMobile) {
      //   CustomSnackBar.error(Strings.sameEmailErrorMsg);
      // }
    });
    _isSearchLoading.value = false;
    update();
    return _userSearchModel;
  }

  ///=>
  final _isCreateLoading = false.obs;
  bool get isCreateLoading => _isCreateLoading.value;

  late CreateChatModel _createChatModel;
  CreateChatModel get createChatModel => _createChatModel;

  //=> get payment link api Process
  Future<CreateChatModel> createChatApi() async {
    Get.close(1);
    _isCreateLoading.value = true;
    update();
    await createChatProcessApi(
        body: {"receiver_id": _userSearchModel.data.receiverId}).then((value) {
      _createChatModel = value!;

      for (var e in userList) {
        if (e.id == _createChatModel.data.chatboxId.toString()) {
          Get.toNamed(Routes.chatScreen, arguments: [e]);
          return;
        }
      }

      getUserListApi();

      _isCreateLoading.value = false;
      update();
    }).catchError((onError) {
      log.e(onError);
    });
    _isCreateLoading.value = false;
    update();
    return _createChatModel;
  }
}
