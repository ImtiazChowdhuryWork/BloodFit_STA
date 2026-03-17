import 'dart:convert';

class BillingSummeryModel {
    bool? success;
    int? status;
    String? message;
    Data? data;

    BillingSummeryModel({
        this.success,
        this.status,
        this.message,
        this.data,
    });

    factory BillingSummeryModel.fromRawJson(String str) => BillingSummeryModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory BillingSummeryModel.fromJson(Map<String, dynamic> json) => BillingSummeryModel(
        success: json["success"],
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    String? planName;
    double? price;
    String? billing;
    DateTime? date;
    double? totalPrice;

    Data({
        this.planName,
        this.price,
        this.billing,
        this.date,
        this.totalPrice,
    });

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        planName: json["planName"],
        price: json["price"]?.toDouble(),
        billing: json["billing"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        totalPrice: json["totalPrice"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "planName": planName,
        "price": price,
        "billing": billing,
        "date": date?.toIso8601String(),
        "totalPrice": totalPrice,
    };
}
