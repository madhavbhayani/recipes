import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/providers/meal_provider.dart';
import 'package:recipe_app/widgets/meal_grid.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:recipe_app/widgets/loading_indicator.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _search() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      setState(() {
        _isSearching = true;
      });
      Provider.of<MealProvider>(context, listen: false)
          .searchMeals(query)
          .then((_) {
        setState(() {
          _isSearching = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Recipes'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Search for recipes...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
              ),
              onChanged: (value) {
                setState(() {});
              },
              onSubmitted: (_) => _search(),
              textInputAction: TextInputAction.search,
            ).animate().fadeIn(duration: const Duration(milliseconds: 500)),
          ),
          Expanded(
            child: Consumer<MealProvider>(
              builder: (ctx, mealProvider, child) {
                if (_isSearching) {
                  return const LoadingIndicator(
                    message: 'Searching for recipes...',
                  );
                }

                if (mealProvider.error.isNotEmpty) {
                  return Center(
                    child: Text(
                      mealProvider.error,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (mealProvider.meals.isEmpty &&
                    _searchController.text.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 72,
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No recipes found for "${_searchController.text}"',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Try a different search term',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ).animate().fade().scale(),
                  );
                }

                // When nothing is searched yet
                if (mealProvider.meals.isEmpty &&
                    _searchController.text.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          size: 72,
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Search for delicious recipes',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try searching for "Chicken", "Pasta", "Beef", etc.',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                      ],
                    ).animate().fade().scale(),
                  );
                }

                return MealGrid(meals: mealProvider.meals);
              },
            ),
          ),
        ],
      ),
    );
  }
}
