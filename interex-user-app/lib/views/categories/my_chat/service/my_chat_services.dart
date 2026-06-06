import '../../../../backend/model/common/common_success_model.dart';
import '../../../../backend/utils/api_method.dart';
import '../../../../backend/utils/custom_snackbar.dart';
import '../../../../backend/utils/logger.dart';
import '../../../../backend/services/api_endpoint.dart';
import '../model/conversation_model.dart';
import '../model/create_chat_model.dart';
import '../model/user_list_model.dart';
import '../model/user_search_model.dart';

final log = logger(MyChatApiServices);

mixin MyChatApiServices {
  ///*
  Future<UserListModel?> getUserListProcessApi(String page) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(
        isBasic: false,
      ).get("${ApiEndpoint.userListURL}&page=$page", code: 200);
      if (mapResponse != null) {
        UserListModel result = UserListModel.fromJson(mapResponse);

        return result;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from  Get User List api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in User List Model');
      return null;
    }
    return null;
  }

  ///*
  Future<UserSearchModel?> userCheckProcessApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(
        isBasic: false,
      ).post(ApiEndpoint.userSearchURL, body, code: 200, showError: false);
      if (mapResponse != null) {
        UserSearchModel result = UserSearchModel.fromJson(mapResponse);
        CustomSnackBar.success(result.message.success.first.toString());
        return result;
      }
    } catch (e) {
      log.e('err from post User Check Api service ==> $e');
      // CustomSnackBar.error('Something went Wrong! User Search Model');
      return null;
    }
    return null;
  }

  ///*
  Future<CreateChatModel?> createChatProcessApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(
        isBasic: false,
      ).post(ApiEndpoint.createChatURL, body, code: 200);
      if (mapResponse != null) {
        CreateChatModel result = CreateChatModel.fromJson(mapResponse);
        CustomSnackBar.success(result.message.success.first.toString());
        return result;
      }
    } catch (e) {
      log.e('err from post Create Chat Process API service ==> $e');
      CustomSnackBar.error('Something went Wrong! Create Chat Model');
      return null;
    }
    return null;
  }

  ///*
  Future<ConversationModel?> conversationProcessApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(
        isBasic: false,
      ).post(ApiEndpoint.conversationURL, body, code: 200);
      if (mapResponse != null) {
        ConversationModel result = ConversationModel.fromJson(mapResponse);
        // CustomSnackBar.success(result.message.success.first.toString());
        return result;
      }
    } catch (e) {
      log.e('err from post Conversation Process API service ==> $e');
      CustomSnackBar.error('Something went Wrong! Conversation Model');
      return null;
    }
    return null;
  }

  ///*
  Future<CommonSuccessModel?> sendMessageProcessApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      print(body);
      mapResponse = await ApiMethod(
        isBasic: false,
      ).post(ApiEndpoint.sendMessageURL, body, code: 200);
      if (mapResponse != null) {
        CommonSuccessModel result = CommonSuccessModel.fromJson(mapResponse);
        // CustomSnackBar.success(result.message.success.first.toString());
        return result;
      }
    } catch (e) {
      log.e('err from post Send Message Process API service ==> $e');
      CustomSnackBar.error('Something went Wrong! Send Message Model');
      return null;
    }
    return null;
  }
}
