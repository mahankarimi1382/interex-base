import 'package:qrpaypro/backend/utils/custom_loading_api.dart';

import '../../../../language/language_controller.dart';
import '../../../../utils/basic_screen_imports.dart';
import '../controller/chat_controller.dart';

class SendChatWidget extends StatelessWidget {
  SendChatWidget({super.key});

  final controller = Get.find<ChatController>();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        border: Border.all(color: CustomColor.primaryLightColor),
        borderRadius: BorderRadius.circular(Dimensions.radius * 2.4),
      ),
      child: Form(
        key: formKey,
        child: Row(
          crossAxisAlignment: crossEnd,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingHorizontalSize * .5,
                ),
                child: TextFormField(
                  controller: controller.sendController,
                  decoration: InputDecoration(
                    hintText:
                        "${Get.find<LanguageController>().getTranslation(Strings.saySomething)} ...",
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    disabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                ),
              ),
            ),
            Obx(
              () => controller.isSendLoading
                  ? CustomLoadingAPI()
                  : FloatingActionButton(
                      elevation: 3,
                      backgroundColor: CustomColor.primaryLightColor,
                      shape: const CircleBorder(),
                      onPressed: () {
                        if (controller.sendController.text.isNotEmpty) {
                          controller.sendMessageApi(
                            controller.sendController.text,
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(
                          Icons.send_rounded,
                          // size: Dimensions.iconSizeLarge,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
