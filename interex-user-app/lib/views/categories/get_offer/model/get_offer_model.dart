// class GetOfferModel {
//   Data? data;
//
//   GetOfferModel({this.data});
//
//   GetOfferModel.fromJson(Map<String, dynamic> json) {
//     data = json['data'] != null ? new Data.fromJson(json['data']) : null;
//   }
// }
//
// /*
// // Example Usage
// Map<String, dynamic> map = jsonDecode(<myJSONString>);
// var myRootNode = Root.fromJson(map);
// */
class Data {
  String? defaultimage;
  String? imagepath;
  List<GetOffer?>? getoffers;

  Data({this.defaultimage, this.imagepath, this.getoffers});

  Data.fromJson(Map<String, dynamic> json) {
    defaultimage = json['default_image'];
    imagepath = json['image_path'];
    if (json['get_offers'] != null) {
      getoffers = <GetOffer>[];
      json['get_offers'].forEach((v) {
        getoffers!.add(GetOffer.fromJson(v));
      });
    }
  }
}

class GetOffer {
  int? id;
  String? type;
  String? amount;
  String? salecurrencycode;
  String? rate;
  String? ratecurrencycode;
  int? creatorid;
  int? tradeuserid;
  int? receiverid;
  int? tradeid;
  int? status;
  DateTime? offercreated;
  String? creatorimage;
  int? emailverified;
  int? kycverified;
  String? creatorname;
  String? tradeamount;
  String? traderate;
  int? tradestatus;
  String? acceptStatus;
  String? rejectStatus;
  String? counterStatus;
  String? pay;
  String? statusString;

  GetOffer({
    this.id,
    this.type,
    this.amount,
    this.salecurrencycode,
    this.rate,
    this.ratecurrencycode,
    this.creatorid,
    this.tradeuserid,
    this.receiverid,
    this.tradeid,
    this.status,
    this.offercreated,
    this.creatorimage,
    this.emailverified,
    this.kycverified,
    this.creatorname,
    this.tradeamount,
    this.traderate,
    this.tradestatus,
    this.acceptStatus,
    this.rejectStatus,
    this.counterStatus,
    this.pay,
    this.statusString,
  });

  GetOffer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    amount = json['amount'];
    salecurrencycode = json['sale_currency_code'];
    rate = json['rate'];
    ratecurrencycode = json['rate_currency_code'];
    creatorid = json['creator_id'];
    tradeuserid = json['trade_user_id'];
    receiverid = json['receiver_id'];
    tradeid = json['trade_id '];
    status = json['status'];
    offercreated = DateTime.parse(json['offer_created']);
    creatorimage = json['creator_image'];
    emailverified = json['email_verified'];
    kycverified = json['kyc_verified'];
    creatorname = json['creator_name'];
    tradeamount = json['trade_amount'];
    traderate = json['trade_rate'];
    tradestatus = json['trade_status'];
    acceptStatus = json['acceptStatus'];
    rejectStatus = json['rejectStatus'];
    counterStatus = json['counterStatus'];
    pay = json['pay'];
    statusString = json['statusString'];
  }
}

class GetOfferModel {
  Data? data;

  GetOfferModel({this.data});

  GetOfferModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data?.fromJson(json['data']) : null;
  }
}
