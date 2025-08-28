// models/rs_klinik_models.dart

// Model data untuk Dokter
class Doctor {
  final String name;
  final String specialist;
  final String imagePath;

  Doctor({
    required this.name,
    required this.specialist,
    required this.imagePath,
  });
}

// Model data untuk rumah sakit/klinik
class RumahSakit {
  final String name;
  final String address;
  final String imagePath;
  final String description;
  final List<String> services;
  final List<Doctor> doctors;
  final List<String> galleryImages;
  final Map<String, double> coordinates;

  RumahSakit({
    required this.name,
    required this.address,
    required this.imagePath,
    required this.description,
    required this.services,
    required this.doctors,
    required this.galleryImages,
    required this.coordinates,
  });
}