import 'package:intl/intl.dart';
import 'package:qrpaypro/views/categories/virtual_card/cardyfie_card/model/country_model.dart';
import 'package:qrpaypro/views/categories/virtual_card/cardyfie_card/model/my_card_model_cardyfie.dart';

import '../../../../../backend/model/payment_link/type_selection_drop_down.dart';
import '../../../../../backend/utils/custom_loading_api.dart';
import '../../../../../controller/auth/registration/kyc_form_controller.dart';
import '../../../../../controller/profile/update_profile_controller.dart';
import '../../../../../language/language_controller.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/basic_screen_imports.dart';
import '../../../../../widgets/appbar/appbar_widget.dart';
import '../../../../../widgets/inputs/custom_country_drop_down.dart';
import '../../../../../widgets/inputs/primary_text_input_widget.dart';
import '../../../../../widgets/payment_link/custom_drop_down.dart';
import '../controller/cardyfie_info_controller.dart';
import 'widget/kyc_dynamic_dropdown.dart';
import 'widget/selected_image_widget.dart';

part 'widget/cardyfie_create_card_widget.dart';
part 'widget/cardyfie_create_customer_widget.dart';
part 'widget/pending_status.dart';

class CrateCardyfieScreen extends StatelessWidget {
  CrateCardyfieScreen({super.key});

  final controller = Get.put(VirtualCardyfieCardController());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: const AppBarWidget(text: Strings.createCardCustomer),

        body: controller.isLoading || controller.isBuyCardLoading
            ? const CustomLoadingAPI()
            : _bodyWidget(context),
      ),
    );
  }

  ListView _bodyWidget(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSize * 0.7),
      children: [
        if (controller
                .createCardPageInfoModelCardyfie
                .data
                .customerExistStatus ==
            false) ...[
          CreateCustomerWidget(),
        ] else ...[
          if (controller
                  .createCardPageInfoModelCardyfie
                  .data
                  .customerExist
                  .status ==
              "APPROVED") ...[
            CardyfieCreateCardWidget(),
          ] else ...[
            CardyfiePendingWidget(),
          ],
        ],
      ],
    );
  }
}
