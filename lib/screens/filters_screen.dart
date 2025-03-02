import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/providers/meal_provider.dart';
import 'package:recipe_app/screens/filtered_meals_screen.dart';
import 'package:recipe_app/widgets/loading_indicator.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:recipe_app/models/filter_option.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  // Use simple integer for the selected index instead of TabController
  int _selectedIndex = 0;
  final List<String> _tabs = ['Categories', 'Areas', 'Ingredients'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final mealProvider = Provider.of<MealProvider>(context, listen: false);
    await mealProvider.fetchAllCategories();
    await mealProvider.fetchAllAreas();
    await mealProvider.fetchAllIngredients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Recipes'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Filter meals by category, area, or ingredient',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Custom tab selector instead of TabBar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: List.generate(_tabs.length, (index) {
                final isSelected = _selectedIndex == index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Center(
                        child: Text(
                          _tabs[index],
                          style: TextStyle(
                            color: isSelected
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          // Content based on selected tab
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                _buildCategoriesList(),
                _buildAreasList(),
                _buildIngredientsList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesList() {
    return Consumer<MealProvider>(
      builder: (context, mealProvider, child) {
        if (mealProvider.isLoading) {
          return const Center(child: LoadingIndicator());
        }

        if (mealProvider.error.isNotEmpty) {
          return Center(child: Text(mealProvider.error));
        }

        return AnimationLimiter(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: mealProvider.categories.length,
            itemBuilder: (ctx, i) {
              final category = mealProvider.categories[i];

              return AnimationConfiguration.staggeredList(
                position: i,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(category.thumbUrl),
                          onBackgroundImageError: (_, __) =>
                              const Icon(Icons.broken_image),
                        ),
                        title: Text(category.name),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FilteredMealsScreen(
                                filterOption: FilterOption(
                                  name: category.name,
                                  type: FilterType.category,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildAreasList() {
    return Consumer<MealProvider>(
      builder: (context, mealProvider, child) {
        if (mealProvider.isLoading) {
          return const Center(child: LoadingIndicator());
        }

        if (mealProvider.error.isNotEmpty) {
          return Center(child: Text(mealProvider.error));
        }

        return AnimationLimiter(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: mealProvider.areas.length,
            itemBuilder: (ctx, i) {
              final area = mealProvider.areas[i];

              return AnimationConfiguration.staggeredList(
                position: i,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.flag),
                        ),
                        title: Text(area),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FilteredMealsScreen(
                                filterOption: FilterOption(
                                  name: area,
                                  type: FilterType.area,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildIngredientsList() {
    return Consumer<MealProvider>(
      builder: (context, mealProvider, child) {
        if (mealProvider.isLoading) {
          return const Center(child: LoadingIndicator());
        }

        if (mealProvider.error.isNotEmpty) {
          return Center(child: Text(mealProvider.error));
        }

        // Only show first 20 ingredients for better performance
        final ingredients = mealProvider.ingredients.take(20).toList();

        return AnimationLimiter(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: ingredients.length,
            itemBuilder: (ctx, i) {
              final ingredient = ingredients[i];

              return AnimationConfiguration.staggeredList(
                position: i,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.food_bank),
                        ),
                        title: Text(ingredient),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FilteredMealsScreen(
                                filterOption: FilterOption(
                                  name: ingredient,
                                  type: FilterType.ingredient,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
