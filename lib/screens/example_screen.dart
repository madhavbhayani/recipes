import 'package:flutter/material.dart';
import 'package:recipe_app/models/meal.dart';
import 'package:recipe_app/screens/recipe_detail_screen.dart';

class ExampleScreen extends StatelessWidget {
  const ExampleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Example of how to use the RecipeDetailScreen with the updated Meal model
            final Meal meal = Meal(
              id: '12345',
              name: 'Example Recipe',
              category: 'Example Category',
              area: 'Example Area',
              instructions: 'Example instructions here.',
              thumbUrl: 'https://example.com/image.jpg', // Fixed: changed 'thumbnail' to 'thumbUrl'
              youtubeUrl: '', // Fixed: changed 'youtubeLink' to 'youtubeUrl'
              ingredients: const ['Ingredient 1', 'Ingredient 2'],
              measures: const ['1 cup', '2 tbsp'],
              tags: 'Example, Test',
            );

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => RecipeDetailScreen(
                  mealId: meal.id,
                  mealName: meal.name,
                  mealImage: meal.thumbUrl, // Fixed: changed 'thumbnail' to 'thumbUrl'
                ),
              ),
            );
          },
          child: const Text('Open Recipe Detail'),
        ),
      ),
    );
  }
}
