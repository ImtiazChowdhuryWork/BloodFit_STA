import 'dart:convert';

class HasMealImageModel {
    bool? success;
    int? status;
    String? message;
    HasMealImageCheckingData? data;

    HasMealImageModel({
        this.success,
        this.status,
        this.message,
        this.data,
    });

    factory HasMealImageModel.fromRawJson(String str) => HasMealImageModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory HasMealImageModel.fromJson(Map<String, dynamic> json) => HasMealImageModel(
        success: json["success"],
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : HasMealImageCheckingData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };
}

class HasMealImageCheckingData {
    String? id;
    String? mealId;
    String? imgRef;
    int? v;

    HasMealImageCheckingData({
        this.id,
        this.mealId,
        this.imgRef,
        this.v,
    });

    factory HasMealImageCheckingData.fromRawJson(String str) => HasMealImageCheckingData.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory HasMealImageCheckingData.fromJson(Map<String, dynamic> json) => HasMealImageCheckingData(
        id: json["_id"],
        mealId: json["mealId"],
        imgRef: json["imgRef"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "mealId": mealId,
        "imgRef": imgRef,
        "__v": v,
    };
}
