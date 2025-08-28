// rs_detail_page.dart (UPDATED)

import 'package:flutter/material.dart';
// [DIUBAH] Impor model dari file baru
import 'package:application_jec_frontend/models/rs_klinik_models.dart'; 

class RsDetailPage extends StatelessWidget {
  final RumahSakit rs;

  const RsDetailPage({super.key, required this.rs});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: screenSize.height * 0.3,
            pinned: true,
            stretch: true,
            backgroundColor: colorScheme.primary,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                rs.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 16.0, left: 50, right: 50),
              background: Hero(
                tag: rs.imagePath,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      rs.imagePath,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                          stops: const [0.5, 1.0],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: colorScheme.surface,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, 'Lokasi'),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Icon(Icons.location_on_outlined, color: colorScheme.primary, size: 30),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              rs.address,
                              style: theme.textTheme.bodyLarge?.copyWith(height: 1.4),
                            ),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            icon: Icon(Icons.map_outlined, color: colorScheme.secondary, size: 30),
                            onPressed: () {
                              // TODO: Implementasi navigasi ke Google Maps dengan koordinat rs.coordinates
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  _buildSectionTitle(context, 'Tentang Kami'),
                  const SizedBox(height: 10),
                  Text(
                    rs.description,
                    textAlign: TextAlign.justify,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.8),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 25),
                  _buildSectionTitle(context, 'Layanan Unggulan'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: rs.services.map((service) => Chip(
                      label: Text(service),
                      backgroundColor: colorScheme.secondaryContainer.withOpacity(0.5),
                      labelStyle: TextStyle(color: colorScheme.onSecondaryContainer, fontWeight: FontWeight.w500),
                      side: BorderSide.none,
                    )).toList(),
                  ),
                  const SizedBox(height: 25),
                  _buildSectionTitle(context, 'Dokter Kami'),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: rs.doctors.length,
                      itemBuilder: (context, index) {
                        final doctor = rs.doctors[index];
                        return _buildDoctorCard(context, doctor);
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                  _buildSectionTitle(context, 'Galeri'),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: rs.galleryImages.length,
                      itemBuilder: (context, index) {
                        return _buildGalleryImage(context, rs.galleryImages[index]);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.calendar_month_outlined),
            label: const Text('Buat Janji Temu'),
            onPressed: () {
              // TODO: Implementasi navigasi ke halaman buat janji temu
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: const Color(0xFF38A1C1),
              foregroundColor: Colors.white,
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
    );
  }
  
  Widget _buildDoctorCard(BuildContext context, Doctor doctor) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 15),
      child: Column(
        children: [
          CircleAvatar(
            radius: 45,
            backgroundImage: AssetImage(doctor.imagePath),
            backgroundColor: Colors.grey.shade200,
          ),
          const SizedBox(height: 8),
          Text(
            doctor.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            doctor.specialist,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
  
  Widget _buildGalleryImage(BuildContext context, String imagePath) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}