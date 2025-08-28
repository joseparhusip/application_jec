// lib/data/dummy_data.dart

import '../models/appointment_models.dart';

final List<Doctor> allDoctors = [
  Doctor(name: 'Dr. A. Kentar Arimadyo Sulakso, MSi. Med., SpM(K)', specialty: 'Ophthalmologist', imagePath: 'assets/docter/Dr A. Kentar Arimadyo Sulakso, MSi. Med., SpM(K).jpg'),
  Doctor(name: 'Dr. Afrisal Hari Kurniawan, SpM(K)', specialty: 'Ophthalmologist', imagePath: 'assets/docter/Dr Afrisal Hari Kurniawan, SpM(K).jpg'),
  Doctor(name: 'dr. A. Rizal Fanany, Spm(k)', specialty: 'Ophthalmologist', imagePath: 'assets/docter/dr. A. Rizal Fanany, Spm(k).jpg'),
  Doctor(name: 'Dr. Andhika Guna Dharma, SpM(K)', specialty: 'Ophthalmologist', imagePath: 'assets/docter/Dr. Andhika Guna Dharma, SpM(K).jpg'),
  Doctor(name: 'Dr. Arnila Novitasari Saubig, SpM(K)', specialty: 'Ophthalmologist', imagePath: 'assets/docter/Dr. Arnila Novitasari Saubig, SpM(K).jpg'),
  Doctor(name: 'Dr. Damara Andalia, SpM', specialty: 'Ophthalmologist', imagePath: 'assets/docter/Dr. Damara Andalia, SpM.png'),
  Doctor(name: 'Dr. dr. trilaksana nugroho, fiscm, m.kes, spmk', specialty: 'Ophthalmologist', imagePath: 'assets/docter/Dr. dr. trilaksana nugroho, fiscm, m.kes, spmk.jpg'),
  Doctor(name: 'Dr. Fatimah Dyah Nur Astuti, MARS, SpM(K)', specialty: 'Ophthalmologist', imagePath: 'assets/docter/Dr. Fatimah Dyah Nur Astuti, MARS, SpM(K).jpg'),
  Doctor(name: 'Dr. Sri Inakawati, MSi.Med., SpM(K)', specialty: 'Ophthalmologist', imagePath: 'assets/docter/Dr. Sri Inakawati, MSi.Med., SpM(K).jpg'),
  Doctor(name: 'Dr.dr. Fifin Luthfia Rahmi, MS, Sp.M(K)', specialty: 'Ophthalmologist', imagePath: 'assets/docter/Dr.dr. Fifin Luthfia Rahmi, MS, Sp.M(K).jpg'),
  Doctor(name: 'Prof. DR. Dr Winarto, Sp.MK, SpM(K)', specialty: 'Ophthalmologist', imagePath: 'assets/docter/Prof. DR. Dr Winarto, Sp.MK, SpM(K).jpg'),
];

final List<Hospital> hospitalsData = [
  Hospital(name: 'RS Mata JEC @ Menteng', doctors: allDoctors),
  Hospital(name: 'RS Mata JEC @ Kedoya', doctors: allDoctors),
  Hospital(name: 'RS Mata JEC Candi @ Semarang', doctors: allDoctors),
  Hospital(name: 'KUM JEC Java @ Surabaya', doctors: allDoctors),
  Hospital(name: 'KUM JEC BALI @ Denpasar', doctors: allDoctors),
  Hospital(name: 'RS Mata JEC Orbita @ Makassar', doctors: allDoctors),
];