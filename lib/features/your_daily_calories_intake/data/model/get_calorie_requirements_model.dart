import 'dart:convert';

class GetCalorieRequirementsModel {
  bool? success;
  int? status;
  String? message;
  Data? data;

  GetCalorieRequirementsModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  factory GetCalorieRequirementsModel.fromRawJson(String str) =>
      GetCalorieRequirementsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetCalorieRequirementsModel.fromJson(Map<String, dynamic> json) =>
      GetCalorieRequirementsModel(
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
  Meal? meal;
  Workout? workout;
  int? completionPercentage;
  CalorieRequirement? calorieRequirement;

  Data({
    this.meal,
    this.workout,
    this.completionPercentage,
    this.calorieRequirement,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    meal: json["meal"] == null ? null : Meal.fromJson(json["meal"]),
    workout: json["workout"] == null ? null : Workout.fromJson(json["workout"]),
    completionPercentage: json["completionPercentage"],
    calorieRequirement: json["calorieRequirement"] == null
        ? null
        : CalorieRequirement.fromJson(json["calorieRequirement"]),
  );

  Map<String, dynamic> toJson() => {
    "meal": meal?.toJson(),
    "workout": workout?.toJson(),
    "completionPercentage": completionPercentage,
    "calorieRequirement": calorieRequirement?.toJson(),
  };
}

class CalorieRequirement {
  String? id;
  String? userId;
  int? totalCalorie;
  int? carbs;
  int? protein;
  int? fat;
  int? v;

  CalorieRequirement({
    this.id,
    this.userId,
    this.totalCalorie,
    this.carbs,
    this.protein,
    this.fat,
    this.v,
  });

  factory CalorieRequirement.fromRawJson(String str) =>
      CalorieRequirement.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CalorieRequirement.fromJson(Map<String, dynamic> json) =>
      CalorieRequirement(
        id: json["_id"],
        userId: json["userId"],
        totalCalorie: json["totalCalorie"],
        carbs: json["carbs"],
        protein: json["protein"],
        fat: json["fat"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "totalCalorie": totalCalorie,
    "carbs": carbs,
    "protein": protein,
    "fat": fat,
    "__v": v,
  };
}

class Meal {
  int? totalMealCount;
  int? completedMealCount;
  int? mealCompletionPercentage;

  Meal({
    this.totalMealCount,
    this.completedMealCount,
    this.mealCompletionPercentage,
  });

  factory Meal.fromRawJson(String str) => Meal.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
    totalMealCount: json["totalMealCount"],
    completedMealCount: json["completedMealCount"],
    mealCompletionPercentage: json["mealCompletionPercentage"],
  );

  Map<String, dynamic> toJson() => {
    "totalMealCount": totalMealCount,
    "completedMealCount": completedMealCount,
    "mealCompletionPercentage": mealCompletionPercentage,
  };
}

class Workout {
  int? totalWorkoutCount;
  int? completedWorkoutCount;
  int? workoutCompletionPercentage;

  Workout({
    this.totalWorkoutCount,
    this.completedWorkoutCount,
    this.workoutCompletionPercentage,
  });

  factory Workout.fromRawJson(String str) => Workout.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Workout.fromJson(Map<String, dynamic> json) => Workout(
    totalWorkoutCount: json["totalWorkoutCount"],
    completedWorkoutCount: json["completedWorkoutCount"],
    workoutCompletionPercentage: json["WorkoutCompletionPercentage"],
  );

  Map<String, dynamic> toJson() => {
    "totalWorkoutCount": totalWorkoutCount,
    "completedWorkoutCount": completedWorkoutCount,
    "WorkoutCompletionPercentage": workoutCompletionPercentage,
  };
}
