import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/models/meal.dart';
import 'package:recipe_app/providers/meal_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class MealDetailScreen extends StatefulWidget {
  final String mealId;
  final String mealName;
  final String mealImage;

  const MealDetailScreen({
    Key? key,
    required this.mealId,
    required this.mealName,
    required this.mealImage,
  }) : super(key: key);

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  late Future<Meal> _mealFuture;
  final ScrollController _scrollController = ScrollController();
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    _mealFuture = Provider.of<MealProvider>(context, listen: false)
        .getMealDetails(widget.mealId);

    _scrollController.addListener(() {
      setState(() {
        _showTitle = _scrollController.offset > 200;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await launcher.canLaunchUrl(uri)) {
      await launcher.launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
    }
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Row(
      children: [
        Container(
          width: 5,
          height: 25,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Meal>(
        future: _mealFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final meal = snapshot.data!;

          return CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 300.0,
                floating: false,
                pinned: true,
                stretch: true,
                title: _showTitle
                    ? Text(
                        meal.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'meal_image_${meal.id}',
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          meal.thumbUrl,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: Text(
                            meal.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  Consumer<MealProvider>(
                    builder: (context, mealProvider, _) {
                      final isFavorite = mealProvider.isFavorite(meal.id);
                      return IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : null,
                        ),
                        onPressed: () {
                          mealProvider.toggleFavorite(meal);
                        },
                      );
                    },
                  ),
                ],
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category, Area and Tags info
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Chip(
                              avatar: const Icon(Icons.category),
                              label: Text(meal.category),
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                            Chip(
                              avatar: const Icon(Icons.public),
                              label: Text(meal.area),
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                            ),
                            if (meal.tags.isNotEmpty)
                              ...meal.tags.split(',').map((tag) => Chip(
                                    avatar: const Icon(Icons.tag),
                                    label: Text(tag.trim()),
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .tertiaryContainer,
                                  )),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Ingredients Section
                        _buildSectionTitle(context, 'Ingredients'),
                        const SizedBox(height: 8),
                        Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: List.generate(
                                meal.ingredients.length,
                                (index) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.check_circle_outline),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          meal.ingredients[index],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                      ),
                                      Text(
                                        meal.measures[index],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Instructions Section
                        _buildSectionTitle(context, 'Instructions'),
                        const SizedBox(height: 8),
                        Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              meal.instructions,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Watch on YouTube button
                        if (meal.youtubeUrl.isNotEmpty)
                          Center(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                              ),
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('Watch on YouTube'),
                              onPressed: () => _launchUrl(meal.youtubeUrl),
                            ),
                          ),

                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          );
        },
      ),
    );
  }
}
