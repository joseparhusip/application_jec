// lib/models/testimonial_models.dart

class Testimonial {
  final String name;
  final String role;
  final String quote;
  final String imagePath;

  const Testimonial({
    required this.name,
    required this.role,
    required this.quote,
    required this.imagePath,
  });
}