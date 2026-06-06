class TransactionLogModel {
  Data data;

  TransactionLogModel({required this.data});

  factory TransactionLogModel.fromJson(Map<String, dynamic> json) =>
      TransactionLogModel(data: Data.fromJson(json["data"]));
}

class Data {
  TransactionTypes transactionTypes;
  Transactions transactions;

  Data({required this.transactionTypes, required this.transactions});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    transactionTypes: TransactionTypes.fromJson(json["transaction_types"]),
    transactions: Transactions.fromJson(json["transactions"]),
  );
}

class TransactionTypes {
  final String addMoney;
  final String moneyOut;
  final String transferMoney;
  final String exchangeMoney;
  final String moneyIn;
  final String agentMoneyOut;
  final String requestMoney;
  final String payLink;
  final String payUserPayLink;
  final String billPay;
  final String mobileTopUp;
  final String virtualCard;
  final String remittance;
  final String merchantPayment;
  final String makePayment;
  final String giftCards;
  final String addSubBalance;
  final String referBonus;
  final String registerBonus;
  final String trade;
  final String marketplace;

  TransactionTypes({
    required this.addMoney,
    required this.moneyOut,
    required this.transferMoney,
    required this.exchangeMoney,
    required this.moneyIn,
    required this.agentMoneyOut,
    required this.requestMoney,
    required this.payLink,
    required this.payUserPayLink,
    required this.billPay,
    required this.mobileTopUp,
    required this.virtualCard,
    required this.remittance,
    required this.merchantPayment,
    required this.makePayment,
    required this.giftCards,
    required this.addSubBalance,
    required this.referBonus,
    required this.registerBonus,
    required this.trade,
    required this.marketplace,
  });

  factory TransactionTypes.fromJson(Map<String, dynamic> json) =>
      TransactionTypes(
        addMoney: json["add_money"],
        moneyOut: json["money_out"],
        transferMoney: json["transfer_money"],
        exchangeMoney: json["exchange_money"],
        moneyIn: json["money_in"],
        agentMoneyOut: json["agent_money_out"],
        requestMoney: json["request_money"],
        payLink: json["pay_link"],
        payUserPayLink: json["pay_user_pay_link"],
        billPay: json["bill_pay"],
        mobileTopUp: json["mobile_top_up"],
        virtualCard: json["virtual_card"],
        remittance: json["remittance"],
        merchantPayment: json["merchant-payment"],
        makePayment: json["make_payment"],
        giftCards: json["gift_cards"],
        addSubBalance: json["add_sub_balance"],
        referBonus: json["refer_bonus"],
        registerBonus: json["register_bonus"],
        trade: json["trade"],
        marketplace: json["marketplace"],
      );
}

class Transactions {
  List<BillPay> billPay;
  List<MobileTopUp> mobileTopUp;
  List<AddMoney> addMoney;
  List<MoneyOut> moneyOut;
  List<AgentMoneyOut> agentMoneyOut;
  List<SendMoney> sendMoney;
  List<VirtualCard> virtualCard;
  List<Remittance> remittance;
  List<MerchantPayment> merchantPayment;
  List<MakePayment> makePayment;
  List<AddSubBalance> addSubBalance;
  List<PayPayLink> payLink;
  List<PayUserPayLink> payUserPayLink;
  List<ExchangeMoney> exchangeMoney;

  /// New
  final List<dynamic> moneyIn; // Need to add model
  final List<RequestMoney> requestMoney; // Add in transaction please
  final List<dynamic> giftCards; // Need to add model
  final List<ReferBonus> referBonus; // Add in transaction please
  final List<dynamic> registerBonus; // Need to add model
  final List<Marketplace> trade;
  final List<Marketplace> marketplace;

  Transactions({
    required this.billPay,
    required this.mobileTopUp,
    required this.addMoney,
    required this.moneyOut,
    required this.agentMoneyOut,
    required this.sendMoney,
    required this.virtualCard,
    required this.remittance,
    required this.merchantPayment,
    required this.makePayment,
    required this.addSubBalance,
    required this.payLink,
    required this.payUserPayLink,
    required this.exchangeMoney,

    /// New
    required this.moneyIn,
    required this.requestMoney,
    required this.giftCards,
    required this.referBonus,
    required this.registerBonus,
    required this.trade,
    required this.marketplace,
  });

  factory Transactions.fromJson(Map<String, dynamic> json) => Transactions(
    billPay: List<BillPay>.from(
      json["bill_pay"].map((x) => BillPay.fromJson(x)),
    ),
    mobileTopUp: List<MobileTopUp>.from(
      json["mobile_top_up"].map((x) => MobileTopUp.fromJson(x)),
    ),
    addMoney: List<AddMoney>.from(
      json["add_money"].map((x) => AddMoney.fromJson(x)),
    ),
    moneyOut: List<MoneyOut>.from(
      json["money_out"].map((x) => MoneyOut.fromJson(x)),
    ),
    agentMoneyOut: List<AgentMoneyOut>.from(
      json["agent_money_out"].map((x) => AgentMoneyOut.fromJson(x)),
    ),
    sendMoney: List<SendMoney>.from(
      json["send_money"].map((x) => SendMoney.fromJson(x)),
    ),
    virtualCard: List<VirtualCard>.from(
      json["virtual_card"].map((x) => VirtualCard.fromJson(x)),
    ),
    remittance: List<Remittance>.from(
      json["remittance"].map((x) => Remittance.fromJson(x)),
    ),
    merchantPayment: List<MerchantPayment>.from(
      json["merchant_payment"].map((x) => MerchantPayment.fromJson(x)),
    ),
    makePayment: List<MakePayment>.from(
      json["make_payment"].map((x) => MakePayment.fromJson(x)),
    ),
    addSubBalance: List<AddSubBalance>.from(
      json["add_sub_balance"].map((x) => AddSubBalance.fromJson(x)),
    ),
    payLink: List<PayPayLink>.from(
      json["pay_link"].map((x) => PayPayLink.fromJson(x)),
    ),
    payUserPayLink: List<PayUserPayLink>.from(
      json["pay_user_pay_link"].map((x) => PayUserPayLink.fromJson(x)),
    ),
    exchangeMoney: List<ExchangeMoney>.from(
      json["exchange_money"].map((x) => ExchangeMoney.fromJson(x)),
    ),

    /// New
    moneyIn: List<dynamic>.from(json["money_in"].map((x) => x)),
    requestMoney: List<RequestMoney>.from(
      json["request_money"].map((x) => RequestMoney.fromJson(x)),
    ),
    giftCards: List<dynamic>.from(json["gift_cards"].map((x) => x)),
    referBonus: List<ReferBonus>.from(
      json["refer_bonus"].map((x) => ReferBonus.fromJson(x)),
    ),
    registerBonus: List<dynamic>.from(json["register_bonus"].map((x) => x)),
    trade: List<Marketplace>.from(
      json["trade"].map((x) => Marketplace.fromJson(x)),
    ),
    marketplace: List<Marketplace>.from(
      json["marketplace"].map((x) => Marketplace.fromJson(x)),
    ),
  );
}

class BillPay {
  int id;
  String trx;
  String transactionType;
  String requestAmount;
  String payable;
  String billType;
  String billNumber;
  String totalCharge;
  String currentBalance;
  String status;
  DateTime dateTime;
  StatusInfo statusInfo;
  String rejectionReason;

  BillPay({
    required this.id,
    required this.trx,
    required this.transactionType,
    required this.requestAmount,
    required this.payable,
    required this.billType,
    required this.billNumber,
    required this.totalCharge,
    required this.currentBalance,
    required this.status,
    required this.dateTime,
    required this.statusInfo,
    required this.rejectionReason,
  });

  factory BillPay.fromJson(Map<String, dynamic> json) => BillPay(
    id: json["id"] ?? '',
    trx: json["trx"] ?? '',
    transactionType: json["transaction_type"] ?? '',
    requestAmount: json["request_amount"] ?? '',
    payable: json["payable"] ?? '',
    billType: json["bill_type"] ?? '',
    billNumber: json["bill_number"] ?? '',
    totalCharge: json["total_charge"] ?? '',
    currentBalance: json["current_balance"] ?? '',
    status: json["status"] ?? '',
    dateTime: DateTime.parse(json["date_time"]),
    statusInfo: StatusInfo.fromJson(json["status_info"]),
    rejectionReason: json["rejection_reason"] ?? '',
  );
}

class MobileTopUp {
  int id;
  String trx;
  String transactionType;
  String requestAmount;
  String payable;
  String topupType;
  String mobileNumber;
  String totalCharge;
  String currentBalance;
  String status;
  DateTime dateTime;
  StatusInfo statusInfo;
  String rejectionReason;

  MobileTopUp({
    required this.id,
    required this.trx,
    required this.transactionType,
    required this.requestAmount,
    required this.payable,
    required this.topupType,
    required this.mobileNumber,
    required this.totalCharge,
    required this.currentBalance,
    required this.status,
    required this.dateTime,
    required this.statusInfo,
    required this.rejectionReason,
  });

  factory MobileTopUp.fromJson(Map<String, dynamic> json) => MobileTopUp(
    id: json["id"] ?? '',
    trx: json["trx"] ?? '',
    transactionType: json["transaction_type"] ?? '',
    requestAmount: json["request_amount"] ?? '',
    payable: json["payable"] ?? '',
    topupType: json["topup_type"] ?? '',
    mobileNumber: json["mobile_number"] ?? '',
    totalCharge: json["total_charge"] ?? '',
    currentBalance: json["current_balance"] ?? '',
    status: json["status"] ?? '',
    dateTime: DateTime.parse(json["date_time"]),
    statusInfo: StatusInfo.fromJson(json["status_info"]),
    rejectionReason: json["rejection_reason"] ?? '',
  );
}

class AddMoney {
  int id;
  String trx;
  String gatewayName;
  String transactionType;
  String requestAmount;
  String payable;
  String exchangeRate;
  String totalCharge;
  String currentBalance;
  String status;
  DateTime dateTime;
  StatusInfo statusInfo;
  String rejectionReason;
  bool confirm;
  dynamic confirmUrl;
  List<DynamicInput> dynamicInputs;

  AddMoney({
    required this.id,
    required this.trx,
    required this.gatewayName,
    required this.transactionType,
    required this.requestAmount,
    required this.payable,
    required this.exchangeRate,
    required this.totalCharge,
    required this.currentBalance,
    required this.status,
    required this.dateTime,
    required this.statusInfo,
    required this.rejectionReason,
    required this.confirm,
    required this.dynamicInputs,
    required this.confirmUrl,
  });

  factory AddMoney.fromJson(Map<String, dynamic> json) => AddMoney(
    id: json["id"] ?? '',
    trx: json["trx"] ?? '',
    gatewayName: json["gateway_name"] ?? '',
    transactionType: json["transaction_type"] ?? '',
    requestAmount: json["request_amount"] ?? '',
    payable: json["payable"] ?? '',
    exchangeRate: json["exchange_rate"] ?? '',
    totalCharge: json["total_charge"] ?? '',
    currentBalance: json["current_balance"] ?? '',
    status: json["status"] ?? '',
    dateTime: DateTime.parse(json["date_time"]),
    statusInfo: StatusInfo.fromJson(json["status_info"]),
    rejectionReason: json["rejection_reason"] ?? '',
    confirm: json["confirm"] ?? false,
    confirmUrl: json["confirm_url"] ?? '',
    dynamicInputs: List<DynamicInput>.from(
      json["dynamic_inputs"].map((x) => DynamicInput.fromJson(x)),
    ),
  );
}

class MoneyOut {
  int id;
  String trx;
  String gatewayName;
  String gatewayCurrencyName;
  String transactionType;
  String requestAmount;
  String payable;
  String exchangeRate;
  String totalCharge;
  String currentBalance;
  String status;
  DateTime dateTime;
  StatusInfo statusInfo;
  String rejectionReason;

  MoneyOut({
    required this.id,
    required this.trx,
    required this.gatewayName,
    required this.gatewayCurrencyName,
    required this.transactionType,
    required this.requestAmount,
    required this.payable,
    required this.exchangeRate,
    required this.totalCharge,
    required this.currentBalance,
    required this.status,
    required this.dateTime,
    required this.statusInfo,
    required this.rejectionReason,
  });

  factory MoneyOut.fromJson(Map<String, dynamic> json) => MoneyOut(
    id: json["id"] ?? '',
    trx: json["trx"] ?? '',
    gatewayName: json["gateway_name"] ?? '',
    gatewayCurrencyName: json["gateway_currency_name"] ?? '',
    transactionType: json["transaction_type"] ?? '',
    requestAmount: json["request_amount"] ?? '',
    payable: json["payable"] ?? '',
    exchangeRate: json["exchange_rate"] ?? '',
    totalCharge: json["total_charge"] ?? '',
    currentBalance: json["current_balance"] ?? '',
    status: json["status"] ?? '',
    dateTime: DateTime.parse(json["date_time"]),
    statusInfo: StatusInfo.fromJson(json["status_info"]),
    rejectionReason: json["rejection_reason"] ?? '',
  );
}

class SendMoney {
  int id;
  String type;
  String trx;
  String transactionType;
  String transactionHeading;
  String requestAmount;
  String totalCharge;
  String payable;
  String recipientReceived;
  String currentBalance;
  String status;
  DateTime dateTime;
  StatusInfo statusInfo;

  SendMoney({
    required this.id,
    required this.type,
    required this.trx,
    required this.transactionType,
    required this.transactionHeading,
    required this.requestAmount,
    required this.totalCharge,
    required this.payable,
    required this.recipientReceived,
    required this.currentBalance,
    required this.status,
    required this.dateTime,
    required this.statusInfo,
  });

  factory SendMoney.fromJson(Map<String, dynamic> json) => SendMoney(
    id: json["id"] ?? '',
    type: json["type"] ?? '',
    trx: json["trx"] ?? '',
    transactionType: json["transaction_type"] ?? '',
    transactionHeading: json["transaction_heading"] ?? '',
    requestAmount: json["request_amount"] ?? '',
    totalCharge: json["total_charge"] ?? '',
    payable: json["payable"] ?? '',
    recipientReceived: json["recipient_received"] ?? '',
    currentBalance: json["current_balance"] ?? '',
    status: json["status"] ?? '',
    dateTime: DateTime.parse(json["date_time"]),
    statusInfo: StatusInfo.fromJson(json["status_info"]),
  );
}

class AgentMoneyOut {
  int id;
  String type;
  String trx;
  String transactionType;
  String transactionHeading;
  String requestAmount;
  String totalCharge;
  String payable;
  String recipientReceived;
  String currentBalance;
  String status;
  DateTime dateTime;
  StatusInfo statusInfo;

  AgentMoneyOut({
    required this.id,
    required this.type,
    required this.trx,
    required this.transactionType,
    required this.transactionHeading,
    required this.requestAmount,
    required this.totalCharge,
    required this.payable,
    required this.recipientReceived,
    required this.currentBalance,
    required this.status,
    required this.dateTime,
    required this.statusInfo,
  });

  factory AgentMoneyOut.fromJson(Map<String, dynamic> json) => AgentMoneyOut(
    id: json["id"] ?? '',
    type: json["type"] ?? '',
    trx: json["trx"] ?? '',
    transactionType: json["transaction_type"] ?? '',
    transactionHeading: json["transaction_heading"] ?? '',
    requestAmount: json["request_amount"] ?? '',
    totalCharge: json["total_charge"] ?? '',
    payable: json["payable"] ?? '',
    recipientReceived: json["recipient_received"] ?? '',
    currentBalance: json["current_balance"] ?? '',
    status: json["status"] ?? '',
    dateTime: DateTime.parse(json["date_time"]),
    statusInfo: StatusInfo.fromJson(json["status_info"]),
  );
}

class VirtualCard {
  int id;
  String trx;
  String transactionType;
  String requestAmount;
  String payable;
  String totalCharge;
  String cardAmount;
  String cardNumber;
  String currentBalance;
  String status;
  DateTime dateTime;
  StatusInfo statusInfo;

  VirtualCard({
    required this.id,
    required this.trx,
    required this.transactionType,
    required this.requestAmount,
    required this.payable,
    required this.totalCharge,
    required this.cardAmount,
    required this.cardNumber,
    required this.currentBalance,
    required this.status,
    required this.dateTime,
    required this.statusInfo,
  });

  factory VirtualCard.fromJson(Map<String, dynamic> json) => VirtualCard(
    id: json["id"] ?? '',
    trx: json["trx"] ?? '',
    transactionType: json["transaction_type"] ?? '',
    requestAmount: json["request_amount"] ?? '',
    payable: json["payable"] ?? '',
    totalCharge: json["total_charge"] ?? '',
    cardAmount: json["card_amount"] ?? '',
    cardNumber: json["card_number"] ?? '',
    currentBalance: json["current_balance"] ?? '',
    status: json["status"] ?? '',
    dateTime: DateTime.parse(json["date_time"]),
    statusInfo: StatusInfo.fromJson(json["status_info"]),
  );
}

class Remittance {
  int id;
  String type;
  String trx;
  String transactionType;
  String transactionHeading;
  String requestAmount;
  String totalCharge;
  String exchangeRate;
  String payable;
  String sendingCountry;
  String receivingCountry;
  String receipientName;
  String remittanceType;
  String remittanceTypeName;
  String receipientGet;
  String bankName;
  String currentBalance;
  String status;
  DateTime dateTime;
  StatusInfo statusInfo;
  String rejectionReason;

  Remittance({
    required this.id,
    required this.type,
    required this.trx,
    required this.transactionType,
    required this.transactionHeading,
    required this.requestAmount,
    required this.totalCharge,
    required this.exchangeRate,
    required this.payable,
    required this.sendingCountry,
    required this.receivingCountry,
    required this.receipientName,
    required this.remittanceType,
    required this.remittanceTypeName,
    required this.receipientGet,
    required this.bankName,
    required this.currentBalance,
    required this.status,
    required this.dateTime,
    required this.statusInfo,
    required this.rejectionReason,
  });

  factory Remittance.fromJson(Map<String, dynamic> json) => Remittance(
    id: json["id"] ?? '',
    type: json["type"] ?? '',
    trx: json["trx"] ?? '',
    transactionType: json["transaction_type"] ?? '',
    transactionHeading: json["transaction_heading"] ?? '',
    requestAmount: json["request_amount"] ?? '',
    totalCharge: json["total_charge"] ?? '',
    exchangeRate: json["exchange_rate"] ?? '',
    payable: json["payable"] ?? '',
    sendingCountry: json["sending_country"] ?? '',
    receivingCountry: json["receiving_country"] ?? '',
    receipientName: json["receipient_name"] ?? '',
    remittanceType: json["remittance_type"] ?? '',
    remittanceTypeName: json["remittance_type_name"] ?? '',
    receipientGet: json["receipient_get"] ?? '',
    bankName: json["bank_name"] ?? '',
    currentBalance: json["current_balance"] ?? '',
    status: json["status"] ?? '',
    dateTime: DateTime.parse(json["date_time"]),
    statusInfo: StatusInfo.fromJson(json["status_info"]),
    rejectionReason: json["rejection_reason"] ?? '',
  );
}

class MakePayment {
  int id;
  String type;
  String trx;
  String transactionType;
  String transactionHeading;
  String requestAmount;
  String totalCharge;
  String payable;
  String recipientReceived;
  String currentBalance;
  String status;
  DateTime dateTime;
  StatusInfo statusInfo;

  MakePayment({
    required this.id,
    required this.type,
    required this.trx,
    required this.transactionType,
    required this.transactionHeading,
    required this.requestAmount,
    required this.totalCharge,
    required this.payable,
    required this.recipientReceived,
    required this.currentBalance,
    required this.status,
    required this.dateTime,
    required this.statusInfo,
  });

  factory MakePayment.fromJson(Map<String, dynamic> json) => MakePayment(
    id: json["id"] ?? '',
    type: json["type"] ?? '',
    trx: json["trx"] ?? '',
    transactionType: json["transaction_type"] ?? '',
    transactionHeading: json["transaction_heading"] ?? '',
    requestAmount: json["request_amount"] ?? '',
    totalCharge: json["total_charge"] ?? '',
    payable: json["payable"] ?? '',
    recipientReceived: json["recipient_received"] ?? '',
    currentBalance: json["current_balance"] ?? '',
    status: json["status"] ?? '',
    dateTime: DateTime.parse(json["date_time"]),
    statusInfo: StatusInfo.fromJson(json["status_info"]),
  );
}

class AddSubBalance {
  int id;
  String trx;
  String transactionType;
  String transactionHeading;
  String requestAmount;
  String currentBalance;
  String receiveAmount;
  dynamic deductedAmount;
  dynamic operationType;
  String exchangeRate;
  String totalCharge;
  String remark;
  String status;
  DateTime dateTime;
  StatusInfo statusInfo;

  AddSubBalance({
    required this.id,
    required this.trx,
    required this.transactionType,
    required this.transactionHeading,
    required this.requestAmount,
    required this.currentBalance,
    required this.receiveAmount,
    this.deductedAmount,
    this.operationType,
    required this.exchangeRate,
    required this.totalCharge,
    required this.remark,
    required this.status,
    required this.dateTime,
    required this.statusInfo,
  });

  factory AddSubBalance.fromJson(Map<String, dynamic> json) => AddSubBalance(
    id: json["id"] ?? '',
    trx: json["trx"] ?? '',
    transactionType: json["transaction_type"] ?? '',
    transactionHeading: json["transaction_heading"] ?? '',
    requestAmount: json["request_amount"] ?? '',
    currentBalance: json["current_balance"] ?? '',
    deductedAmount: json["deducted_amount"] ?? '',
    operationType: json["operation_type"] ?? '',
    receiveAmount: json["receive_amount"] ?? '',
    exchangeRate: json["exchange_rate"] ?? '',
    totalCharge: json["total_charge"] ?? '',
    remark: json["remark"] ?? '',
    status: json["status"] ?? '',
    dateTime: DateTime.parse(json["date_time"]),
    statusInfo: StatusInfo.fromJson(json["status_info"]),
  );
}

class StatusInfo {
  int success;
  int pending;
  int rejected;

  StatusInfo({
    required this.success,
    required this.pending,
    required this.rejected,
  });

  factory StatusInfo.fromJson(Map<String, dynamic> json) => StatusInfo(
    success: json["success"] ?? '',
    pending: json["pending"] ?? '',
    rejected: json["rejected"] ?? '',
  );
}

class MerchantPayment {
  int id;
  String trx;
  String transactionType;
  String transactionHeading;
  String requestAmount;
  String payable;
  String envType;
  String senderAmount;
  String recipient;
  String recipientAmount;
  String status;
  DateTime dateTime;
  StatusInfo statusInfo;
  String rejectionReason;

  MerchantPayment({
    required this.id,
    required this.trx,
    required this.transactionType,
    required this.transactionHeading,
    required this.requestAmount,
    required this.payable,
    required this.envType,
    required this.senderAmount,
    required this.recipient,
    required this.recipientAmount,
    required this.status,
    required this.dateTime,
    required this.statusInfo,
    required this.rejectionReason,
  });

  factory MerchantPayment.fromJson(Map<String, dynamic> json) =>
      MerchantPayment(
        id: json["id"] ?? '',
        trx: json["trx"] ?? '',
        transactionType: json["transaction_type"] ?? '',
        transactionHeading: json["transaction_heading"] ?? '',
        requestAmount: json["request_amount"] ?? '',
        payable: json["payable"] ?? '',
        envType: json["env_type"] ?? '',
        senderAmount: json["sender_amount"] ?? '',
        recipient: json["recipient"] ?? '',
        recipientAmount: json["recipient_amount"] ?? '',
        status: json["status"] ?? '',
        dateTime: DateTime.parse(json["date_time"]),
        statusInfo: StatusInfo.fromJson(json["status_info"]),
        rejectionReason: json["rejection_reason"] ?? '',
      );
}

class DynamicInput {
  String type;
  String label;
  String placeholder;
  String name;
  bool required;
  Validation validation;

  DynamicInput({
    required this.type,
    required this.label,
    required this.placeholder,
    required this.name,
    required this.required,
    required this.validation,
  });

  factory DynamicInput.fromJson(Map<String, dynamic> json) => DynamicInput(
    type: json["type"],
    label: json["label"],
    placeholder: json["placeholder"],
    name: json["name"],
    required: json["required"],
    validation: Validation.fromJson(json["validation"]),
  );
}

class Validation {
  String min;
  String max;
  bool required;

  Validation({required this.min, required this.max, required this.required});

  factory Validation.fromJson(Map<String, dynamic> json) => Validation(
    min: json["min"],
    max: json["max"],
    required: json["required"],
  );
}

class PayPayLink {
  final int id;
  final String trx;
  final String title;
  final String transactionType;
  final String requestAmount;
  final String payable;
  final String exchangeRate;
  final String totalCharge;
  final String currentBalance;
  final String paymentType;
  final PaymentTypeGatewayData paymentTypeGatewayData;
  final PaymentTypeCardData paymentTypeCardData;
  final PaymentTypeWalletData paymentTypeWalletData;
  final int statusValue;
  final String status;
  final DateTime dateTime;
  final StatusInfo statusInfo;

  PayPayLink({
    required this.id,
    required this.trx,
    required this.title,
    required this.transactionType,
    required this.requestAmount,
    required this.payable,
    required this.exchangeRate,
    required this.totalCharge,
    required this.currentBalance,
    required this.paymentType,
    required this.paymentTypeGatewayData,
    required this.paymentTypeCardData,
    required this.paymentTypeWalletData,
    required this.statusValue,
    required this.status,
    required this.dateTime,
    required this.statusInfo,
  });

  factory PayPayLink.fromJson(Map<String, dynamic> json) => PayPayLink(
    id: json["id"],
    trx: json["trx"],
    title: json["title"],
    transactionType: json["transaction_type"],
    requestAmount: json["request_amount"],
    payable: json["payable"],
    exchangeRate: json["exchange_rate"],
    totalCharge: json["total_charge"],
    currentBalance: json["current_balance"],
    paymentType: json["payment_type"],
    paymentTypeGatewayData: PaymentTypeGatewayData.fromJson(
      json["payment_type_gateway_data"],
    ),
    paymentTypeCardData: PaymentTypeCardData.fromJson(
      json["payment_type_card_data"],
    ),
    paymentTypeWalletData: PaymentTypeWalletData.fromJson(
      json["payment_type_wallet_data"],
    ),
    statusValue: json["status_value"],
    status: json["status"],
    dateTime: DateTime.parse(json["date_time"]),
    statusInfo: StatusInfo.fromJson(json["status_info"]),
  );
}

class PaymentTypeCardData {
  final String senderEmail;
  final String cardHolderName;
  final String senderCardLast4;

  PaymentTypeCardData({
    required this.senderEmail,
    required this.cardHolderName,
    required this.senderCardLast4,
  });

  factory PaymentTypeCardData.fromJson(Map<String, dynamic> json) =>
      PaymentTypeCardData(
        senderEmail: json["sender_email"],
        cardHolderName: json["card_holder_name"],
        senderCardLast4: json["sender_card_last4"],
      );
}

class PaymentTypeGatewayData {
  final String paymentGateway;

  PaymentTypeGatewayData({required this.paymentGateway});

  factory PaymentTypeGatewayData.fromJson(Map<String, dynamic> json) =>
      PaymentTypeGatewayData(paymentGateway: json["payment_gateway"]);
}

class PaymentTypeWalletData {
  final String senderEmail;

  PaymentTypeWalletData({required this.senderEmail});

  factory PaymentTypeWalletData.fromJson(Map<String, dynamic> json) =>
      PaymentTypeWalletData(senderEmail: json["sender_email"]);
}

class PayUserPayLink {
  final int id;
  final String trx;
  final String title;
  final String transactionType;
  final String requestAmount;
  final String payable;
  final String exchangeRate;
  final String totalCharge;
  final String currentBalance;
  final String paymentType;
  final int statusValue;
  final String status;
  final DateTime dateTime;
  final StatusInfo statusInfo;

  PayUserPayLink({
    required this.id,
    required this.trx,
    required this.title,
    required this.transactionType,
    required this.requestAmount,
    required this.payable,
    required this.exchangeRate,
    required this.totalCharge,
    required this.currentBalance,
    required this.paymentType,
    required this.statusValue,
    required this.status,
    required this.dateTime,
    required this.statusInfo,
  });

  factory PayUserPayLink.fromJson(Map<String, dynamic> json) => PayUserPayLink(
    id: json["id"],
    trx: json["trx"],
    title: json["title"],
    transactionType: json["transaction_type"],
    requestAmount: json["request_amount"],
    payable: json["payable"],
    exchangeRate: json["exchange_rate"],
    totalCharge: json["total_charge"],
    currentBalance: json["current_balance"],
    paymentType: json["payment_type"],
    statusValue: json["status_value"],
    status: json["status"],
    dateTime: DateTime.parse(json["date_time"]),
    statusInfo: StatusInfo.fromJson(json["status_info"]),
  );
}

class ExchangeMoney {
  int id;
  String type;
  String trx;
  String transactionType;
  String transactionHeading;
  String requestAmount;
  String payable;
  String exchangeRate;
  String totalCharge;
  String exchangeableAmount;
  String currentBalance;
  String status;
  int statusValue;
  DateTime dateTime;
  StatusInfo statusInfo;

  ExchangeMoney({
    required this.id,
    required this.type,
    required this.trx,
    required this.transactionType,
    required this.transactionHeading,
    required this.requestAmount,
    required this.payable,
    required this.exchangeRate,
    required this.totalCharge,
    required this.exchangeableAmount,
    required this.currentBalance,
    required this.status,
    required this.statusValue,
    required this.dateTime,
    required this.statusInfo,
  });

  factory ExchangeMoney.fromJson(Map<String, dynamic> json) => ExchangeMoney(
    id: json["id"],
    type: json["type"],
    trx: json["trx"],
    transactionType: json["transaction_type"],
    transactionHeading: json["transaction_heading"],
    requestAmount: json["request_amount"],
    payable: json["payable"],
    exchangeRate: json["exchange_rate"],
    totalCharge: json["total_charge"],
    exchangeableAmount: json["exchangeable_amount"],
    currentBalance: json["current_balance"],
    status: json["status"],
    statusValue: json["status_value"],
    dateTime: DateTime.parse(json["date_time"]),
    statusInfo: StatusInfo.fromJson(json["status_info"]),
  );
}

/// New
class Marketplace {
  final int id;
  final String trx;
  final String transactionType;
  final String method;
  final String attribute;
  final String sellingAmount;
  final String askingAmount;
  final String seller;
  final String exchangeRate;
  final String status;
  final DateTime dateTime;

  Marketplace({
    required this.id,
    required this.trx,
    required this.transactionType,
    required this.method,
    required this.attribute,
    required this.sellingAmount,
    required this.askingAmount,
    required this.seller,
    required this.exchangeRate,
    required this.status,
    required this.dateTime,
  });

  factory Marketplace.fromJson(Map<String, dynamic> json) => Marketplace(
    id: json["id"],
    trx: json["trx"],
    transactionType: json["transaction_type"],
    method: json["method"] ?? "",
    attribute: json["attribute"],
    sellingAmount: json["selling_amount"],
    askingAmount: json["asking_amount"],
    seller: json["seller"] ?? "",
    exchangeRate: json["exchange_rate"],
    status: json["status"],
    dateTime: DateTime.parse(json["date_time"]),
  );
}

class ReferBonus {
  final int id;
  final String trx;
  final String transactionType;
  final String attribute;
  final String requestAmount;
  final String payable;
  final String currentBalance;
  final String status;
  final DateTime dateTime;

  ReferBonus({
    required this.id,
    required this.trx,
    required this.transactionType,
    required this.attribute,
    required this.requestAmount,
    required this.payable,
    required this.currentBalance,
    required this.status,
    required this.dateTime,
  });

  factory ReferBonus.fromJson(Map<String, dynamic> json) => ReferBonus(
    id: json["id"],
    trx: json["trx"],
    transactionType: json["transaction_type"],
    attribute: json["attribute"],
    requestAmount: json["request_amount"],
    payable: json["payable"],
    currentBalance: json["current_balance"],
    status: json["status"],
    dateTime: DateTime.parse(json["date_time"]),
  );
}

class RequestMoney {
  final int id;
  final String title;
  final String trx;
  final String attribute;
  final String type;
  final String requestAmount;
  final String payableAmount;
  final String totalCharge;
  final String willGet;
  final String status;
  final int statusValue;
  final String remark;
  final DateTime createdAt;

  RequestMoney({
    required this.id,
    required this.title,
    required this.trx,
    required this.attribute,
    required this.type,
    required this.requestAmount,
    required this.payableAmount,
    required this.totalCharge,
    required this.willGet,
    required this.status,
    required this.statusValue,
    required this.remark,
    required this.createdAt,
  });

  factory RequestMoney.fromJson(Map<String, dynamic> json) => RequestMoney(
    id: json["id"],
    title: json["title"],
    trx: json["trx"],
    attribute: json["attribute"],
    type: json["type"],
    requestAmount: json["request_amount"],
    payableAmount: json["payable_amount"],
    totalCharge: json["total_charge"],
    willGet: json["will_get"],
    status: json["status"],
    statusValue: json["status_value"],
    remark: json["remark"],
    createdAt: DateTime.parse(json["created_at"]),
  );
}
