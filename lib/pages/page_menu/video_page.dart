import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:application_jec_frontend/models/video_info_models.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> 
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  
  @override
  bool get wantKeepAlive => true; // Keep state alive untuk performa

  // Optimasi: Static data untuk menghindari rebuild
  static const List<Map<String, dynamic>> _videoData = [
    {
      'videoId': 'XvqFAQeG750',
      'title': 'Operasi Katarak Premium di JEC',
      'description': 'Prosedur operasi katarak terdepan dengan teknologi premium',
      'minutes': 3,
      'seconds': 45,
    },
    {
      'videoId': 'nTS8xgy-rK8',
      'title': 'Apa Itu LASIK? Penjelasan dari Dokter JEC',
      'description': 'Penjelasan lengkap tentang prosedur LASIK oleh dokter ahli',
      'minutes': 5,
      'seconds': 12,
    },
    {
      'videoId': 'MU1hIFe01w0',
      'title': 'Testimoni Pasien Setelah Prosedur ReLEx SMILE',
      'description': 'Pengalaman nyata pasien yang telah menjalani ReLEx SMILE',
      'minutes': 4,
      'seconds': 20,
    },
    {
      'videoId': '8M2yNcxIpWY',
      'title': 'Mengenal Layanan JEC @ Menteng',
      'description': 'Tour virtual fasilitas JEC di kawasan Menteng',
      'minutes': 6,
      'seconds': 30,
    },
    {
      'videoId': '2KMaH40EvP0',
      'title': 'JEC World Sight Day 2023',
      'description': 'Perayaan Hari Penglihatan Sedunia bersama JEC',
      'minutes': 8,
      'seconds': 15,
    },
  ];

  // Lazy initialization untuk video objects
  late final List<VideoInfo> _videos;
  late YoutubePlayerController _controller;
  late AnimationController _fadeController;
  
  int _currentlyPlayingIndex = 0;
  bool _isPlayerReady = false;
  bool _isLoading = false;
  double _volume = 0.5;

  // Cache untuk thumbnails
  final Map<String, String> _thumbnailCache = {};

  @override
  void initState() {
    super.initState();
    _initializeData();
    _initializeAnimations();
    _initializePlayer();
  }

  void _initializeData() {
    // Convert static data to VideoInfo objects hanya sekali
    _videos = _videoData.map((data) => VideoInfo(
      videoId: data['videoId'] as String,
      title: data['title'] as String,
      description: data['description'] as String,
      duration: Duration(
        minutes: data['minutes'] as int, 
        seconds: data['seconds'] as int
      ),
    )).toList();

    // Pre-cache thumbnail URLs
    for (final video in _videos) {
      _thumbnailCache[video.videoId] = YoutubePlayer.getThumbnail(
        videoId: video.videoId,
        quality: ThumbnailQuality.medium,
      );
    }
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeController.forward();
  }

  void _initializePlayer() {
    _controller = YoutubePlayerController(
      initialVideoId: _videos.first.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        forceHD: false,
        enableCaption: true,
        loop: false,
        hideControls: false,
        controlsVisibleAtStart: true,
        showLiveFullscreenButton: true,
      ),
    )..addListener(_playerListener);

    // Optimized volume setting
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _controller.value.isReady) {
        _controller.setVolume((_volume * 100).round());
      }
    });
  }

  void _playerListener() {
    if (!mounted) return;
    
    final isReady = _controller.value.isReady;
    final playerState = _controller.value.playerState;
    
    // Batch state updates untuk mengurangi rebuilds
    bool shouldUpdate = false;
    Map<String, dynamic> updates = {};

    if (!_isPlayerReady && isReady) {
      updates['isPlayerReady'] = true;
      updates['isLoading'] = false;
      shouldUpdate = true;
      _controller.setVolume((_volume * 100).round());
    }
    
    if (_isLoading && playerState == PlayerState.playing) {
      updates['isLoading'] = false;
      shouldUpdate = true;
    }

    if (shouldUpdate) {
      setState(() {
        if (updates.containsKey('isPlayerReady')) _isPlayerReady = updates['isPlayerReady'];
        if (updates.containsKey('isLoading')) _isLoading = updates['isLoading'];
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_playerListener);
    _controller.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  // Optimized video selection dengan debouncing
  void _selectVideo(int index) {
    if (_currentlyPlayingIndex == index || !mounted) return;

    setState(() {
      _currentlyPlayingIndex = index;
      _isLoading = true;
    });

    _controller.load(_videos[index].videoId);

    // Optimized volume setting dengan timeout yang lebih pendek
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && _controller.value.isReady) {
        _controller.setVolume((_volume * 100).round());
      }
    });
  }

  void _setVolume(double value) {
    _volume = value;
    if (_controller.value.isReady) {
      _controller.setVolume((value * 100).round());
    }
  }

  Future<void> _launchYouTube(String videoId) async {
    final Uri url = Uri.parse('https://www.youtube.com/watch?v=$videoId');
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch YouTube');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak dapat membuka YouTube'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  // Optimized duration formatting dengan caching
  static final Map<Duration, String> _durationCache = {};
  String _formatDuration(Duration duration) {
    return _durationCache.putIfAbsent(duration, () {
      final minutes = duration.inMinutes.toString().padLeft(2, "0");
      final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, "0");
      return "$minutes:$seconds";
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    final theme = Theme.of(context);
    final currentVideo = _videos[_currentlyPlayingIndex];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: _buildOptimizedAppBar(theme),
      ),
      body: Column(
        children: [
          // Video Player dengan Hero animation untuk smooth transitions
          Hero(
            tag: 'video_player',
            child: _buildVideoPlayer(theme),
          ),
          
          // Video Info dengan AnimatedContainer untuk smooth updates
          _buildVideoInfo(theme, currentVideo),
          
          // Playlist Header
          _buildPlaylistHeader(theme),
          
          // Optimized ListView dengan itemExtent untuk better performance
          Expanded(
            child: _buildOptimizedPlaylist(),
          ),
        ],
      ),
    );
  }

  Widget _buildOptimizedAppBar(ThemeData theme) {
    return AppBar(
      title: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white24,
            child: Icon(Icons.play_circle_fill, size: 20, color: Colors.white),
          ),
          SizedBox(width: 12),
          Text('JEC Video Gallery'),
        ],
      ),
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.volume_up),
          onPressed: _showVolumeDialog,
          tooltip: 'Pengaturan Volume',
        ),
      ],
    );
  }

  Widget _buildVideoPlayer(ThemeData theme) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: theme.colorScheme.primary,
              progressColors: ProgressBarColors(
                playedColor: theme.colorScheme.primary,
                handleColor: theme.colorScheme.secondary,
                backgroundColor: Colors.grey.withAlpha(77),
              ),
              bottomActions: const [
                CurrentPosition(),
                SizedBox(width: 8),
                ProgressBar(isExpanded: true),
                SizedBox(width: 8),
                RemainingDuration(),
                PlaybackSpeedButton(),
                FullScreenButton(),
              ],
            ),
          ),
          if (_isLoading)
            const AspectRatio(
              aspectRatio: 16 / 9,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.black54),
                child: Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVideoInfo(ThemeData theme, VideoInfo currentVideo) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentVideo.title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currentVideo.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                        height: 1.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    _buildVideoMetadata(theme, currentVideo),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildActionButton(
                    icon: Icons.open_in_new,
                    color: Colors.red,
                    tooltip: 'Buka di YouTube',
                    onPressed: () => _launchYouTube(currentVideo.videoId),
                  ),
                  const SizedBox(width: 8),
                  _buildActionButton(
                    icon: Icons.volume_up,
                    color: theme.colorScheme.primary,
                    tooltip: 'Pengaturan Volume',
                    onPressed: _showVolumeDialog,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVideoMetadata(ThemeData theme, VideoInfo currentVideo) {
    return Row(
      children: [
        Icon(Icons.business, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            'JEC Eye Hospitals & Clinics',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          _formatDuration(currentVideo.duration),
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildPlaylistHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withAlpha(26),
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.playlist_play, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            'Playlist Video JEC',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const Spacer(),
          Text(
            '${_videos.length} video',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptimizedPlaylist() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _videos.length,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        color: Colors.grey[200],
      ),
      itemBuilder: (context, index) {
        return SizedBox(
          height: 96, // Increased height untuk mencegah overflow
          child: _VideoListItem(
            video: _videos[index],
            index: index,
            isSelected: _currentlyPlayingIndex == index,
            thumbnailUrl: _thumbnailCache[_videos[index].videoId]!,
            onTap: () => _selectVideo(index),
            formatDuration: _formatDuration,
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: color.withAlpha(26),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }

  void _showVolumeDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _VolumeDialog(
        initialVolume: _volume,
        onVolumeChanged: _setVolume,
      ),
    );
  }
}

// Separate widget untuk video list item untuk better performance
class _VideoListItem extends StatelessWidget {
  final VideoInfo video;
  final int index;
  final bool isSelected;
  final String thumbnailUrl;
  final VoidCallback onTap;
  final String Function(Duration) formatDuration;

  const _VideoListItem({
    required this.video,
    required this.index,
    required this.isSelected,
    required this.thumbnailUrl,
    required this.onTap,
    required this.formatDuration,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Material(
      color: isSelected 
          ? theme.colorScheme.primary.withAlpha(20) 
          : Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Reduced padding
          child: Row(
            children: [
              _buildIndicator(theme),
              const SizedBox(width: 10), // Reduced spacing
              _buildThumbnail(),
              const SizedBox(width: 10), // Reduced spacing
              Expanded(
                child: _buildVideoDetails(theme),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(ThemeData theme) {
    return SizedBox(
      width: 28,
      height: 28,
      child: isSelected
          ? CircleAvatar(
              backgroundColor: theme.colorScheme.primary,
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 16,
              ),
            )
          : CircleAvatar(
              backgroundColor: Colors.grey[100],
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
    );
  }

  Widget _buildThumbnail() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 100,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.network(
            thumbnailUrl,
            fit: BoxFit.cover,
            loadingBuilder: (_, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: Colors.grey[200],
                child: const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            },
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey[200],
              child: const Icon(Icons.error, color: Colors.grey, size: 20),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoDetails(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min, // Prevent overflow
      children: [
        Text(
          video.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 13, // Slightly smaller font
            color: isSelected ? theme.colorScheme.primary : Colors.grey[800],
            height: 1.1, // Reduced line height
          ),
        ),
        const SizedBox(height: 1), // Reduced spacing
        Text(
          video.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 11, // Smaller font
            color: Colors.grey[600],
            height: 1.1,
          ),
        ),
        const SizedBox(height: 2), // Reduced spacing
        Text(
          formatDuration(video.duration),
          style: TextStyle(
            fontSize: 10, // Smaller font
            color: Colors.grey[500],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// Separate dialog widget untuk volume control
class _VolumeDialog extends StatefulWidget {
  final double initialVolume;
  final Function(double) onVolumeChanged;

  const _VolumeDialog({
    required this.initialVolume,
    required this.onVolumeChanged,
  });

  @override
  State<_VolumeDialog> createState() => _VolumeDialogState();
}

class _VolumeDialogState extends State<_VolumeDialog> {
  late double _volume;

  @override
  void initState() {
    super.initState();
    _volume = widget.initialVolume;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.volume_up, color: Colors.blue),
          SizedBox(width: 8),
          Text('Pengaturan Volume'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.volume_down, size: 20),
              Expanded(
                child: Slider(
                  value: _volume,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  label: '${(_volume * 100).round()}%',
                  onChanged: (value) {
                    setState(() => _volume = value);
                    widget.onVolumeChanged(value);
                  },
                ),
              ),
              const Icon(Icons.volume_up, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Volume: ${(_volume * 100).round()}%',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() => _volume = 0.5);
            widget.onVolumeChanged(0.5);
          },
          child: const Text('Reset'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Tutup'),
        ),
      ],
    );
  }
}