// import 'dart:convert';

// class AiSuggestedMealsModel {
//     String? status;
//     Result? result;

//     AiSuggestedMealsModel({
//         this.status,
//         this.result,
//     });

//     factory AiSuggestedMealsModel.fromRawJson(String str) => AiSuggestedMealsModel.fromJson(json.decode(str));

//     String toRawJson() => json.encode(toJson());

//     factory AiSuggestedMealsModel.fromJson(Map<String, dynamic> json) => AiSuggestedMealsModel(
//         status: json["status"],
//         result: json["result"] == null ? null : Result.fromJson(json["result"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "status": status,
//         "result": result?.toJson(),
//     };
// }

// class Result {
//     Options? breakfastOptions;
//     Options? lunchOptions;
//     Options? dinnerOptions;
//     String? userId;
//     String? bloodType;
//     String? dietType;
//     int? totalDailyCalories;
//     Macronutrients? totalDailyMacronutrients;
//     String? breakfastImage;
//     String? lunchImage;
//     String? dinnerImage;
//     MealCalorieDistribution? mealCalorieDistribution;

//     Result({
//         this.breakfastOptions,
//         this.lunchOptions,
//         this.dinnerOptions,
//         this.userId,
//         this.bloodType,
//         this.dietType,
//         this.totalDailyCalories,
//         this.totalDailyMacronutrients,
//         this.breakfastImage,
//         this.lunchImage,
//         this.dinnerImage,
//         this.mealCalorieDistribution,
//     });

//     factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

//     String toRawJson() => json.encode(toJson());

//     factory Result.fromJson(Map<String, dynamic> json) => Result(
//         breakfastOptions: json["breakfast_options"] == null ? null : Options.fromJson(json["breakfast_options"]),
//         lunchOptions: json["lunch_options"] == null ? null : Options.fromJson(json["lunch_options"]),
//         dinnerOptions: json["dinner_options"] == null ? null : Options.fromJson(json["dinner_options"]),
//         userId: json["user_id"],
//         bloodType: json["blood_type"],
//         dietType: json["diet_type"],
//         totalDailyCalories: json["total_daily_calories"],
//         totalDailyMacronutrients: json["total_daily_macronutrients"] == null ? null : Macronutrients.fromJson(json["total_daily_macronutrients"]),
//         breakfastImage: json["breakfast_image"],
//         lunchImage: json["lunch_image"],
//         dinnerImage: json["dinner_image"],
//         mealCalorieDistribution: json["meal_calorie_distribution"] == null ? null : MealCalorieDistribution.fromJson(json["meal_calorie_distribution"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "breakfast_options": breakfastOptions?.toJson(),
//         "lunch_options": lunchOptions?.toJson(),
//         "dinner_options": dinnerOptions?.toJson(),
//         "user_id": userId,
//         "blood_type": bloodType,
//         "diet_type": dietType,
//         "total_daily_calories": totalDailyCalories,
//         "total_daily_macronutrients": totalDailyMacronutrients?.toJson(),
//         "breakfast_image": breakfastImage,
//         "lunch_image": lunchImage,
//         "dinner_image": dinnerImage,
//         "meal_calorie_distribution": mealCalorieDistribution?.toJson(),
//     };
// }

// class Options {
//     List<HealthyComforting>? proteinPacked;
//     List<HealthyComforting>? lightFresh;
//     List<HealthyComforting>? healthyComforting;

//     Options({
//         this.proteinPacked,
//         this.lightFresh,
//         this.healthyComforting,
//     });

//     factory Options.fromRawJson(String str) => Options.fromJson(json.decode(str));

//     String toRawJson() => json.encode(toJson());

//     factory Options.fromJson(Map<String, dynamic> json) => Options(
//         proteinPacked: json["protein_packed"] == null ? [] : List<HealthyComforting>.from(json["protein_packed"]!.map((x) => HealthyComforting.fromJson(x))),
//         lightFresh: json["light_fresh"] == null ? [] : List<HealthyComforting>.from(json["light_fresh"]!.map((x) => HealthyComforting.fromJson(x))),
//         healthyComforting: json["healthy_comforting"] == null ? [] : List<HealthyComforting>.from(json["healthy_comforting"]!.map((x) => HealthyComforting.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "protein_packed": proteinPacked == null ? [] : List<dynamic>.from(proteinPacked!.map((x) => x.toJson())),
//         "light_fresh": lightFresh == null ? [] : List<dynamic>.from(lightFresh!.map((x) => x.toJson())),
//         "healthy_comforting": healthyComforting == null ? [] : List<dynamic>.from(healthyComforting!.map((x) => x.toJson())),
//     };
// }

// class HealthyComforting {
//     String? mealName;
//     Category? category;
//     SubCategory? subCategory;
//     int? totalCalories;
//     Macronutrients? macronutrients;
//     String? description;
//     List<Ingredient>? ingredients;
//     int? numberOfServings;

//     HealthyComforting({
//         this.mealName,
//         this.category,
//         this.subCategory,
//         this.totalCalories,
//         this.macronutrients,
//         this.description,
//         this.ingredients,
//         this.numberOfServings,
//     });

//     factory HealthyComforting.fromRawJson(String str) => HealthyComforting.fromJson(json.decode(str));

//     String toRawJson() => json.encode(toJson());

//     factory HealthyComforting.fromJson(Map<String, dynamic> json) => HealthyComforting(
//         mealName: json["meal_name"],
//         category: _parseCategory(json["category"]),
//         subCategory: _parseSubCategory(json["sub_category"]),
//         totalCalories: json["total_calories"],
//         macronutrients: json["macronutrients"] == null ? null : Macronutrients.fromJson(json["macronutrients"]),
//         description: json["description"],
//         ingredients: json["ingredients"] == null ? [] : List<Ingredient>.from(json["ingredients"]!.map((x) => Ingredient.fromJson(x))),
//         numberOfServings: json["number_of_servings"],
//     );

//     static Category? _parseCategory(String? category) {
//         if (category == null) return null;
//         // Try direct mapping first
//         if (categoryValues.map.containsKey(category)) {
//             return categoryValues.map[category];
//         }
//         // Fallback for common variations
//         final normalized = category.toLowerCase();
//         if (normalized.contains("breakfast")) return Category.BREAKFAST;
//         if (normalized.contains("lunch")) return Category.LUNCH;
//         if (normalized.contains("dinner")) return Category.DINNER;
//         return null;
//     }

//     static SubCategory? _parseSubCategory(String? subCategory) {
//         if (subCategory == null) return null;
//         // Try direct mapping first
//         if (subCategoryValues.map.containsKey(subCategory)) {
//             return subCategoryValues.map[subCategory];
//         }
//         // Handle variations without ampersands or with different formatting
//         final normalized = subCategory.toLowerCase().replaceAll(RegExp(r'[\s&-]+'), ' ');
//         if (normalized == "light fresh") return SubCategory.LIGHT_FRESH;
//         if (normalized == "protein packed") return SubCategory.PROTEIN_PACKED;
//         if (normalized == "healthy comforting") return SubCategory.HEALTHY_COMFORTING;
//         return null;
//     }

//     Map<String, dynamic> toJson() => {
//         "meal_name": mealName,
//         "category": categoryValues.reverse[category],
//         "sub_category": subCategoryValues.reverse[subCategory],
//         "total_calories": totalCalories,
//         "macronutrients": macronutrients?.toJson(),
//         "description": description,
//         "ingredients": ingredients == null ? [] : List<dynamic>.from(ingredients!.map((x) => x.toJson())),
//         "number_of_servings": numberOfServings,
//     };
// }

// enum Category {
//     BREAKFAST,
//     DINNER,
//     LUNCH
// }

// final categoryValues = EnumValues({
//     "Breakfast": Category.BREAKFAST,
//     "Dinner": Category.DINNER,
//     "Lunch": Category.LUNCH
// });

// class Ingredient {
//     String? name;
//     String? quantity;
//     String? icon;

//     Ingredient({
//         this.name,
//         this.quantity,
//         this.icon,
//     });

//     factory Ingredient.fromRawJson(String str) => Ingredient.fromJson(json.decode(str));

//     String toRawJson() => json.encode(toJson());

//     factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
//         name: json["name"],
//         quantity: json["quantity"],
//         icon: json["icon"],
//     );

//     Map<String, dynamic> toJson() => {
//         "name": name,
//         "quantity": quantity,
//         "icon": icon,
//     };
// }

// class Macronutrients {
//     double? carbohydrates;
//     double? protein;
//     double? fat;

//     Macronutrients({
//         this.carbohydrates,
//         this.protein,
//         this.fat,
//     });

//     factory Macronutrients.fromRawJson(String str) => Macronutrients.fromJson(json.decode(str));

//     String toRawJson() => json.encode(toJson());

//     factory Macronutrients.fromJson(Map<String, dynamic> json) => Macronutrients(
//         carbohydrates: json["carbohydrates"] is num ? (json["carbohydrates"] as num).toDouble() : null,
//         protein: json["protein"] is num ? (json["protein"] as num).toDouble() : null,
//         fat: json["fat"] is num ? (json["fat"] as num).toDouble() : null,
//     );

//     Map<String, dynamic> toJson() => {
//         "carbohydrates": carbohydrates,
//         "protein": protein,
//         "fat": fat,
//     };
// }

// enum SubCategory {
//     HEALTHY_COMFORTING,
//     LIGHT_FRESH,
//     PROTEIN_PACKED
// }

// final subCategoryValues = EnumValues({
//     "Healthy & Comforting": SubCategory.HEALTHY_COMFORTING,
//     "Light & Fresh": SubCategory.LIGHT_FRESH,
//     "Protein-Packed": SubCategory.PROTEIN_PACKED
// });

// class MealCalorieDistribution {
//     int? breakfast;
//     int? lunch;
//     int? dinner;

//     MealCalorieDistribution({
//         this.breakfast,
//         this.lunch,
//         this.dinner,
//     });

//     factory MealCalorieDistribution.fromRawJson(String str) => MealCalorieDistribution.fromJson(json.decode(str));

//     String toRawJson() => json.encode(toJson());

//     factory MealCalorieDistribution.fromJson(Map<String, dynamic> json) => MealCalorieDistribution(
//         breakfast: json["breakfast"],
//         lunch: json["lunch"],
//         dinner: json["dinner"],
//     );

//     Map<String, dynamic> toJson() => {
//         "breakfast": breakfast,
//         "lunch": lunch,
//         "dinner": dinner,
//     };
// }

// class EnumValues<T> {
//     Map<String, T> map;
//     late Map<T, String> reverseMap;

//     EnumValues(this.map);

//     Map<T, String> get reverse {
//             reverseMap = map.map((k, v) => MapEntry(v, k));
//             return reverseMap;
//     }
// }


//-------------<>>>>> New Ai Suggested Meals Model <<<<<>---------------------//

import 'dart:convert';

class AiSuggestedMealsModel {
    String? status;
    Result? result;

    AiSuggestedMealsModel({
        this.status,
        this.result,
    });

    factory AiSuggestedMealsModel.fromRawJson(String str) => AiSuggestedMealsModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory AiSuggestedMealsModel.fromJson(Map<String, dynamic> json) => AiSuggestedMealsModel(
        status: json["status"],
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "result": result?.toJson(),
    };
}

class Result {
    String? userId;
    String? bloodType;
    String? dietType;
    int? totalDailyCalories;
    Macronutrients? totalDailyMacronutrients;
    Options? breakfastOptions;
    Options? lunchOptions;
    Options? dinnerOptions;
    String? breakfastImage;
    String? lunchImage;
    String? dinnerImage;
    String? breakfastImageId;
    String? lunchImageId;
    String? dinnerImageId;
    MealCalorieDistribution? mealCalorieDistribution;

    Result({
        this.userId,
        this.bloodType,
        this.dietType,
        this.totalDailyCalories,
        this.totalDailyMacronutrients,
        this.breakfastOptions,
        this.lunchOptions,
        this.dinnerOptions,
        this.breakfastImage,
        this.lunchImage,
        this.dinnerImage,
        this.breakfastImageId,
        this.lunchImageId,
        this.dinnerImageId,
        this.mealCalorieDistribution,
    });

    factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        userId: json["user_id"],
        bloodType: json["blood_type"],
        dietType: json["diet_type"],
        totalDailyCalories: json["total_daily_calories"],
        totalDailyMacronutrients: json["total_daily_macronutrients"] == null ? null : Macronutrients.fromJson(json["total_daily_macronutrients"]),
        breakfastOptions: json["breakfast_options"] == null ? null : Options.fromJson(json["breakfast_options"]),
        lunchOptions: json["lunch_options"] == null ? null : Options.fromJson(json["lunch_options"]),
        dinnerOptions: json["dinner_options"] == null ? null : Options.fromJson(json["dinner_options"]),
        breakfastImage: json["breakfast_image"],
        lunchImage: json["lunch_image"],
        dinnerImage: json["dinner_image"],
        breakfastImageId: json["breakfast_image_id"],
        lunchImageId: json["lunch_image_id"],
        dinnerImageId: json["dinner_image_id"],
        mealCalorieDistribution: json["meal_calorie_distribution"] == null ? null : MealCalorieDistribution.fromJson(json["meal_calorie_distribution"]),
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "blood_type": bloodType,
        "diet_type": dietType,
        "total_daily_calories": totalDailyCalories,
        "total_daily_macronutrients": totalDailyMacronutrients?.toJson(),
        "breakfast_options": breakfastOptions?.toJson(),
        "lunch_options": lunchOptions?.toJson(),
        "dinner_options": dinnerOptions?.toJson(),
        "breakfast_image": breakfastImage,
        "lunch_image": lunchImage,
        "dinner_image": dinnerImage,
        "breakfast_image_id": breakfastImageId,
        "lunch_image_id": lunchImageId,
        "dinner_image_id": dinnerImageId,
        "meal_calorie_distribution": mealCalorieDistribution?.toJson(),
    };
}

class Options {
    List<HealthyComforting>? proteinPacked;
    List<HealthyComforting>? lightFresh;
    List<HealthyComforting>? healthyComforting;

    Options({
        this.proteinPacked,
        this.lightFresh,
        this.healthyComforting,
    });

    factory Options.fromRawJson(String str) => Options.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Options.fromJson(Map<String, dynamic> json) => Options(
        proteinPacked: json["protein_packed"] == null ? [] : List<HealthyComforting>.from(json["protein_packed"]!.map((x) => HealthyComforting.fromJson(x))),
        lightFresh: json["light_fresh"] == null ? [] : List<HealthyComforting>.from(json["light_fresh"]!.map((x) => HealthyComforting.fromJson(x))),
        healthyComforting: json["healthy_comforting"] == null ? [] : List<HealthyComforting>.from(json["healthy_comforting"]!.map((x) => HealthyComforting.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "protein_packed": proteinPacked == null ? [] : List<dynamic>.from(proteinPacked!.map((x) => x.toJson())),
        "light_fresh": lightFresh == null ? [] : List<dynamic>.from(lightFresh!.map((x) => x.toJson())),
        "healthy_comforting": healthyComforting == null ? [] : List<dynamic>.from(healthyComforting!.map((x) => x.toJson())),
    };
}

class HealthyComforting {
    String? id;
    String? mealName;
    Category? category;
    SubCategory? subCategory;
    int? totalCalories;
    Macronutrients? macronutrients;
    String? description;
    List<Ingredient>? ingredients;
    int? numberOfServings;
    dynamic image;

    HealthyComforting({
        this.id,
        this.mealName,
        this.category,
        this.subCategory,
        this.totalCalories,
        this.macronutrients,
        this.description,
        this.ingredients,
        this.numberOfServings,
        this.image,
    });

    factory HealthyComforting.fromRawJson(String str) => HealthyComforting.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory HealthyComforting.fromJson(Map<String, dynamic> json) => HealthyComforting(
        id: json["id"],
        mealName: json["meal_name"],
        category: categoryValues.map[json["category"]],
        subCategory: subCategoryValues.map[json["sub_category"]],
        totalCalories: json["total_calories"],
        macronutrients: json["macronutrients"] == null ? null : Macronutrients.fromJson(json["macronutrients"]),
        description: json["description"],
        ingredients: json["ingredients"] == null ? [] : List<Ingredient>.from(json["ingredients"]!.map((x) => Ingredient.fromJson(x))),
        numberOfServings: json["number_of_servings"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "meal_name": mealName,
        "category": categoryValues.reverse[category],
        "sub_category": subCategoryValues.reverse[subCategory],
        "total_calories": totalCalories,
        "macronutrients": macronutrients?.toJson(),
        "description": description,
        "ingredients": ingredients == null ? [] : List<dynamic>.from(ingredients!.map((x) => x.toJson())),
        "number_of_servings": numberOfServings,
        "image": image,
    };
}

enum Category {
    BREAKFAST,
    DINNER,
    LUNCH
}

final categoryValues = EnumValues({
    "Breakfast": Category.BREAKFAST,
    "Dinner": Category.DINNER,
    "Lunch": Category.LUNCH
});

class Ingredient {
    String? name;
    String? quantity;
    String? icon;

    Ingredient({
        this.name,
        this.quantity,
        this.icon,
    });

    factory Ingredient.fromRawJson(String str) => Ingredient.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
        name: json["name"],
        quantity: json["quantity"],
        icon: json["icon"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "quantity": quantity,
        "icon": icon,
    };
}

class Macronutrients {
    int? carbohydrates;
    int? protein;
    int? fat;

    Macronutrients({
        this.carbohydrates,
        this.protein,
        this.fat,
    });

    factory Macronutrients.fromRawJson(String str) => Macronutrients.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Macronutrients.fromJson(Map<String, dynamic> json) => Macronutrients(
        carbohydrates: json["carbohydrates"],
        protein: json["protein"],
        fat: json["fat"],
    );

    Map<String, dynamic> toJson() => {
        "carbohydrates": carbohydrates,
        "protein": protein,
        "fat": fat,
    };
}

enum SubCategory {
    HEALTHY_COMFORTING,
    LIGHT_FRESH,
    PROTEIN_PACKED
}

final subCategoryValues = EnumValues({
    "Healthy & Comforting": SubCategory.HEALTHY_COMFORTING,
    "Light & Fresh": SubCategory.LIGHT_FRESH,
    "Protein-Packed": SubCategory.PROTEIN_PACKED
});

class MealCalorieDistribution {
    int? breakfast;
    int? lunch;
    int? dinner;

    MealCalorieDistribution({
        this.breakfast,
        this.lunch,
        this.dinner,
    });

    factory MealCalorieDistribution.fromRawJson(String str) => MealCalorieDistribution.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MealCalorieDistribution.fromJson(Map<String, dynamic> json) => MealCalorieDistribution(
        breakfast: json["breakfast"],
        lunch: json["lunch"],
        dinner: json["dinner"],
    );

    Map<String, dynamic> toJson() => {
        "breakfast": breakfast,
        "lunch": lunch,
        "dinner": dinner,
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



