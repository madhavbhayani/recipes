import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/providers/meal_provider.dart';
import 'package:recipe_app/screens/search_screen.dart';
import 'package:recipe_app/screens/categories_screen.dart';
import 'package:recipe_app/screens/favorites_screen.dart';
import 'package:recipe_app/screens/filters_screen.dart';
import 'package:recipe_app/screens/random_meal_screen.dart';
import 'package:recipe_app/widgets/meal_card.dart';
import 'package:recipe_app/widgets/category_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomePage(),
    const SearchScreen(),
    const CategoriesScreen(),
    const FiltersScreen(),
    const FavoritesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.category_outlined),
            selectedIcon: Icon(Icons.category),
            label: 'Categories',
          ),
          NavigationDestination(
            icon: Icon(Icons.filter_list_outlined),
            selectedIcon: Icon(Icons.filter_list),
            label: 'Filters',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border_outlined),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final provider = Provider.of<MealProvider>(context, listen: false);
    await provider.getRandomMeal();
    await provider.fetchAllCategories();
    await provider.searchMeals('chicken'); // Loading some initial recipes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with welcome text
            Container(
              padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
              color: Theme.of(context).colorScheme.primaryContainer,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delicious Recipes',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Discover amazing meals from around the world',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer
                              .withOpacity(0.8),
                        ),
                  ),
                ],
              ),
            ),

            // Random Recipe Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Random Recipe',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RandomMealScreen()));
                        },
                        child: const Text('See More'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Consumer<MealProvider>(
                    builder: (context, provider, _) {
                      if (provider.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (provider.randomMeal == null) {
                        return const Center(
                          child: Text('No random meal available'),
                        );
                      }
                      return MealCard(meal: provider.randomMeal!);
                    },
                  ),
                ],
              ),
            ),

            // Categories Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Categories',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to the categories tab
                          setState(() {
                            final homeState = context
                                .findAncestorStateOfType<_HomeScreenState>();
                            if (homeState != null) {
                              homeState.setState(() {
                                homeState._currentIndex = 2;
                              });
                            }
                          });
                        },
                        child: const Text('See All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Consumer<MealProvider>(
                    builder: (context, provider, _) {
                      if (provider.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (provider.categories.isEmpty) {
                        return const Center(
                          child: Text('No categories available'),
                        );
                      }

                      // Only show the first 6 categories
                      final displayCategories =
                          provider.categories.take(6).toList();
                      return SizedBox(
                        height: 130,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: displayCategories.length,
                          itemBuilder: (context, index) {
                            return CategoryCard(
                                category: displayCategories[index]);
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Recent Recipes Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Recipes',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Consumer<MealProvider>(
                    builder: (context, provider, _) {
                      if (provider.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (provider.meals.isEmpty) {
                        return const Center(
                          child: Text('No recipes available'),
                        );
                      }

                      // Show the first 3 meals
                      final meals = provider.meals.take(3).toList();
                      return Column(
                        children:
                            meals.map((meal) => MealCard(meal: meal)).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
