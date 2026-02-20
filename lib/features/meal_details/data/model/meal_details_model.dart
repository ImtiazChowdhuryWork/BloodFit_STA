import 'dart:convert';

class MealDetailsModel {
    bool? success;
    int? status;
    String? message;
    Data? data;

    MealDetailsModel({
        this.success,
        this.status,
        this.message,
        this.data,
    });

    factory MealDetailsModel.fromRawJson(String str) => MealDetailsModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MealDetailsModel.fromJson(Map<String, dynamic> json) => MealDetailsModel(
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
    String? id;
    String? userId;
    String? mealName;
    String? mealType;
    int? kcal;
    String? description;
    List<CaloryCount>? caloryCount;
    List<String>? ingredients;
    String? mealGroupId;
    String? image;
    DateTime? date;
    int? serving;
    String? status;
    int? v;

    Data({
        this.id,
        this.userId,
        this.mealName,
        this.mealType,
        this.kcal,
        this.description,
        this.caloryCount,
        this.ingredients,
        this.mealGroupId,
        this.image,
        this.date,
        this.serving,
        this.status,
        this.v,
    });

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        userId: json["userId"],
        mealName: json["mealName"],
        mealType: json["mealType"],
        kcal: json["kcal"],
        description: json["description"],
        caloryCount: json["caloryCount"] == null ? [] : List<CaloryCount>.from(json["caloryCount"]!.map((x) => CaloryCount.fromJson(x))),
        ingredients: json["ingredients"] == null ? [] : List<String>.from(json["ingredients"]!.map((x) => x)),
        mealGroupId: json["mealGroupId"],
        image: json["image"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        serving: json["serving"],
        status: json["status"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "mealName": mealName,
        "mealType": mealType,
        "kcal": kcal,
        "description": description,
        "caloryCount": caloryCount == null ? [] : List<dynamic>.from(caloryCount!.map((x) => x.toJson())),
        "ingredients": ingredients == null ? [] : List<dynamic>.from(ingredients!.map((x) => x)),
        "mealGroupId": mealGroupId,
        "image": image,
        "date": date?.toIso8601String(),
        "serving": serving,
        "status": status,
        "__v": v,
    };
}

class CaloryCount {
    String? label;
    int? kcal;
    String? id;

    CaloryCount({
        this.label,
        this.kcal,
        this.id,
    });

    factory CaloryCount.fromRawJson(String str) => CaloryCount.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CaloryCount.fromJson(Map<String, dynamic> json) => CaloryCount(
        label: json["label"],
        kcal: json["kcal"],
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "kcal": kcal,
        "_id": id,
    };
}
