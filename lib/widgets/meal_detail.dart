import 'package:flutter/material.dart';
import 'package:recipe_app/models/meal.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class MealDetail extends StatelessWidget {
  final Meal meal;

  const MealDetail({Key? key, required this.meal}) : super(key: key);

  Future<void> _launchUrl(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    if (await launcher.canLaunchUrl(uri)) {
      await launcher.launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero image
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              meal.thumbUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (ctx, error, _) => Container(
                height: 250,
                width: double.infinity,
                color: Colors.grey.shade300,
                child: const Center(
                  child: Icon(Icons.broken_image, size: 64, color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            meal.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),

          // Category and Area
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(
                avatar: const Icon(Icons.category),
                label: Text(meal.category),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              ),
              Chip(
                avatar: const Icon(Icons.public),
                label: Text(meal.area),
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
              ),
              if (meal.tags.isNotEmpty)
                ...meal.tags.split(',').map((tag) => Chip(
                      avatar: const Icon(Icons.tag),
                      label: Text(tag.trim()),
                      backgroundColor:
                          Theme.of(context).colorScheme.tertiaryContainer,
                    )),
            ],
          ),
          const SizedBox(height: 24),

          // Ingredients
          _buildSectionTitle(context, 'Ingredients'),
          const SizedBox(height: 8),
          Card(
            elevation: 1,
            color: Theme.of(context).colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  meal.ingredients.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(
                          child: Text(meal.ingredients[index]),
                        ),
                        Text(
                          meal.measures[index],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Instructions
          _buildSectionTitle(context, 'Instructions'),
          const SizedBox(height: 8),
          Card(
            elevation: 1,
            color: Theme.of(context).colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                meal.instructions,
                style: const TextStyle(height: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // YouTube Link
          if (meal.youtubeUrl.isNotEmpty)
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _launchUrl(context, meal.youtubeUrl),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Watch on YouTube'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Row(
      children: [
        Container(
          height: 24,
          width: 4,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}
