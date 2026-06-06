class DashboardModel {
  // final Message message;
  final Data data;

  DashboardModel({
    // required this.message,
    required this.data,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
        // message: Message.fromJson(json["message"]),
        data: Data.fromJson(json["data"]),
      );
}

class Data {
  final PusherCredentials pusherCredentials;
  // final String baseCurr;
  // List<AgentWallet> agentWallet;
  // final String baseUrl;
  // final String defaultImage;
  // final String imagePath;
  final ModuleAccess moduleAccess;
  final Agent agent;
  final bool pinVerification;
  // final String totalAddMoney;
  // final String totalWithdrawMoney;
  // final String totalSendMoney;
  // final String totalMoneyIn;
  final String totalReceiveMoney;
  // final String totalSendRemittance;
  // final String billPay;
  // final String topUps;
  // final int totalTransaction;
  final String agentProfits;
  final List<Transaction> transactions;

  Data({
    required this.pusherCredentials,
    // required this.baseCurr,
    // required this.agentWallet,
    // required this.baseUrl,
    // required this.defaultImage,
    // required this.imagePath,
    required this.moduleAccess,
    required this.agent,
    required this.pinVerification,
    // required this.totalAddMoney,
    // required this.totalWithdrawMoney,
    // required this.totalSendMoney,
    // required this.totalMoneyIn,
    required this.totalReceiveMoney,
    // required this.totalSendRemittance,
    // required this.billPay,
    // required this.topUps,
    // required this.totalTransaction,
    required this.agentProfits,
    required this.transactions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        pusherCredentials:
            PusherCredentials.fromJson(json["pusher_credentials"]),
        // baseCurr: json["base_curr"],
        // agentWallet: List<AgentWallet>.from(
        //     json["userWallets"].map((x) => AgentWallet.fromJson(x))),
        // baseUrl: json["base_url"],
        // defaultImage: json["default_image"],
        // imagePath: json["image_path"],
        moduleAccess: ModuleAccess.fromJson(json["module_access"]),
        agent: Agent.fromJson(json["agent"]),
        // totalAddMoney: json["totalAddMoney"],
        // totalWithdrawMoney: json["totalWithdrawMoney"],
        // totalSendMoney: json["totalSendMoney"],
        // totalMoneyIn: json["totalMoneyIn"],
        totalReceiveMoney: json["totalReceiveMoney"],
        pinVerification: json["pin_verification"],
        // totalSendRemittance: json["totalSendRemittance"],
        // billPay: json["billPay"],
        // topUps: json["topUps"],
        // totalTransaction: json["total_transaction"],
        agentProfits: json["agent_profits"],
        transactions: List<Transaction>.from(
            json["transactions"].map((x) => Transaction.fromJson(x))),
      );
}

class Agent {
  final int kycVerified;
  final bool pinStatus;

  Agent({
    required this.kycVerified,
    required this.pinStatus,
  });

  factory Agent.fromJson(Map<String, dynamic> json) => Agent(
        kycVerified: json["kyc_verified"],
        pinStatus: json["pin_status"],
      );
}

class ModuleAccess {
  final bool receiveMoney;
  final bool addMoney;
  final bool withdrawMoney;
  final bool transferMoney;
  final bool moneyIn;
  final bool billPay;
  final bool mobileTopUp;
  final bool remittanceMoney;

  ModuleAccess({
    required this.receiveMoney,
    required this.addMoney,
    required this.withdrawMoney,
    required this.transferMoney,
    required this.moneyIn,
    required this.billPay,
    required this.mobileTopUp,
    required this.remittanceMoney,
  });

  factory ModuleAccess.fromJson(Map<String, dynamic> json) => ModuleAccess(
        receiveMoney: json["receive_money"],
        addMoney: json["add_money"],
        withdrawMoney: json["withdraw_money"],
        transferMoney: json["transfer_money"],
        moneyIn: json["money_in"],
        billPay: json["bill_pay"],
        mobileTopUp: json["mobile_top_up"],
        remittanceMoney: json["remittance_money"],
      );

  Map<String, dynamic> toJson() => {
        "receive_money": receiveMoney,
        "add_money": addMoney,
        "withdraw_money": withdrawMoney,
        "transfer_money": transferMoney,
        "money_in": moneyIn,
        "bill_pay": billPay,
        "mobile_top_up": mobileTopUp,
        "remittance_money": remittanceMoney,
      };
}

class Transaction {
  final String trx;
  final String transactionType;
  final String requestAmount;
  final String payable;
  final String status;
  final DateTime dateTime;

  Transaction({
    required this.trx,
    required this.transactionType,
    required this.requestAmount,
    required this.payable,
    required this.status,
    // required this.remark,
    required this.dateTime,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        trx: json["trx"],
        transactionType: json["transaction_type"],
        requestAmount: json["request_amount"],
        payable: json["payable"],
        status: json["status"],
        dateTime: DateTime.parse(json["date_time"]),
      );
}

class PusherCredentials {
  final String instanceId;
  final String secretKey;

  PusherCredentials({
    required this.instanceId,
    required this.secretKey,
  });

  factory PusherCredentials.fromJson(Map<String, dynamic> json) =>
      PusherCredentials(
        instanceId: json["instanceId"],
        secretKey: json["secretKey"],
      );
}