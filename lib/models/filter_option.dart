enum FilterType {
  category,
  area,
  ingredient,
}

class FilterOption {
  final String name;
  final FilterType type;

  FilterOption({
    required this.name,
    required this.type,
  });
}
