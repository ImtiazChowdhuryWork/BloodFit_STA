import 'dart:convert';

class UpdateCurrentWeightModel {
  bool? success;
  int? status;
  String? message;
  List<Datum>? data;

  UpdateCurrentWeightModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  factory UpdateCurrentWeightModel.fromRawJson(String str) =>
      UpdateCurrentWeightModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateCurrentWeightModel.fromJson(Map<String, dynamic> json) =>
      UpdateCurrentWeightModel(
        success: json["success"],
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
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

class Datum {
  String? id;
  String? userId;
  int? weight;
  DateTime? date;
  int? v;

  Datum({this.id, this.userId, this.weight, this.date, this.v});

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
