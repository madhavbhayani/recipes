import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/providers/meal_provider.dart';
import 'package:recipe_app/widgets/meal_detail.dart';
import 'package:recipe_app/widgets/loading_indicator.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

class RandomMealScreen extends StatefulWidget {
  const RandomMealScreen({super.key});

  @override
  State<RandomMealScreen> createState() => _RandomMealScreenState();
}

class _RandomMealScreenState extends State<RandomMealScreen> {
  @override
  void initState() {
    super.initState();
    _getRandomMeal();
  }

  Future<void> _getRandomMeal() async {
    await Provider.of<MealProvider>(context, listen: false).getRandomMeal();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MealProvider>(
      builder: (context, mealProvider, child) {
        if (mealProvider.isLoading) {
          return const Center(child: LoadingIndicator());
        }

        if (mealProvider.error.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Using an error Lottie animation
                SizedBox(
                  width: 150,
                  height: 150,
                  child: Lottie.network(
                    'https://assets10.lottiefiles.com/packages/lf20_error.json',
                    fit: BoxFit.contain,
                    animate: true,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Error: ${mealProvider.error}',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _getRandomMeal,
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        if (mealProvider.selectedMeal == null) {
          return const Center(child: Text('No meal found'));
        }

        final meal = mealProvider.selectedMeal!;

        return Stack(
          children: [
            SingleChildScrollView(child: MealDetail(meal: meal)),
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                onPressed: () {
                  _getRandomMeal();
                },
                tooltip: 'Get another random meal',
                child: const Icon(Icons.refresh),
              ).animate().scale(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
              ),
            ),
          ],
        );
      },
    );
  }
}
