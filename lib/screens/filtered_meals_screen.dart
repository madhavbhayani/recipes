import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/models/filter_option.dart';
import 'package:recipe_app/providers/meal_provider.dart';
import 'package:recipe_app/widgets/loading_indicator.dart';
import 'package:recipe_app/widgets/meal_grid.dart';

class FilteredMealsScreen extends StatefulWidget {
  final FilterOption filterOption;

  const FilteredMealsScreen({
    Key? key,
    required this.filterOption,
  }) : super(key: key);

  @override
  State<FilteredMealsScreen> createState() => _FilteredMealsScreenState();
}

class _FilteredMealsScreenState extends State<FilteredMealsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMeals();
    });
  }

  Future<void> _loadMeals() async {
    final provider = Provider.of<MealProvider>(context, listen: false);

    switch (widget.filterOption.type) {
      case FilterType.category:
        await provider.filterByCategory(widget.filterOption.name);
        break;
      case FilterType.area:
        await provider.filterByArea(widget.filterOption.name);
        break;
      case FilterType.ingredient:
        await provider.filterByIngredient(widget.filterOption.name);
        break;
    }
  }

  String get pageTitle {
    switch (widget.filterOption.type) {
      case FilterType.category:
        return '${widget.filterOption.name} Recipes';
      case FilterType.area:
        return '${widget.filterOption.name} Cuisine';
      case FilterType.ingredient:
        return 'Recipes with ${widget.filterOption.name}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
      ),
      body: Consumer<MealProvider>(
        builder: (ctx, mealProvider, _) {
          if (mealProvider.isLoading) {
            return const LoadingIndicator();
          }

          if (mealProvider.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${mealProvider.error}',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (mealProvider.meals.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons
                        .restaurant_menu, // Changed from Icons.no_meals which doesn't exist
                    size: 60,
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No recipes found for ${widget.filterOption.name}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadMeals,
            child: MealGrid(meals: mealProvider.meals),
          );
        },
      ),
    );
  }
}
