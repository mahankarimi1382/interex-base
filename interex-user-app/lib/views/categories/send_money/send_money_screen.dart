import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:qrpaypro/backend/local_storage/local_storage.dart';
import 'package:qrpaypro/backend/model/wallets/wallets_model.dart';
import 'package:qrpaypro/routes/routes.dart';
import 'package:qrpaypro/utils/responsive_layout.dart';
import 'package:qrpaypro/widgets/inputs/input_formater.dart';

import '../../../controller/categories/send_money/send_money_controller.dart';
import '../../../controller/navbar/dashboard_controller.dart';
import '../../../language/english.dart';
import '../../set_up_pin/controller/set_up_pin_controller.dart';
import '../transfer/transfer_ui_kit.dart';

class MoneyTransferScreen extends StatelessWidget {
  MoneyTransferScreen({super.key});

  final controller = Get.put(SendMoneyController());
  final kyc = Get.put(DashBoardController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        backgroundColor: TransferTokens.scaffoldBg,
        appBar: const TransferAppBar(
          titleKey: Strings.sendMoney,
          subtitleKey: Strings.recipient,
        ),
        body: Obx(
          () => controller.isLoading
              ? const _LoadingState()
              : _body(context),
        ),
        bottomNavigationBar: Obx(
          () => controller.isLoading
              ? const SizedBox.shrink()
              : _bottomBar(context),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 28),
      physics: const BouncingScrollPhysics(),
      children: [
        _recipientCard(context),
        _amountCard(context),
        _remarkCard(),
        _limitsCard(),
      ],
    );
  }

  //! ─────────────────────────────  Recipient  ─────────────────────────────
  Widget _recipientCard(BuildContext context) {
    return SectionCard(
      titleKey: Strings.recipient,
      icon: Icons.person_outline_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FieldLabel(Strings.phoneEmail),
          TransferTextField(
            controller: controller.copyInputController,
            hintKey: Strings.enterEmailPhone,
            prefixIcon: Icons.alternate_email_rounded,
            onSubmitted: (_) => _verifyRecipient(),
            onTapOutside: (_) => _verifyRecipient(),
            suffix: _scanButton(),
          ),
          Obx(
            () => controller.checkUserMessage.value.isEmpty
                ? const SizedBox.shrink()
                : StatusPill(
                    valid: controller.isValidUser.value,
                    message: controller.checkUserMessage.value,
                  ),
          ),
        ],
      ),
    );
  }

  void _verifyRecipient() {
    if (controller.copyInputController.text.isNotEmpty) {
      controller.getCheckUserExistDate();
    }
  }

  Widget _scanButton() {
    return Padding(
      padding: const EdgeInsets.all(7),
      child: GestureDetector(
        onTap: () => Get.toNamed(Routes.qRCodeScreen),
        child: Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            gradient: TransferTokens.brand,
            borderRadius: BorderRadius.circular(TransferTokens.radius - 4),
          ),
          child: const Icon(
            Icons.qr_code_scanner_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  //! ──────────────────────────────  Amount  ───────────────────────────────
  Widget _amountCard(BuildContext context) {
    return SectionCard(
      titleKey: Strings.amount,
      icon: Icons.swap_vert_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FieldLabel(Strings.senderAmount),
          TransferTextField(
            controller: controller.senderAmountController,
            hintKey: Strings.zero00,
            bigText: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [DecimalTextInputFormatter()],
            onChanged: (_) => _onSenderChanged(),
            suffix: Obx(
              () => CurrencyPill(
                code: controller.selectSenderWallet.value?.currency.code ?? '',
                onTap: () => _pickWallet(context, isSender: true),
              ),
            ),
          ),
          const FlowDivider(),
          const FieldLabel(Strings.receiverAmount),
          TransferTextField(
            controller: controller.receiverAmountController,
            hintKey: Strings.zero00,
            bigText: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [DecimalTextInputFormatter()],
            onChanged: (_) => _onReceiverChanged(),
            suffix: Obx(
              () => CurrencyPill(
                code:
                    controller.selectReceiverWallet.value?.currency.code ?? '',
                onTap: () => _pickWallet(context, isSender: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSenderChanged() {
    controller.getReceiverAmount();
    if (controller.senderAmountController.text.isEmpty) {
      controller.senderAmountController.text = "";
    } else {
      controller.remainingController.senderAmount.value =
          controller.senderAmountController.text;
      controller.remainingController.getRemainingBalanceProcess();
    }
    controller.getFee(
      rate: double.parse(controller.selectSenderWallet.value!.currency.rate),
    );
  }

  void _onReceiverChanged() {
    controller.getSenderAmount();
    controller.getFee(
      rate: double.parse(controller.selectSenderWallet.value!.currency.rate),
    );
  }

  void _pickWallet(BuildContext context, {required bool isSender}) {
    showTransferPicker<MainUserWallet>(
      context: context,
      titleKey: Strings.amount,
      items: controller.walletsList,
      labelOf: (w) => w.currency.country,
      subtitleOf: (w) =>
          "${double.tryParse(w.balance.toString())?.toStringAsFixed(2) ?? w.balance} ${w.currency.code}",
      badgeOf: (w) => w.currency.code,
      onSelected: (w) {
        if (isSender) {
          controller.selectSenderWallet.value = w;
          controller.updateExchangeRate();
          controller.remainingController.senderCurrency.value =
              w.currency.code;
          controller.remainingController.getRemainingBalanceProcess();
          controller.getReceiverAmount();
        } else {
          controller.selectReceiverWallet.value = w;
          controller.updateExchangeRate();
          controller.getSenderAmount();
        }
      },
    );
  }

  //! ──────────────────────────────  Remark  ───────────────────────────────
  Widget _remarkCard() {
    return SectionCard(
      titleKey: Strings.remark,
      icon: Icons.sticky_note_2_outlined,
      trailing: TText(
        Strings.optional,
        style: TransferTokens.body(size: 11.5, color: TransferTokens.textMuted),
      ),
      child: TransferTextField(
        controller: controller.remarkController,
        hintKey: Strings.enterRemark,
        maxLines: 4,
      ),
    );
  }

  //! ──────────────────────────────  Limits  ───────────────────────────────
  Widget _limitsCard() {
    return Obx(() {
      final wallet = controller.selectSenderWallet.value;
      if (wallet == null) return const SizedBox.shrink();
      final code = wallet.currency.code;
      final precision = wallet.currency.type == 'FIAT'
          ? LocalStorages.getFiatPrecision()
          : LocalStorages.getCryptoPrecision();
      final showDaily = controller.dailyLimit.value != 0.0;
      final showMonthly = controller.monthlyLimit.value != 0.0;

      String fmt(double v) => '${v.toStringAsFixed(precision)} $code';

      return SectionCard(
        titleKey: Strings.limitInformation,
        icon: Icons.shield_outlined,
        child: Column(
          children: [
            StatRow(
              labelKey: Strings.transactionLimit,
              value:
                  '${controller.limitMin.value.toStringAsFixed(precision)} - ${controller.limitMax.value.toStringAsFixed(precision)} $code',
              emphasize: true,
            ),
            if (showDaily) ...[
              const Divider(height: 18),
              StatRow(
                labelKey: Strings.dailyLimit,
                value: fmt(controller.dailyLimit.value),
              ),
              StatRow(
                labelKey: Strings.remainingDailyLimit,
                value: fmt(
                  controller.remainingController.remainingDailyLimit.value,
                ),
              ),
            ],
            if (showMonthly) ...[
              const Divider(height: 18),
              StatRow(
                labelKey: Strings.monthlyLimit,
                value: fmt(controller.monthlyLimit.value),
              ),
              StatRow(
                labelKey: Strings.remainingMonthlyLimit,
                value: fmt(
                  controller.remainingController.remainingMonthLyLimit.value,
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  //! ────────────────────────────  Bottom CTA  ─────────────────────────────
  bool get _canSend {
    final amount =
        double.tryParse(controller.remainingController.senderAmount.value) ?? 0;
    return controller.isValidUser.value &&
        amount > 0 &&
        amount <= controller.dailyLimit.value &&
        amount <= controller.monthlyLimit.value;
  }

  Widget _bottomBar(BuildContext context) {
    return StickyBottomBar(
      child: Obx(
        () => GradientButton(
          labelKey: Strings.send,
          enabled: _canSend,
          loading: controller.isSendMoneyLoading,
          onTap: () {
            Get.find<SetUpPinController>().showPinDialog(
              context,
              onSuccess: () {
                Get.toNamed(Routes.sendMoneyPreviewScreen);
              },
            );
          },
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: TransferTokens.primary),
    );
  }
}
