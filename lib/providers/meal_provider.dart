import 'package:flutter/material.dart';
import 'package:recipe_app/models/category.dart';
import 'package:recipe_app/models/meal.dart';
import 'package:recipe_app/services/meal_api_service.dart';

class MealProvider extends ChangeNotifier {
  final MealApiService _apiService = MealApiService();

  List<Meal> _meals = [];
  List<Meal> _favoriteMeals = [];
  List<Category> _categories = [];
  List<String> _areas = [];
  List<String> _ingredients = [];
  Meal? _randomMeal;
  bool _isLoading = false;
  String _error = '';

  List<Meal> get meals => _meals;
  List<Meal> get favoriteMeals => _favoriteMeals;
  List<Category> get categories => _categories;
  List<String> get areas => _areas;
  List<String> get ingredients => _ingredients;
  Meal? get randomMeal => _randomMeal;
  Meal? get selectedMeal =>
      _randomMeal; // Added selectedMeal getter that returns the randomMeal
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> searchMeals(String query) async {
    if (query.isEmpty) {
      _meals = [];
      notifyListeners();
      return;
    }

    _setLoading(true);
    try {
      _meals = await _apiService.searchMealsByName(query);
      _error = '';
    } catch (e) {
      _error = 'Failed to search meals: ${e.toString()}';
      _meals = [];
    }
    _setLoading(false);
  }

  Future<void> getRandomMeal() async {
    _setLoading(true);
    try {
      _randomMeal = await _apiService.getRandomMeal();
      _error = '';
    } catch (e) {
      _error = 'Failed to get random meal: ${e.toString()}';
      _randomMeal = null;
    }
    _setLoading(false);
  }

  Future<void> fetchAllCategories() async {
    if (_categories.isNotEmpty) return;

    _setLoading(true);
    try {
      _categories = await _apiService.getAllCategories();
      _error = '';
    } catch (e) {
      _error = 'Failed to load categories: ${e.toString()}';
      _categories = [];
    }
    _setLoading(false);
  }

  Future<void> fetchAllAreas() async {
    if (_areas.isNotEmpty) return;

    _setLoading(true);
    try {
      _areas = await _apiService.getAllAreas();
      _error = '';
    } catch (e) {
      _error = 'Failed to load areas: ${e.toString()}';
      _areas = [];
    }
    _setLoading(false);
  }

  Future<void> fetchAllIngredients() async {
    if (_ingredients.isNotEmpty) return;

    _setLoading(true);
    try {
      _ingredients = await _apiService.getAllIngredients();
      _error = '';
    } catch (e) {
      _error = 'Failed to load ingredients: ${e.toString()}';
      _ingredients = [];
    }
    _setLoading(false);
  }

  Future<void> filterByIngredient(String ingredient) async {
    _setLoading(true);
    try {
      _meals = await _apiService.filterByIngredient(ingredient);
      _error = '';
    } catch (e) {
      _error = 'Failed to filter by ingredient: ${e.toString()}';
      _meals = [];
    }
    _setLoading(false);
  }

  Future<void> filterByCategory(String category) async {
    _setLoading(true);
    try {
      _meals = await _apiService.filterByCategory(category);
      _error = '';
    } catch (e) {
      _error = 'Failed to filter by category: ${e.toString()}';
      _meals = [];
    }
    _setLoading(false);
  }

  Future<void> filterByArea(String area) async {
    _setLoading(true);
    try {
      _meals = await _apiService.filterByArea(area);
      _error = '';
    } catch (e) {
      _error = 'Failed to filter by area: ${e.toString()}';
      _meals = [];
    }
    _setLoading(false);
  }

  Future<Meal> getMealDetails(String id) async {
    _setLoading(true);
    try {
      final meal = await _apiService.getMealById(id);

      // Check if this meal is already in favorites
      final isFav = _favoriteMeals.any((m) => m.id == id);

      // Return with correct favorite status
      final mealWithFavStatus = isFav ? meal.copyWith(isFavorite: true) : meal;

      _error = '';
      _setLoading(false);
      return mealWithFavStatus;
    } catch (e) {
      _error = 'Failed to get meal details: ${e.toString()}';
      _setLoading(false);
      throw e;
    }
  }

  void toggleFavorite(Meal meal) {
    final existingIndex = _favoriteMeals.indexWhere((m) => m.id == meal.id);
    if (existingIndex >= 0) {
      _favoriteMeals.removeAt(existingIndex);
    } else {
      _favoriteMeals.add(meal.copyWith(isFavorite: true));
    }
    notifyListeners();
  }

  bool isFavorite(String id) {
    return _favoriteMeals.any((meal) => meal.id == id);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
