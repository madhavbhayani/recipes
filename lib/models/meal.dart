class Meal {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String thumbUrl;
  final String tags;
  final String youtubeUrl;
  final List<String> ingredients;
  final List<String> measures;
  final bool isFavorite;

  Meal({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbUrl,
    this.tags = '',
    this.youtubeUrl = '',
    required this.ingredients,
    required this.measures,
    this.isFavorite = false,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    List<String> ingredients = [];
    List<String> measures = [];

    // TheMealDB API stores ingredients and measures as indexed properties
    for (int i = 1; i <= 20; i++) {
      if (json['strIngredient$i'] != null &&
          json['strIngredient$i'].toString().trim().isNotEmpty) {
        ingredients.add(json['strIngredient$i']);
        measures.add(json['strMeasure$i'] ?? '');
      }
    }

    return Meal(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      category: json['strCategory'] ?? '',
      area: json['strArea'] ?? '',
      instructions: json['strInstructions'] ?? '',
      thumbUrl: json['strMealThumb'] ?? '',
      tags: json['strTags'] ?? '',
      youtubeUrl: json['strYoutube'] ?? '',
      ingredients: ingredients,
      measures: measures,
    );
  }

  Meal copyWith({bool? isFavorite}) {
    return Meal(
      id: id,
      name: name,
      category: category,
      area: area,
      instructions: instructions,
      thumbUrl: thumbUrl,
      tags: tags,
      youtubeUrl: youtubeUrl,
      ingredients: ingredients,
      measures: measures,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class Area {
  final String name;

  Area({
    required this.name,
  });

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      name: json['strArea'] ?? '',
    );
  }
}

class Ingredient {
  final String id;
  final String name;
  final String description;
  final String type;

  Ingredient({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['idIngredient'] ?? '',
      name: json['strIngredient'] ?? '',
      description: json['strDescription'] ?? '',
      type: json['strType'] ?? '',
    );
  }
}
