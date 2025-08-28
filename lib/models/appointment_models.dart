// lib/models/appointment_models.dart

class Doctor {
  final String name;
  final String specialty;
  final String imagePath;

  Doctor({
    required this.name,
    required this.specialty,
    required this.imagePath,
  });
}

class Hospital {
  final String name;
  final List<Doctor> doctors;

  Hospital({
    required this.name,
    required this.doctors,
  });
}