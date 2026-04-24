class SwapMealRequestModel {
  final String mealName;
  final String description;
  final int serving;
  final List<SwapMealIngredient> ingredients;
  final List<SwapMealCaloryCount> caloryCount;

  SwapMealRequestModel({
    required this.mealName,
    required this.description,
    required this.serving,
    required this.ingredients,
    required this.caloryCount,
  });

  Map<String, dynamic> toJson() => {
        'mealName': mealName,
        'description': description,
        'serving': serving,
        'ingredients': ingredients.map((e) => e.toJson()).toList(),
        'caloryCount': caloryCount.map((e) => e.toJson()).toList(),
      };
}

class SwapMealIngredient {
  final String name;
  final String quantity;
  final String icon;

  SwapMealIngredient({
    required this.name,
    required this.quantity,
    required this.icon,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'quantity': quantity,
        'icon': icon,
      };
}

class SwapMealCaloryCount {
  final String label;
  final int kcal;

  SwapMealCaloryCount({
    required this.label,
    required this.kcal,
  });

  Map<String, dynamic> toJson() => {
        'label': label,
        'kcal': kcal,
      };
}
