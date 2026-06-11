import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:qrpaypro/backend/local_storage/local_storage.dart';
import 'package:qrpaypro/backend/model/remittance/remittance_get_recipient_model.dart';
import 'package:qrpaypro/backend/model/remittance/remittance_info_model.dart';
import 'package:qrpaypro/routes/routes.dart';
import 'package:qrpaypro/utils/responsive_layout.dart';
import 'package:qrpaypro/widgets/inputs/input_formater.dart';

import '../../../controller/categories/remittance/remitance_controller.dart';
import '../../../language/english.dart';
import '../../set_up_pin/controller/set_up_pin_controller.dart';
import '../transfer/transfer_ui_kit.dart';

class RemittanceScreen extends StatelessWidget {
  RemittanceScreen({super.key});

  final controller = Get.put(RemittanceController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        backgroundColor: TransferTokens.scaffoldBg,
        appBar: const TransferAppBar(
          titleKey: Strings.remittance,
          subtitleKey: Strings.receivingMethod,
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
        _countryCard(context),
        _detailsCard(context),
        _amountCard(context),
        _limitsCard(),
      ],
    );
  }

  //! ─────────────────────────────  Countries  ─────────────────────────────
  Widget _countryCard(BuildContext context) {
    return SectionCard(
      titleKey: Strings.selectCountry,
      icon: Icons.public_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FieldLabel(Strings.sendingCountry),
          Obx(
            () => SelectorField(
              leadingIcon: Icons.flight_takeoff_rounded,
              value: controller.selectedSendingCountry.value,
              badge: controller.selectedSendingCountryCode.value,
              onTap: () => _pickSendingCountry(context),
            ),
          ),
          const FlowDivider(),
          const FieldLabel(Strings.receivingCountry),
          Obx(
            () => SelectorField(
              leadingIcon: Icons.flight_land_rounded,
              value: controller.selectedReceivingCountry.value,
              badge: controller.selectedReceivingCountryCode.value,
              onTap: () => _pickReceivingCountry(context),
            ),
          ),
        ],
      ),
    );
  }

  void _pickSendingCountry(BuildContext context) {
    showTransferPicker<Country>(
      context: context,
      titleKey: Strings.sendingCountry,
      items: controller.sendingCountryList,
      labelOf: (c) => c.country,
      badgeOf: (c) => c.code,
      onSelected: (value) {
        controller.selectedSendingCountry.value = value.country;
        controller.sendingCountryId.value = value.id;
        controller.selectedSendingCountryCode.value = value.code;
        controller.fromCountriesRate.value = value.rate;
        controller.fromCountriesType.value = value.type;
        controller.recipientGet;
        controller.getRate();
      },
    );
  }

  void _pickReceivingCountry(BuildContext context) {
    showTransferPicker<Country>(
      context: context,
      titleKey: Strings.receivingCountry,
      items: controller.receivingCountryList,
      labelOf: (c) => c.country,
      badgeOf: (c) => c.code,
      onSelected: (value) {
        controller.selectedReceivingCountry.value = value.country;
        controller.receivingCountryId.value = value.id;
        controller.selectedReceivingCountryCode.value = value.code;
        controller.toCountriesRate.value = value.rate;
        controller.recipientGet;
        controller.remittanceGetRecipientProcess();
        controller.getRate();
      },
    );
  }

  //! ─────────────────────────  Method + Recipient  ────────────────────────
  Widget _detailsCard(BuildContext context) {
    return SectionCard(
      titleKey: Strings.receivingMethod,
      icon: Icons.tune_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FieldLabel(Strings.receivingMethod),
          Obx(
            () => SelectorField(
              leadingIcon: Icons.account_balance_rounded,
              value: controller.selectedMethod.value,
              onTap: () => _pickMethod(context),
            ),
          ),
          const SizedBox(height: 16),
          const FieldLabel(Strings.recipient),
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => SelectorField(
                    leadingIcon: Icons.person_outline_rounded,
                    value: controller.selectedRecipient.value,
                    onTap: () => _pickRecipient(context),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _addRecipientButton(),
            ],
          ),
        ],
      ),
    );
  }

  void _pickMethod(BuildContext context) {
    showTransferPicker<TransactionType>(
      context: context,
      titleKey: Strings.receivingMethod,
      items: controller.transactionTypeList,
      labelOf: (t) => t.labelName,
      onSelected: (value) {
        controller.selectedMethod.value = value.labelName;
        controller.selectedTrxType.value = value.fieldName;
        controller.remittanceGetRecipientProcess();
      },
    );
  }

  void _pickRecipient(BuildContext context) {
    showTransferPicker<RecipientInfo>(
      context: context,
      titleKey: Strings.recipient,
      items: controller.recipientList,
      labelOf: (r) => "${r.firstname} ${r.lastname}",
      subtitleOf: (r) => r.mobile,
      onSelected: (value) {
        controller.selectedRecipient.value =
            "${value.firstname} ${value.lastname}";
        controller.selectedRecipientId.value = value.id;
      },
    );
  }

  Widget _addRecipientButton() {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.addRecipientScreen),
      child: Container(
        height: 52,
        width: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: TransferTokens.brand,
          borderRadius: BorderRadius.circular(TransferTokens.radius),
        ),
        child: const Icon(
          Icons.person_add_alt_1_rounded,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }

  //! ──────────────────────────────  Amount  ───────────────────────────────
  Widget _amountCard(BuildContext context) {
    return SectionCard(
      titleKey: Strings.amount,
      icon: Icons.payments_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FieldLabel(Strings.amount),
          TransferTextField(
            controller: controller.amountController,
            hintKey: Strings.zero00,
            bigText: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [DecimalTextInputFormatter()],
            onChanged: (_) => _onAmountChanged(),
            suffix: Obx(
              () => CurrencyPill(
                code: controller.selectedSendingCountryCode.value,
              ),
            ),
          ),
          const SizedBox(height: 14),
          _feeSummary(),
          const FlowDivider(),
          const FieldLabel(Strings.recipientGet),
          TransferTextField(
            controller: controller.recipientGetController,
            hintKey: Strings.zero00,
            bigText: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [DecimalTextInputFormatter()],
            onChanged: (_) => controller.senderSendAmount,
            suffix: Obx(
              () => CurrencyPill(
                code: controller.selectedReceivingCountryCode.value,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onAmountChanged() {
    if (controller.amountController.text.isEmpty) {
      controller.amountController.text = "";
    } else {
      controller.remainingController.senderAmount.value =
          controller.amountController.text;
      controller.remainingController.getRemainingBalanceProcess();
    }
    controller.recipientGet;
    controller.getFee(rate: controller.fromCountriesRate.value);
  }

  Widget _feeSummary() {
    return Obx(() {
      final currency = controller.selectedSendingCountryCode.value;
      final precision = controller.fromCountriesType.value == 'FIAT'
          ? LocalStorages.getFiatPrecision()
          : LocalStorages.getCryptoPrecision();
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: TransferTokens.field,
          borderRadius: BorderRadius.circular(TransferTokens.radius),
          border: Border.all(color: TransferTokens.border),
        ),
        child: Column(
          children: [
            if (controller.selectedTrxType.value == 'bank-transfer')
              StatRow(
                labelKey: Strings.exchangeRate,
                value:
                    "1 $currency = ${controller.exchangeRate.value.toStringAsFixed(precision)} ${controller.selectedReceivingCountryCode.value}",
              ),
            StatRow(
              labelKey: Strings.totalFee,
              value:
                  "${controller.totalFee.value.toStringAsFixed(precision)} $currency",
              emphasize: true,
            ),
            StatRow(
              labelKey: Strings.transactionLimit,
              value:
                  "${controller.minLimit.value.toStringAsFixed(precision)} - ${controller.maxLimit.value.toStringAsFixed(precision)} $currency",
            ),
          ],
        ),
      );
    });
  }

  //! ──────────────────────────────  Limits  ───────────────────────────────
  Widget _limitsCard() {
    return Obx(() {
      final currency = controller.selectedSendingCountryCode.value;
      final precision = controller.fromCountriesType.value == 'FIAT'
          ? LocalStorages.getFiatPrecision()
          : LocalStorages.getCryptoPrecision();
      final showDaily = controller.dailyLimit.value != 0.0;
      final showMonthly = controller.monthlyLimit.value != 0.0;
      if (!showDaily && !showMonthly) return const SizedBox.shrink();

      String fmt(double v) => '${v.toStringAsFixed(precision)} $currency';

      return SectionCard(
        titleKey: Strings.limitInformation,
        icon: Icons.shield_outlined,
        child: Column(
          children: [
            if (showDaily) ...[
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
              if (showDaily) const Divider(height: 18),
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
    return amount > 0 &&
        amount <= controller.dailyLimit.value &&
        amount <= controller.monthlyLimit.value;
  }

  Widget _bottomBar(BuildContext context) {
    return StickyBottomBar(
      child: Obx(
        () => GradientButton(
          labelKey: Strings.send,
          enabled: _canSend,
          onTap: () {
            Get.find<SetUpPinController>().showPinDialog(
              context,
              onSuccess: () {
                controller.togoRemittancePreview();
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
