/// Mock astrologer model for development
/// TODO: Replace with actual Astrologer model from backend
class MockAstrologer {
  final String id;
  final String name;
  final String specialty;
  final double rating;
  final int reviewCount;
  final String imageUrl;

  MockAstrologer({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
  });
}
