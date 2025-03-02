import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/providers/meal_provider.dart';
import 'package:recipe_app/widgets/loading_indicator.dart';
import 'package:recipe_app/widgets/meal_grid.dart';

class MealsByCategoryScreen extends StatefulWidget {
  final String category;
  final String categoryId;

  const MealsByCategoryScreen({
    Key? key,
    required this.category,
    required this.categoryId,
  }) : super(key: key);

  @override
  State<MealsByCategoryScreen> createState() => _MealsByCategoryScreenState();
}

class _MealsByCategoryScreenState extends State<MealsByCategoryScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  Future<void> _loadMeals() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<MealProvider>(context, listen: false)
          .filterByCategory(widget.category);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading meals: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: _isLoading
          ? const LoadingIndicator()
          : Consumer<MealProvider>(
              builder: (ctx, mealProvider, _) {
                if (mealProvider.error.isNotEmpty) {
                  return Center(
                    child: Text(
                      mealProvider.error,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (mealProvider.meals.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          size: 60,
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No meals found for ${widget.category}',
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
