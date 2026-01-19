import 'dart:convert';

class FaqScreenModel {
  bool? success;
  int? status;
  String? message;
  List<Datum>? data;

  FaqScreenModel({this.success, this.status, this.message, this.data});

  factory FaqScreenModel.fromRawJson(String str) =>
      FaqScreenModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FaqScreenModel.fromJson(Map<String, dynamic> json) => FaqScreenModel(
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
  String? question;
  String? answer;
  int? v;

  Datum({this.id, this.question, this.answer, this.v});

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"],
    question: json["question"],
    answer: json["answer"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "question": question,
    "answer": answer,
    "__v": v,
  };
}
