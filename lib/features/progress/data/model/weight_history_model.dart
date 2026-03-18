import 'dart:convert';

class WeightHistoryModel {
  bool? success;
  int? status;
  String? message;
  List<WeightHistoryData>? data;

  WeightHistoryModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  factory WeightHistoryModel.fromRawJson(String str) =>
      WeightHistoryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WeightHistoryModel.fromJson(Map<String, dynamic> json) =>
      WeightHistoryModel(
        success: json["success"],
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<WeightHistoryData>.from(
                json["data"].map((x) => WeightHistoryData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class WeightHistoryData {
  String? id;
  String? userId;
  int? weight;
  DateTime? date;
  int? v;

  WeightHistoryData({
    this.id,
    this.userId,
    this.weight,
    this.date,
    this.v,
  });

  factory WeightHistoryData.fromRawJson(String str) =>
      WeightHistoryData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WeightHistoryData.fromJson(Map<String, dynamic> json) =>
      WeightHistoryData(
        id: json["_id"],
        userId: json["userId"],
        weight: json["weight"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "weight": weight,
        "date": date?.toIso8601String(),
        "__v": v,
      };
}
