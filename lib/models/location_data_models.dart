// lib/models/location_data_models.dart

import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationData {
  final String id;
  final String name;
  final String address;
  final String imagePath;
  final LatLng coordinates;

  const LocationData({
    required this.id,
    required this.name,
    required this.address,
    required this.imagePath,
    required this.coordinates,
  });
}