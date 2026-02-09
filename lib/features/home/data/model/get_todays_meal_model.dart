import 'dart:convert';

class GetTodaysMealModel {
    bool? success;
    int? status;
    String? message;
    Data? data;

    GetTodaysMealModel({
        this.success,
        this.status,
        this.message,
        this.data,
    });

    factory GetTodaysMealModel.fromRawJson(String str) => GetTodaysMealModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GetTodaysMealModel.fromJson(Map<String, dynamic> json) => GetTodaysMealModel(
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
    TodaysMealDataModel? breakfast;
    TodaysMealDataModel? lunch;
    TodaysMealDataModel? dinner;

    Data({
        this.breakfast,
        this.lunch,
        this.dinner,
    });

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        breakfast: json["breakfast"] == null ? null : TodaysMealDataModel.fromJson(json["breakfast"]),
        lunch: json["lunch"] == null ? null : TodaysMealDataModel.fromJson(json["lunch"]),
        dinner: json["dinner"] == null ? null : TodaysMealDataModel.fromJson(json["dinner"]),
    );

    Map<String, dynamic> toJson() => {
        "breakfast": breakfast?.toJson(),
        "lunch": lunch?.toJson(),
        "dinner": dinner?.toJson(),
    };
}

class TodaysMealDataModel {
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
    String? status;
    int? v;

    TodaysMealDataModel({
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
        this.status,
        this.v,
    });

    factory TodaysMealDataModel.fromRawJson(String str) => TodaysMealDataModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory TodaysMealDataModel.fromJson(Map<String, dynamic> json) => TodaysMealDataModel(
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
