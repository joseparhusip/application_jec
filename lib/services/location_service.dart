import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<bool> requestLocationPermission() async {
    try {
      // Check permission status
      PermissionStatus permission = await Permission.location.status;
      
      if (permission.isDenied) {
        // Request permission
        permission = await Permission.location.request();
      }
      
      if (permission.isPermanentlyDenied) {
        // Open app settings
        await openAppSettings();
        return false;
      }
      
      return permission.isGranted;
    } catch (e) {
      print('Error requesting location permission: $e');
      return false;
    }
  }
  
  static Future<Position?> getCurrentLocation() async {
    try {
      bool hasPermission = await requestLocationPermission();
      
      if (!hasPermission) {
        return null;
      }
      
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      return position;
    } catch (e) {
      print('Error getting current location: $e');
      return null;
    }
  }
}