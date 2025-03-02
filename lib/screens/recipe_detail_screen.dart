import 'package:flutter/material.dart';
import 'package:recipe_app/models/meal.dart';
import 'package:recipe_app/services/meal_api_service.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class RecipeDetailScreen extends StatefulWidget {
  final String mealId;
  final String mealName;
  final String mealImage;

  const RecipeDetailScreen({
    Key? key,
    required this.mealId,
    required this.mealName,
    required this.mealImage,
  }) : super(key: key);

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final MealApiService _apiService = MealApiService();
  late Future<Meal> _mealFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the future in initState
    _mealFuture = _apiService.getMealById(widget.mealId);
  }

  Future<void> _launchYoutubeUrl(String url) async {
    if (url.isEmpty) return;

    final Uri uri = Uri.parse(url);
    if (await launcher.canLaunchUrl(uri)) {
      await launcher.launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mealName),
      ),
      body: FutureBuilder<Meal>(
        future: _mealFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No recipe details found'));
          }

          final meal = snapshot.data!;
          return _buildRecipeDetails(meal);
        },
      ),
    );
  }

  Widget _buildRecipeDetails(Meal meal) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recipe Image
          Hero(
            tag: 'recipe_${meal.id}',
            child: Image.network(
              meal.thumbUrl, // Fixed: using thumbUrl instead of thumbnail
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, _) => Container(
                height: 250,
                color: Colors.grey[300],
                child:
                    Icon(Icons.broken_image, size: 50, color: Colors.grey[600]),
              ),
            ),
          ),

          // Recipe Name
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              meal.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),

          // Category and Area
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Chip(
                  label: Text(meal.category),
                  backgroundColor: Colors.amber.shade100,
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(meal.area),
                  backgroundColor: Colors.green.shade100,
                ),
              ],
            ),
          ),

          // Ingredients
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ingredients',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: meal.ingredients.length,
                  itemBuilder: (context, index) {
                    final measure = index < meal.measures.length
                        ? meal.measures[index]
                        : '';
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Expanded(
                            child: Text('$measure ${meal.ingredients[index]}'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Instructions
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Instructions',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  meal.instructions,
                  style: const TextStyle(
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          // YouTube Link if available
          if (meal.youtubeUrl
              .isNotEmpty) // Fixed: Changed youtubeLink to youtubeUrl
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.play_circle_outline),
                label: const Text('Watch Video Tutorial'),
                onPressed: () => _launchYoutubeUrl(meal
                    .youtubeUrl), // Fixed: Changed youtubeLink to youtubeUrl
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
