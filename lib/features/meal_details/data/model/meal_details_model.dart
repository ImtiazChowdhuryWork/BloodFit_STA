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
    List<Ingredient>? ingredients;
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
        ingredients: json["ingredients"] == null ? [] : List<Ingredient>.from(json["ingredients"]!.map((x) => Ingredient.fromJson(x))),
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
        "ingredients": ingredients == null ? [] : List<dynamic>.from(ingredients!.map((x) => x.toJson())),
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
    double? kcal;
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
        kcal: json["kcal"] is num ? (json["kcal"] as num).toDouble() : null,
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "kcal": kcal,
        "_id": id,
    };
}

class Ingredient {
    String? name;
    String? quantity;
    String? icon;
    String? id;

    Ingredient({
        this.name,
        this.quantity,
        this.icon,
        this.id,
    });

    factory Ingredient.fromRawJson(String str) => Ingredient.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
        name: json["name"],
        quantity: json["quantity"],
        icon: json["icon"],
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "quantity": quantity,
        "icon": icon,
        "_id": id,
    };
}
