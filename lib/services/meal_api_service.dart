import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipe_app/models/meal.dart';
import 'package:recipe_app/models/category.dart';

class MealApiService {
  final String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<Meal>> searchMealsByName(String name) async {
    final response = await http.get(Uri.parse('$baseUrl/search.php?s=$name'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] == null) return [];
      return (data['meals'] as List)
          .map((meal) => Meal.fromJson(meal))
          .toList();
    } else {
      throw Exception('Failed to search meals');
    }
  }

  Future<Meal> getRandomMeal() async {
    final response = await http.get(Uri.parse('$baseUrl/random.php'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Meal.fromJson(data['meals'][0]);
    } else {
      throw Exception('Failed to get random meal');
    }
  }

  Future<List<Category>> getAllCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories.php'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['categories'] as List)
          .map((category) => Category.fromJson(category))
          .toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<String>> getAllAreas() async {
    final response = await http.get(Uri.parse('$baseUrl/list.php?a=list'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['meals'] as List)
          .map((area) => area['strArea'] as String)
          .toList();
    } else {
      throw Exception('Failed to load areas');
    }
  }

  Future<List<String>> getAllIngredients() async {
    final response = await http.get(Uri.parse('$baseUrl/list.php?i=list'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['meals'] as List)
          .map((ingredient) => ingredient['strIngredient'] as String)
          .toList();
    } else {
      throw Exception('Failed to load ingredients');
    }
  }

  Future<List<Meal>> filterByIngredient(String ingredient) async {
    final response =
        await http.get(Uri.parse('$baseUrl/filter.php?i=$ingredient'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] == null) return [];
      return (data['meals'] as List)
          .map((meal) => Meal.fromJson(meal))
          .toList();
    } else {
      throw Exception('Failed to filter meals by ingredient');
    }
  }

  Future<List<Meal>> filterByCategory(String category) async {
    final response =
        await http.get(Uri.parse('$baseUrl/filter.php?c=$category'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] == null) return [];
      return (data['meals'] as List)
          .map((meal) => Meal.fromJson(meal))
          .toList();
    } else {
      throw Exception('Failed to filter meals by category');
    }
  }

  Future<List<Meal>> filterByArea(String area) async {
    final response = await http.get(Uri.parse('$baseUrl/filter.php?a=$area'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] == null) return [];
      return (data['meals'] as List)
          .map((meal) => Meal.fromJson(meal))
          .toList();
    } else {
      throw Exception('Failed to filter meals by area');
    }
  }

  Future<Meal> getMealById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/lookup.php?i=$id'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Meal.fromJson(data['meals'][0]);
    } else {
      throw Exception('Failed to get meal details');
    }
  }
}
