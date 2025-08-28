// models/hospital_model.dart

class Hospital {
  final String id;
  final String name;
  final String type; // 'RS' atau 'Klinik'
  final String address;
  final String phone;
  final String imagePath;
  final List<String> facilities;
  final double rating;
  final String distance;
  final bool isOpen;
  final String operatingHours;

  Hospital({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.phone,
    required this.imagePath,
    required this.facilities,
    required this.rating,
    required this.distance,
    required this.isOpen,
    required this.operatingHours,
  });

  // Method untuk konversi dari JSON (jika diperlukan untuk API)
  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      imagePath: json['imagePath'] ?? '',
      facilities: List<String>.from(json['facilities'] ?? []),
      rating: (json['rating'] ?? 0.0).toDouble(),
      distance: json['distance'] ?? '',
      isOpen: json['isOpen'] ?? false,
      operatingHours: json['operatingHours'] ?? '',
    );
  }

  // Method untuk konversi ke JSON (jika diperlukan untuk API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'address': address,
      'phone': phone,
      'imagePath': imagePath,
      'facilities': facilities,
      'rating': rating,
      'distance': distance,
      'isOpen': isOpen,
      'operatingHours': operatingHours,
    };
  }
}

// Data dummy untuk testing
class HospitalData {
  static List<Hospital> getAllHospitals() {
    return [
      Hospital(
        id: '1',
        name: 'JEC Bekasi',
        type: 'RS',
        address: 'Jl. Ahmad Yani No. 1, Bekasi',
        phone: '(021) 8888-1234',
        imagePath: 'assets/fasilitas/JEC-Bekasi.jpg',
        facilities: ['ICU', 'IGD', 'Lab', 'Radiologi', 'Farmasi'],
        rating: 4.5,
        distance: '2.3 km',
        isOpen: true,
        operatingHours: '24 Jam',
      ),
      Hospital(
        id: '2',
        name: 'JEC Candi',
        type: 'Klinik',
        address: 'Jl. Candi Raya No. 15, Bekasi',
        phone: '(021) 7777-5678',
        imagePath: 'assets/fasilitas/JEC-Candi.jpg',
        facilities: ['Poli Umum', 'Lab', 'Farmasi'],
        rating: 4.2,
        distance: '1.8 km',
        isOpen: true,
        operatingHours: '08:00 - 20:00',
      ),
      Hospital(
        id: '3',
        name: 'JEC Kedoya',
        type: 'RS',
        address: 'Jl. Kedoya Raya No. 22, Jakarta Barat',
        phone: '(021) 5555-9999',
        imagePath: 'assets/fasilitas/JEC-Kedoya.jpg',
        facilities: ['ICU', 'IGD', 'Lab', 'Radiologi', 'Farmasi', 'CT Scan'],
        rating: 4.7,
        distance: '5.1 km',
        isOpen: true,
        operatingHours: '24 Jam',
      ),
      Hospital(
        id: '4',
        name: 'JEC Menteng',
        type: 'Klinik',
        address: 'Jl. Menteng Dalam No. 8, Jakarta Pusat',
        phone: '(021) 3333-4444',
        imagePath: 'assets/fasilitas/JEC-Menteng.jpg',
        facilities: ['Poli Umum', 'Poli Gigi', 'Lab', 'Farmasi'],
        rating: 4.0,
        distance: '7.2 km',
        isOpen: false,
        operatingHours: '08:00 - 17:00',
      ),
      Hospital(
        id: '5',
        name: 'JEC Primasana',
        type: 'RS',
        address: 'Jl. Primasana No. 10, Bekasi',
        phone: '(021) 2222-7777',
        imagePath: 'assets/fasilitas/JEC-Primasana.jpg',
        facilities: ['ICU', 'IGD', 'Lab', 'Radiologi', 'Farmasi', 'MRI'],
        rating: 4.6,
        distance: '3.4 km',
        isOpen: true,
        operatingHours: '24 Jam',
      ),
      Hospital(
        id: '6',
        name: 'JEC Tambora',
        type: 'Klinik',
        address: 'Jl. Tambora Raya No. 25, Jakarta Barat',
        phone: '(021) 1111-8888',
        imagePath: 'assets/fasilitas/JEC-Tambora.jpg',
        facilities: ['Poli Umum', 'Poli Anak', 'Lab', 'Farmasi'],
        rating: 3.8,
        distance: '6.7 km',
        isOpen: true,
        operatingHours: '07:00 - 19:00',
      ),
    ];
  }

  // Method untuk filter berdasarkan tipe
  static List<Hospital> getHospitalsByType(String type) {
    if (type == 'Semua') {
      return getAllHospitals();
    }
    return getAllHospitals().where((hospital) => hospital.type == type).toList();
  }

  // Method untuk search
  static List<Hospital> searchHospitals(String query) {
    if (query.isEmpty) {
      return getAllHospitals();
    }
    return getAllHospitals()
        .where((hospital) =>
            hospital.name.toLowerCase().contains(query.toLowerCase()) ||
            hospital.address.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}