import 'dart:convert';

GetTodaysMealModel getTodaysMealModelFromJson(String str) =>
    GetTodaysMealModel.fromJson(json.decode(str));

class GetTodaysMealModel {
  final bool success;
  final int status;
  final String message;
  final List<Datum> data;

  GetTodaysMealModel({
    required this.success,
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetTodaysMealModel.fromJson(Map<String, dynamic> json) {
    return GetTodaysMealModel(
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => Datum.fromJson(e))
          .toList(),
    );
  }
}



class Datum {
  final String id;
  final String userId;
  final String mealName;
  final String mealType;
  final int kcal;
  final String description;
  final List<CaloryCount> caloryCount;
  final List<Ingredient> ingredients;
  final String mealGroupId;
  final String image;
  final DateTime date;
  final int serving;
  final String status;
  final int version;

  Datum({
    required this.id,
    required this.userId,
    required this.mealName,
    required this.mealType,
    required this.kcal,
    required this.description,
    required this.caloryCount,
    required this.ingredients,
    required this.mealGroupId,
    required this.image,
    required this.date,
    required this.serving,
    required this.status,
    required this.version,
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      mealName: json['mealName'] ?? '',
      mealType: json['mealType'] ?? '',
      kcal: json['kcal'] ?? 0,
      description: json['description'] ?? '',
      caloryCount: (json['caloryCount'] as List<dynamic>? ?? [])
          .map((e) => CaloryCount.fromJson(e))
          .toList(),
      ingredients: (json['ingredients'] as List<dynamic>? ?? [])
          .map((e) => Ingredient.fromJson(e))
          .toList(),
      mealGroupId: json['mealGroupId'] ?? '',
      image: json['image'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      serving: json['serving'] ?? 0,
      status: json['status'] ?? '',
      version: json['__v'] ?? 0,
    );
  }
}


class CaloryCount {
  final String id;
  final String label;
  final double kcal;

  CaloryCount({
    required this.id,
    required this.label,
    required this.kcal,
  });

  factory CaloryCount.fromJson(Map<String, dynamic> json) {
    return CaloryCount(
      id: json['_id'] ?? '',
      label: json['label'] ?? '',
      kcal: json['kcal'] is num ? (json['kcal'] as num).toDouble() : 0,
    );
  }
}


class Ingredient {
  final String id;
  final String name;
  final String quantity;
  final String icon;

  Ingredient({
    required this.id,
    required this.name,
    required this.quantity,
    required this.icon,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}