import '../../../../backend/utils/custom_loading_api.dart';
import '../../../../utils/basic_screen_imports.dart';
import '../../../../widgets/text_labels/title_heading5_widget.dart';
import '../controller/chat_controller.dart';
import '../model/conversation_model.dart';

class ChatStreamWidget extends StatelessWidget {
  ChatStreamWidget({super.key});

  final controller = Get.find<ChatController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => (controller.isLoading)
          ? CustomLoadingAPI()
          : StreamBuilder<List<PropertyConversation>>(
              stream: controller.conversationStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While waiting for data, show a loading indicator
                  return CustomLoadingAPI();
                } else if (snapshot.hasError) {
                  // If an error occurs, display an error message
                  return Center(
                    child: Text(
                      'An error occurred: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  // If there's no data, display a message indicating no messages
                  return Column(
                    mainAxisAlignment: mainCenter,
                    children: [TitleHeading5Widget(text: Strings.noChatYet)],
                  );
                }
                if (!controller.firstScrollDone) {
                  controller.scrollDown();
                }

                return controller.conversations.isEmpty
                    ? Column(
                        mainAxisAlignment: mainCenter,
                        children: [
                          TitleHeading5Widget(text: Strings.noChatYet),
                        ],
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        controller: controller.scrollController,
                        padding: const EdgeInsets.all(8.0),
                        itemCount: controller.conversations.length,
                        itemBuilder: (context, index) {
                          final message = controller.conversations[index];
                          final isOwnMessage = message.messageSender == 'own';
                          return Align(
                            alignment: isOwnMessage
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4.0),
                              padding: const EdgeInsets.all(12.0),
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.7,
                              ),
                              decoration: BoxDecoration(
                                color: isOwnMessage
                                    ? CustomColor.primaryLightColor.withValues(
                                        alpha: .6,
                                      )
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                    isOwnMessage ? Dimensions.radius * 1.6 : 0,
                                  ),
                                  topRight: Radius.circular(
                                    Dimensions.radius * 1.6,
                                  ),
                                  bottomLeft: Radius.circular(
                                    Dimensions.radius * 1.6,
                                  ),
                                  bottomRight: Radius.circular(
                                    !isOwnMessage ? Dimensions.radius * 1.6 : 0,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: mainMin,
                                mainAxisAlignment: isOwnMessage
                                    ? mainEnd
                                    : mainStart,
                                children: [
                                  isOwnMessage
                                      ? SizedBox.shrink()
                                      : CircleAvatar(
                                          // backgroundColor: CustomColor.primaryLightColor,
                                          backgroundImage: NetworkImage(
                                            message.profileImg,
                                          ),
                                        ),
                                  horizontalSpace(5),
                                  Expanded(
                                    flex:
                                        message.message.length.isGreaterThan(20)
                                        ? 1
                                        : 0,
                                    child: Text(
                                      message.message,
                                      style: TextStyle(
                                        color: isOwnMessage
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                  horizontalSpace(5),
                                  !isOwnMessage
                                      ? SizedBox.shrink()
                                      : CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            message.profileImg,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
              },
            ),
    );
  }
}
