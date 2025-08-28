// lib/models/facility.dart

enum FacilityType { rs, klinik }

class Facility {
  final String name;
  final String imagePath;
  final FacilityType type;

  const Facility({
    required this.name,
    required this.imagePath,
    required this.type,
  });
}