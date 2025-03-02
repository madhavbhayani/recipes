import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/providers/meal_provider.dart';
import 'package:recipe_app/screens/filtered_meals_screen.dart';
import 'package:recipe_app/widgets/loading_indicator.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:recipe_app/models/filter_option.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['Categories', 'Areas', 'Ingredients'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final mealProvider = Provider.of<MealProvider>(context, listen: false);
    await mealProvider.fetchAllCategories();
    await mealProvider.fetchAllAreas();
    await mealProvider.fetchAllIngredients();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
        // Improved TabBar with better spacing for the selected tab indicator
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              tabBarTheme: TabBarTheme(
                labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                indicatorSize:
                    TabBarIndicatorSize.tab, // Use tab size instead of label
              ),
            ),
            child: TabBar(
              controller: _tabController,
              tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Theme.of(context).colorScheme.primary,
              ),
              labelColor: Theme.of(context).colorScheme.onPrimary,
              unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.normal),
              padding: const EdgeInsets.symmetric(
                  horizontal: 4, vertical: 6), // Adjust padding
              isScrollable: false, // Force tabs to take equal width
              labelPadding: const EdgeInsets.symmetric(
                  horizontal: 16), // Add padding to the labels
              dividerColor: Colors.transparent, // Remove divider
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildCategoriesList(),
              _buildAreasList(),
              _buildIngredientsList(),
            ],
          ),
        ),
      ],
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
