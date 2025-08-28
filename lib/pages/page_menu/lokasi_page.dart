// lib/pages/lokasi_page.dart (KODE LENGKAP & DIPERBARUI)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
// --- PERUBAHAN: Import model yang sudah dipisah dengan nama file baru ---
import 'package:application_jec_frontend/models/location_data_models.dart';

class LokasiPage extends StatefulWidget {
  const LokasiPage({super.key});

  @override
  State<LokasiPage> createState() => _LokasiPageState();
}

class _LokasiPageState extends State<LokasiPage> with AutomaticKeepAliveClientMixin {
  static const List<LocationData> _locations = [
    LocationData(id: 'jec-menteng', name: 'RS Mata JEC @ Menteng', address: 'Jl. Cik Ditiro No.46, Menteng, Jakarta Pusat 10310', imagePath: 'assets/fasilitas/JEC-Menteng.jpg', coordinates: LatLng(-6.1953, 106.8335)),
    LocationData(id: 'jec-kedoya', name: 'RS Mata JEC @ Kedoya', address: 'Jl. Terusan Arjuna Utara No. 1, Kedoya, Jakarta Barat 11520', imagePath: 'assets/fasilitas/JEC-Kedoya.jpg', coordinates: LatLng(-6.1731, 106.7643)),
    LocationData(id: 'kum-cibubur', name: 'KUM JEC @ Cibubur', address: 'Jl. Raya Alternatif Cibubur No. 1, Bekasi 17435', imagePath: 'assets/fasilitas/JEC-Bekasi.jpg', coordinates: LatLng(-6.3686, 106.9194)),
    LocationData(id: 'jec-primasana', name: 'RS Mata JEC PRIMASANA @ Tj. Priok', address: 'Jl. Papanggo Raya No. 3, Tj. Priok, Jakarta Utara 14340', imagePath: 'assets/fasilitas/JEC-Primasana.jpg', coordinates: LatLng(-6.1268, 106.8841)),
    LocationData(id: 'jec-candi', name: 'RS Mata JEC CANDI @ Semarang', address: 'Jl. Sisingamangaraja No.4, Candi, Semarang 50252', imagePath: 'assets/fasilitas/JEC-Candi.jpg', coordinates: LatLng(-7.0142, 110.4194)),
  ];

  static Set<Marker>? _cachedMarkers;
  GoogleMapController? _mapController;
  String? _darkMapStyle;
  bool _mapStyleLoaded = false;
  bool _hasMapError = false;
  bool _isMapControllerReady = false;
  String _errorMessage = '';

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(-6.2088, 106.8456),
    zoom: 11.0,
  );

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeMarkersOnce();
    _loadMapStyles();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _initializeMarkersOnce() {
    if (_cachedMarkers == null) {
      _cachedMarkers = <Marker>{};
      for (final location in _locations) {
        final marker = Marker(
          markerId: MarkerId(location.id),
          position: location.coordinates,
          infoWindow: InfoWindow(
            title: location.name,
            snippet: location.address,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          onTap: () => _onMarkerTapped(location),
        );
        _cachedMarkers!.add(marker);
      }
    }
  }

  Future<void> _loadMapStyles() async {
    try {
      _darkMapStyle = await rootBundle.loadString('assets/map_styles/dark_theme.json');
      if (mounted) {
        setState(() {
          _mapStyleLoaded = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _mapStyleLoaded = true;
        });
      }
    }
  }

  void _onMarkerTapped(LocationData location) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildLocationDetail(location),
    );
  }

  Widget _buildLocationDetail(LocationData location) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            location.name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            location.address,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () => _navigateToLocation(location),
                icon: const Icon(Icons.directions),
                label: const Text('Navigasi'),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                label: const Text('Tutup'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToLocation(LocationData location) {
    if (_mapController != null && _isMapControllerReady) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: location.coordinates,
            zoom: 16.0,
          ),
        ),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _zoomIn() async {
    if (_mapController != null && _isMapControllerReady) {
      try {
        await _mapController!.animateCamera(CameraUpdate.zoomIn());
      } catch (e) {
        debugPrint('Error zooming in: $e');
      }
    }
  }

  Future<void> _zoomOut() async {
    if (_mapController != null && _isMapControllerReady) {
      try {
        await _mapController!.animateCamera(CameraUpdate.zoomOut());
      } catch (e) {
        debugPrint('Error zooming out: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          if (!_mapStyleLoaded)
            Container(
              color: colorScheme.surface,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator.adaptive(),
                    SizedBox(height: 16),
                    Text('Memuat peta...'),
                  ],
                ),
              ),
            ),
          
          if (_hasMapError)
            Container(
              color: colorScheme.surface,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: colorScheme.error),
                    const SizedBox(height: 16),
                    Text(
                      'Gagal memuat peta',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _hasMapError = false;
                          _mapStyleLoaded = false;
                          _isMapControllerReady = false;
                        });
                        _loadMapStyles();
                      },
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            ),
          
          if (_mapStyleLoaded && !_hasMapError)
            RepaintBoundary(
              child: GoogleMap(
                initialCameraPosition: _initialCameraPosition,
                style: (isDarkMode && _darkMapStyle != null) ? _darkMapStyle : null,
                onMapCreated: (controller) async {
                  try {
                    _mapController = controller;
                    await Future.delayed(const Duration(milliseconds: 500));
                    if (mounted) {
                      setState(() {
                        _isMapControllerReady = true;
                      });
                    }
                  } catch (e) {
                    debugPrint('Map creation error: $e');
                    if (mounted) {
                      setState(() {
                        _hasMapError = true;
                        _errorMessage = 'Pastikan API Key Google Maps valid dan internet terhubung';
                      });
                    }
                  }
                },
                markers: _cachedMarkers ?? <Marker>{},
                myLocationButtonEnabled: false,
                myLocationEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                liteModeEnabled: false,
                compassEnabled: false,
                rotateGesturesEnabled: true,
                scrollGesturesEnabled: true,
                tiltGesturesEnabled: false,
                zoomGesturesEnabled: true,
                onTap: (_) {},
              ),
            ),

          if (_mapStyleLoaded && !_hasMapError) ...[
            RepaintBoundary(child: _HeaderWidget(colorScheme: colorScheme)),
            _ZoomControlsWidget(
              onZoomIn: _zoomIn,
              onZoomOut: _zoomOut,
              colorScheme: colorScheme,
              isControllerReady: _isMapControllerReady,
            ),
            RepaintBoundary(
              child: _DraggableSheetWidget(
                locations: _locations,
                onLocationTap: _onMarkerTapped,
                colorScheme: colorScheme,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _HeaderWidget extends StatelessWidget {
  final ColorScheme colorScheme;
  
  const _HeaderWidget({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari Rumah Sakit/Klinik',
                  filled: true,
                  fillColor: colorScheme.surface,
                  prefixIcon: Icon(
                    Icons.search,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                  hintStyle: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ZoomControlsWidget extends StatelessWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final ColorScheme colorScheme;
  final bool isControllerReady;
  
  const _ZoomControlsWidget({
    required this.onZoomIn,
    required this.onZoomOut,
    required this.colorScheme,
    required this.isControllerReady,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Positioned(
      top: screenHeight * 0.55,
      right: 16,
      child: RepaintBoundary(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(25),
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey.shade300, width: 0.5),
                ),
                child: InkWell(
                  onTap: isControllerReady ? onZoomIn : null,
                  borderRadius: BorderRadius.circular(25),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(
                      Icons.add,
                      color: isControllerReady 
                        ? colorScheme.onSurface 
                        : colorScheme.onSurface.withOpacity(0.3),
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(25),
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey.shade300, width: 0.5),
                ),
                child: InkWell(
                  onTap: isControllerReady ? onZoomOut : null,
                  borderRadius: BorderRadius.circular(25),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(
                      Icons.remove,
                      color: isControllerReady 
                        ? colorScheme.onSurface 
                        : colorScheme.onSurface.withOpacity(0.3),
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DraggableSheetWidget extends StatelessWidget {
  final List<LocationData> locations;
  final Function(LocationData) onLocationTap;
  final ColorScheme colorScheme;
  
  const _DraggableSheetWidget({
    required this.locations,
    required this.onLocationTap,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.15,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, -2),
              )
            ],
          ),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.local_hospital,
                            color: colorScheme.primary,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Rumah Sakit Terdekat',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: locations.length,
                    cacheExtent: 1000,
                    itemBuilder: (context, index) {
                      return _LocationCard(
                        location: locations[index],
                        onTap: () => onLocationTap(locations[index]),
                        colorScheme: colorScheme,
                      );
                    },
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 80),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LocationCard extends StatelessWidget {
  final LocationData location;
  final VoidCallback? onTap;
  final ColorScheme colorScheme;
  
  const _LocationCard({
    required this.location,
    required this.colorScheme,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.asset(
                  location.imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  cacheWidth: 360,
                  cacheHeight: 240,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.local_hospital,
                        size: 50,
                        color: colorScheme.primary.withOpacity(0.5),
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        location.address,
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}