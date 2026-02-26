import 'dart:convert';

class AiSuggestedMealsJobIdModel {
    bool? success;
    int? status;
    String? message;
    Data? data;

    AiSuggestedMealsJobIdModel({
        this.success,
        this.status,
        this.message,
        this.data,
    });

    factory AiSuggestedMealsJobIdModel.fromRawJson(String str) => AiSuggestedMealsJobIdModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory AiSuggestedMealsJobIdModel.fromJson(Map<String, dynamic> json) => AiSuggestedMealsJobIdModel(
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
    String? jobId;
    String? status;

    Data({
        this.jobId,
        this.status,
    });

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        jobId: json["jobId"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "jobId": jobId,
        "status": status,
    };
}
