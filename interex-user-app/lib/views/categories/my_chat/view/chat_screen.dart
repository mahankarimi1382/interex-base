import 'package:qrpaypro/utils/basic_screen_imports.dart';
import 'package:qrpaypro/utils/responsive_layout.dart';
import 'package:qrpaypro/widgets/appbar/appbar_widget.dart';

import '../controller/chat_controller.dart';
import '../widget/chat_stream_widget.dart';
import '../widget/send_chat_widhet.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: AppBarWidget(text: controller.user.senderImage.fullname),
        body: _bodyWidget(context),
      ),
    );
  }

  Padding _bodyWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSize * .5),
      child: Column(
        mainAxisAlignment: mainEnd,
        children: [
          Expanded(child: ChatStreamWidget()),
          SendChatWidget(),
          verticalSpace(Dimensions.paddingVerticalSize * .8),
        ],
      ),
    );
  }
}
