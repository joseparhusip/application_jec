// lib/models/video_info_model.dart

// Model untuk menyimpan informasi video
class VideoInfo {
  final String videoId;
  final String title;
  final String description;
  final Duration duration;

  VideoInfo({
    required this.videoId,
    required this.title,
    required this.description,
    required this.duration,
  });
}