import 'dart:convert';

class WeightProgressShowingModel {
    bool? success;
    int? status;
    String? message;
    Data? data;

    WeightProgressShowingModel({
        this.success,
        this.status,
        this.message,
        this.data,
    });

    factory WeightProgressShowingModel.fromRawJson(String str) => WeightProgressShowingModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory WeightProgressShowingModel.fromJson(Map<String, dynamic> json) => WeightProgressShowingModel(
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
    int? initialWeight;
    int? currentWeight;
    int? desiredWeight;

    Data({
        this.initialWeight,
        this.currentWeight,
        this.desiredWeight,
    });

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        initialWeight: json["initialWeight"],
        currentWeight: json["currentWeight"],
        desiredWeight: json["desiredWeight"],
    );

    Map<String, dynamic> toJson() => {
        "initialWeight": initialWeight,
        "currentWeight": currentWeight,
        "desiredWeight": desiredWeight,
    };
}
