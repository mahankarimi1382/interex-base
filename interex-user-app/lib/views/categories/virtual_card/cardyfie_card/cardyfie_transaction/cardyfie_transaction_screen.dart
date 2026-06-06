import 'package:intl/intl.dart';

import '../../../../../backend/utils/custom_loading_api.dart';
import '../../../../../utils/basic_screen_imports.dart';
import '../../../../../utils/responsive_layout.dart';
import '../../../../../widgets/appbar/appbar_widget.dart';
import '../../../../../widgets/text_labels/title_heading5_widget.dart';
import '../controller/cardyfie_transaction_log_controller.dart';

part '../cardyfie_transaction/widget/card_transactions_widget.dart';

class CardyfieTransactionLogScreen extends StatelessWidget {
  CardyfieTransactionLogScreen({super.key});
  final controller = Get.put(CardyfieTransactionLogController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: const AppBarWidget(text: Strings.transactionHistory),

        body: Obx(
          () => controller.isLoading
              ? const CustomLoadingAPI()
              : _bodyWidget(context),
        ),
      ),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    var data = controller.cardTransactionModelCardyfie.data.cardTransactions;
    return data.isNotEmpty
        ? RefreshIndicator(
            color: CustomColor.primaryLightColor,
            onRefresh: () async {
              controller.getCardTransactionHistory();
            },
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.marginSizeHorizontal * 0.9,
              ),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return CardyfieExpandableWidget(
                  amount:
                      '${double.parse(data[index].enterAmount).toStringAsFixed(2)} ${data[index].cardCurrency}',
                  title: data[index].trxType,
                  dateText: DateFormat(
                    'MMM dd, yyyy',
                  ).format(data[index].createdAt),
                  transaction: data[index].ulid,
                  monthText: DateFormat.MMM().format(data[index].createdAt),
                  status: data[index].status, // ✅ New field
                  amountType: data[index].amountType, // ✅ New field
                );

                // TransactionWidget(
                //   amount:
                //       '${double.parse(data[index].enterAmount).toStringAsFixed(2)} ${data[index].cardCurrency}',
                //   title: data[index].trxType,
                //   dateText: DateFormat.M().format(data[index].createdAt),
                //   transaction: data[index].ulid,
                //   monthText: DateFormat.MMM().format(data[index].createdAt),
                // );
              },
            ),
          )
        : Center(
            child: TitleHeading1Widget(
              text: Strings.noRecordFound,
              color: CustomColor.primaryLightColor,
            ),
          );
  }
}
