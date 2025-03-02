import 'package:recipe_app/models/meal.dart';

class MealDetail {
  final Meal meal;
  final bool isLoading;
  final String? error;

  MealDetail({
    required this.meal,
    this.isLoading = false,
    this.error,
  });

  MealDetail copyWith({
    Meal? meal,
    bool? isLoading,
    String? error,
  }) {
    return MealDetail(
      meal: meal ?? this.meal,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  // Factory constructor to create an initial loading state
  factory MealDetail.loading({Meal? placeholder}) {
    return MealDetail(
      meal: placeholder ??
          Meal(
            id: '',
            name: 'Loading...',
            thumbUrl: '', // Fixed: Changed thumbnail to thumbUrl
            category: '',
            area: '',
            instructions: '',
            youtubeUrl: '', // Fixed: Changed youtubeLink to youtubeUrl
            ingredients: const [],
            measures: const [],
            tags: '',
          ),
      isLoading: true,
    );
  }
}
