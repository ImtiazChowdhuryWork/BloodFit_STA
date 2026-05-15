import 'dart:convert';

class GetSubscriptionPlansModel {
    bool? success;
    int? status;
    String? message;
    List<Datum>? data;

    GetSubscriptionPlansModel({
        this.success,
        this.status,
        this.message,
        this.data,
    });

    factory GetSubscriptionPlansModel.fromRawJson(String str) => GetSubscriptionPlansModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GetSubscriptionPlansModel.fromJson(Map<String, dynamic> json) => GetSubscriptionPlansModel(
        success: json["success"],
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    String? id;
    String? name;
    String? slug;
    Pricing? pricing;
    Limits? limits;
    List<Feature>? features;
    bool? isPopular;
    bool? isActive;
    String? createdBy;
    DateTime? createdAt;
    DateTime? updatedAt;
    int? v;

    Datum({
        this.id,
        this.name,
        this.slug,
        this.pricing,
        this.limits,
        this.features,
        this.isPopular,
        this.isActive,
        this.createdBy,
        this.createdAt,
        this.updatedAt,
        this.v,
    });

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        name: json["name"],
        slug: json["slug"],
        pricing: json["pricing"] == null ? null : Pricing.fromJson(json["pricing"]),
        limits: json["limits"] == null ? null : Limits.fromJson(json["limits"]),
        features: json["features"] == null ? [] : List<Feature>.from(json["features"]!.map((x) => Feature.fromJson(x))),
        isPopular: json["isPopular"],
        isActive: json["isActive"],
        createdBy: json["createdBy"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "slug": slug,
        "pricing": pricing?.toJson(),
        "limits": limits?.toJson(),
        "features": features == null ? [] : List<dynamic>.from(features!.map((x) => x.toJson())),
        "isPopular": isPopular,
        "isActive": isActive,
        "createdBy": createdBy,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
    };
}

class Feature {
    Key? key;
    Label? label;
    bool? included;
    String? id;

    Feature({
        this.key,
        this.label,
        this.included,
        this.id,
    });

    factory Feature.fromRawJson(String str) => Feature.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        key: keyValues.map[json["key"]],
        label: labelValues.map[json["label"]],
        included: json["included"],
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "key": keyValues.reverse[key],
        "label": labelValues.reverse[label],
        "included": included,
        "_id": id,
    };
}

enum Key {
    AI_NUTRITION,
    PRIORITY_SUPPORT
}

final keyValues = EnumValues({
    "ai_nutrition": Key.AI_NUTRITION,
    "priority_support": Key.PRIORITY_SUPPORT
});

enum Label {
    AI_NUTRITION_BALANCE,
    PRIORITY_SUPPORT
}

final labelValues = EnumValues({
    "AI Nutrition Balance": Label.AI_NUTRITION_BALANCE,
    "Priority Support": Label.PRIORITY_SUPPORT
});

class Limits {
    int? mealsPerWeek;
    int? mealsPerMonth;

    Limits({
        this.mealsPerWeek,
        this.mealsPerMonth,
    });

    factory Limits.fromRawJson(String str) => Limits.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Limits.fromJson(Map<String, dynamic> json) => Limits(
        mealsPerWeek: json["mealsPerWeek"],
        mealsPerMonth: json["mealsPerMonth"],
    );

    Map<String, dynamic> toJson() => {
        "mealsPerWeek": mealsPerWeek,
        "mealsPerMonth": mealsPerMonth,
    };
}

class Pricing {
    Monthly? monthly;
    Monthly? yearly;

    Pricing({
        this.monthly,
        this.yearly,
    });

    factory Pricing.fromRawJson(String str) => Pricing.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Pricing.fromJson(Map<String, dynamic> json) => Pricing(
        monthly: json["monthly"] == null ? null : Monthly.fromJson(json["monthly"]),
        yearly: json["yearly"] == null ? null : Monthly.fromJson(json["yearly"]),
    );

    Map<String, dynamic> toJson() => {
        "monthly": monthly?.toJson(),
        "yearly": yearly?.toJson(),
    };
}

class Monthly {
    double? price;

    Monthly({
        this.price,
    });

    factory Monthly.fromRawJson(String str) => Monthly.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Monthly.fromJson(Map<String, dynamic> json) => Monthly(
        price: json["price"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "price": price,
    };
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
