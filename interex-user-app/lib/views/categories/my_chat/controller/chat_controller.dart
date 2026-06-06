import 'dart:async';

import '../../../../backend/model/common/common_success_model.dart';
import '../../../../utils/basic_screen_imports.dart';
import '../model/conversation_model.dart';
import '../model/user_list_model.dart';
import '../service/my_chat_services.dart';

class ChatController extends GetxController with MyChatApiServices {
  final sendController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  bool firstScrollDone = false;

  late final StreamSubscription<List<PropertyConversation>> subscription;

  final Datum user = Get.arguments.toList().first;

  @override
  void onInit() {
    super.onInit();
    haveError.value = false;
    // subscription = conversationStream().listen(_handleNewConversations);
  }

  void _handleNewConversations(List<PropertyConversation> newConversations) {
    print("==>> ");
    print("==>> ");
    print(newConversations.length);
    for (var conversation in newConversations) {
      if (!conversations.any((c) => c.id == conversation.id)) {
        conversations.add(conversation);

        // if(conversation.messageSender == "")
        print("==>> ==>");
        scrollDown();
        print("==>> ==> ==> ");
        print(conversations.length);
      }
    }
  }

  void scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
        firstScrollDone = true;
      }
    });
  }

  @override
  void dispose() {
    haveError.value = true;
    // subscription.cancel();
    super.dispose();
  }

  @override
  void onClose() {
    haveError.value = true;
    // subscription.cancel();
    super.onClose();
  }

  ///=>
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  RxBool haveError = false.obs;
  int streamCount = 0;
  int apiCount = 0;

  late ConversationModel _conversationModel;
  ConversationModel get conversationModel => _conversationModel;

  RxList<PropertyConversation> conversations = <PropertyConversation>[].obs;

  //=> get payment link api Process
  Stream<List<PropertyConversation>> conversationStream() async* {
    while (!haveError.value) {
      streamCount++;
      try {
        final ConversationModel model = await fetchConversationApi();
        yield model.data.propertyConversations;
      } catch (e) {
        haveError.value = true;
        // Handle error appropriately
      } finally {}
      await Future.delayed(
        Duration(seconds: 2),
      ); // Adjust the interval as needed
    }
  }

  Future<ConversationModel> fetchConversationApi() async {
    if (apiCount == 0) {
      _isLoading.value = true;
    }
    update();
    await conversationProcessApi(body: {"Chatbox_id": user.id})
        .then((value) {
          _conversationModel = value!;

          _handleNewConversations(
            _conversationModel.data.propertyConversations,
          );

          // conversations.addAll(_conversationModel.data.propertyConversations);

          // if(apiCount.isLowerThan(4)){
          //   _scrollDown();
          // }

          apiCount++;
          _isLoading.value = false;
          update();
        })
        .catchError((onError) {
          haveError.value = true;
          log.e(onError);
        });
    _isLoading.value = false;
    update();
    return _conversationModel;
  }

  ///=>
  final _isSendLoading = false.obs;
  bool get isSendLoading => _isSendLoading.value;

  late CommonSuccessModel _sendMessageModel;
  CommonSuccessModel get sendMessageModel => _sendMessageModel;

  //=> get payment link api Process
  Future<CommonSuccessModel> sendMessageApi(String text) async {
    _isSendLoading.value = true;
    // _isLoading.value = true;
    update();

    await sendMessageProcessApi(
          body: {
            "message": text,
            "chatBox_id": _conversationModel.data.chatBox,
          },
        )
        .then((value) {
          _sendMessageModel = value!;

          sendController.clear();

          _isSendLoading.value = false;
          update();
        })
        .catchError((onError) {
          log.e(onError);
        });
    _isSendLoading.value = false;
    update();
    return _sendMessageModel;
  }
}
