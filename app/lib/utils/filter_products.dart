import '../data/models.dart';

/// Pure function to filter venues by wellness category.
///
/// Returns only wellness category items when [wellnessActive] is true,
/// otherwise returns all items.
///
/// This implements client-side filtering per ADR-001.
List<Venue> filterProductsByWellness(List<Venue> products, bool wellnessActive) {
  if (!wellnessActive) {
    return products;
  }
  return products.where((p) => p.category == 'Wellness').toList();
}
