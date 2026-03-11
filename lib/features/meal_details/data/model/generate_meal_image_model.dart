import 'dart:convert';

class GenerateMealImageModel {
    bool? success;
    int? status;
    String? message;
    MealImageData? data;

    GenerateMealImageModel({
        this.success,
        this.status,
        this.message,
        this.data,
    });

    factory GenerateMealImageModel.fromRawJson(String str) => GenerateMealImageModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GenerateMealImageModel.fromJson(Map<String, dynamic> json) => GenerateMealImageModel(
        success: json["success"],
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : MealImageData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };
}

class MealImageData {
    String? mealImageBase64;

    MealImageData({
        this.mealImageBase64,
    });

    factory MealImageData.fromRawJson(String str) => MealImageData.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MealImageData.fromJson(Map<String, dynamic> json) => MealImageData(
        mealImageBase64: json["meal_image_base64"],
    );

    Map<String, dynamic> toJson() => {
        "meal_image_base64": mealImageBase64,
    };
}
