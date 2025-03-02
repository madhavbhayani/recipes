class Ingredient {
  final String id;
  final String name;
  final String? description;
  final String? type;

  Ingredient({
    required this.id,
    required this.name,
    this.description,
    this.type,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['idIngredient'],
      name: json['strIngredient'],
      description: json['strDescription'],
      type: json['strType'],
    );
  }
}
