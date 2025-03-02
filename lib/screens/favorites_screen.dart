import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/providers/meal_provider.dart';
import 'package:recipe_app/widgets/meal_grid.dart';
import 'package:lottie/lottie.dart';
import 'package:recipe_app/screens/search_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: Consumer<MealProvider>(
        builder: (context, mealProvider, _) {
          if (mealProvider.favoriteMeals.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: Lottie.network(
                      'https://assets10.lottiefiles.com/packages/lf20_jI7hn4.json',
                      repeat: true,
                      animate: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites yet!',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start adding some recipes to your favorites',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SearchScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.search),
                    label: const Text('Find recipes'),
                  ),
                ],
              ),
            );
          }

          return MealGrid(meals: mealProvider.favoriteMeals);
        },
      ),
    );
  }
}
