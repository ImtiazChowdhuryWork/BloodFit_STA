import 'dart:convert';

class ProgressReportApiModel {
    bool? success;
    int? status;
    String? message;
    Data? data;

    ProgressReportApiModel({
        this.success,
        this.status,
        this.message,
        this.data,
    });

    factory ProgressReportApiModel.fromRawJson(String str) => ProgressReportApiModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ProgressReportApiModel.fromJson(Map<String, dynamic> json) => ProgressReportApiModel(
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

    Data({
        this.meal,
        this.workout,
        this.completionPercentage,
    });

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        meal: json["meal"] == null ? null : Meal.fromJson(json["meal"]),
        workout: json["workout"] == null ? null : Workout.fromJson(json["workout"]),
        completionPercentage: json["completionPercentage"],
    );

    Map<String, dynamic> toJson() => {
        "meal": meal?.toJson(),
        "workout": workout?.toJson(),
        "completionPercentage": completionPercentage,
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
