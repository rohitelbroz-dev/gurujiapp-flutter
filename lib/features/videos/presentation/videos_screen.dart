import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:guruji/core/widgets/app_bottom_nav.dart';
import 'package:guruji/features/videos/bloc/videos_bloc.dart';
import 'package:guruji/features/videos/bloc/videos_event.dart';
import 'package:guruji/features/videos/bloc/videos_state.dart';
import 'package:guruji/features/videos/models/video_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideosScreen extends StatefulWidget {
  final String initialType;

  const VideosScreen({super.key, this.initialType = 'regular'});

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  int _currentPage = 1;
  final int _limit = 10;
  int _totalPages = 0;
  YoutubePlayerController? _playerController;
  String? _selectedVideoId;
  late String _selectedType;

  static const Color primaryPlum = Color(0xFF7E2B58);
  static const Color richRose = Color(0xFF8E3763);
  static const Color mauveAccent = Color(0xFFCE6590);
  static const Color bgEnd = Color(0xFFFBF4F7);
  static const Color charcoalText = Color(0xFF1F1A1D);
  static const Color subtitleColor = Color(0xFF6B5F66);

  @override
  void initState() {
    super.initState();
    final rawType = widget.initialType.trim().toLowerCase();
    if (const ['short', 'regular', 'live', 'all'].contains(rawType)) {
      _selectedType = rawType;
    } else {
      _selectedType = 'regular';
    }
    _loadVideos();
  }

  void _loadVideos() {
    context.read<VideosBloc>().add(
      FetchVideosEvent(page: _currentPage, limit: _limit, type: _selectedType),
    );
  }

  void _clearSelectedVideo() {
    _playerController?.dispose();
    _playerController = null;
    _selectedVideoId = null;
  }

  void _changeVideoType(String type) {
    if (_selectedType == type) return;

    setState(() {
      _selectedType = type;
      _currentPage = 1;
      _clearSelectedVideo();
    });
    _loadVideos();
  }

  void _playVideo(String youtubeId) {
    if (_playerController == null) {
      _playerController = YoutubePlayerController(
        initialVideoId: youtubeId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          enableCaption: true,
        ),
      );
    } else {
      _playerController!.load(youtubeId);
      _playerController!.play();
    }

    setState(() {
      _selectedVideoId = youtubeId;
    });
  }

  void _handleBack() {
    if (_selectedVideoId != null) {
      setState(() {
        _clearSelectedVideo();
      });
      return;
    }
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }

  @override
  void dispose() {
    _clearSelectedVideo();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        backgroundColor: bgEnd,
        appBar: isLandscape
            ? null
            : AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: primaryPlum),
                  onPressed: _handleBack,
                ),
                title: const Text(
                  'Divine Satsang & Videos',
                  style: TextStyle(
                    color: primaryPlum,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    fontFamily: 'serif',
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded, color: primaryPlum),
                    onPressed: _loadVideos,
                  ),
                ],
              ),
        body: BlocListener<VideosBloc, VideosState>(
          listener: (context, state) {
            if (state is VideosFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red.shade700,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          child: BlocBuilder<VideosBloc, VideosState>(
            builder: (context, state) {
              if (state is VideosLoading && _selectedVideoId == null) {
                return const Center(
                  child: CircularProgressIndicator(color: primaryPlum),
                );
              }

              if (isLandscape && _selectedVideoId != null && _playerController != null) {
                return Container(
                  color: Colors.black,
                  child: SafeArea(
                    child: Center(
                      child: YoutubePlayer(
                        key: ValueKey(_selectedVideoId),
                        controller: _playerController!,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: richRose,
                        onReady: () {},
                      ),
                    ),
                  ),
                );
              }

              List<Video> videos = [];
              if (state is VideosLoadSuccess) {
                _totalPages = state.videosResponse.totalPages;
                videos = state.videosResponse.videos;
              }

              return Column(
                children: [
                  // ─── Header Tabs (Shorts, Videos, Live) ───
                  _buildTabsHeader(),

                  // ─── Video Player Section (When playing) ───
                  if (_selectedVideoId != null && _playerController != null)
                    _buildInlinePlayer(videos),

                  // ─── Videos List / Content ───
                  Expanded(
                    child: state is VideosFailure
                        ? _buildErrorState(state.message)
                        : RefreshIndicator(
                            color: primaryPlum,
                            onRefresh: () async => _loadVideos(),
                            child: videos.isEmpty
                                ? _buildEmptyState()
                                : _selectedType == 'short'
                                    ? _buildShortsGrid(videos)
                                    : _buildVideosList(videos),
                          ),
                  ),

                  // ─── Pagination Controls ───
                  if (_totalPages > 1) _buildPaginationControls(),
                ],
              );
            },
          ),
        ),
        bottomNavigationBar: isLandscape ? null : const AppBottomNav(currentTab: AppNavTab.panchang),
      ),
    );
  }

  // ─── Header Tabs ───────────────────────────────────────────────────────────
  Widget _buildTabsHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: primaryPlum.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton(
              label: 'Shorts',
              type: 'short',
              icon: Icons.play_circle_fill_rounded,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildTabButton(
              label: 'Videos',
              type: 'regular',
              icon: Icons.video_library_rounded,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildTabButton(
              label: 'Live',
              type: 'live',
              icon: Icons.sensors_rounded,
              isLive: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required String label,
    required String type,
    required IconData icon,
    bool isLive = false,
  }) {
    final isSelected = _selectedType == type;

    return GestureDetector(
      onTap: () => _changeVideoType(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [primaryPlum, richRose],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : const Color(0xFFF7EFF3),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Colors.transparent : const Color(0xFFEEDBE4),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryPlum.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected
                  ? Colors.white
                  : (isLive ? const Color(0xFFE53935) : primaryPlum),
            ),
            const SizedBox(width: 5),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected ? Colors.white : charcoalText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Inline Player ─────────────────────────────────────────────────────────
  Widget _buildInlinePlayer(List<Video> videos) {
    final playingVideo = videos.firstWhere(
      (v) => v.youtubeId == _selectedVideoId,
      orElse: () => videos.first,
    );

    return Container(
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YoutubePlayer(
            key: ValueKey(_selectedVideoId),
            controller: _playerController!,
            showVideoProgressIndicator: true,
            progressIndicatorColor: mauveAccent,
            onReady: () {},
          ),
          Container(
            color: const Color(0xFF1F1A1D),
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        playingVideo.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        playingVideo.description,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white70,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white70, size: 20),
                  onPressed: () {
                    setState(() {
                      _clearSelectedVideo();
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Videos List ───────────────────────────────────────────────────────────
  Widget _buildVideosList(List<Video> videos) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      itemCount: videos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final video = videos[index];
        return _buildVideoCard(video);
      },
    );
  }

  // ─── Shorts Grid View ──────────────────────────────────────────────────────
  Widget _buildShortsGrid(List<Video> shorts) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      itemCount: shorts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.62,
      ),
      itemBuilder: (context, index) {
        final short = shorts[index];
        return GestureDetector(
          onTap: () => _playVideo(short.youtubeId),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    short.thumbnailUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFF0E5EC),
                      child: const Center(
                        child: Icon(Icons.smart_display_rounded, color: primaryPlum, size: 36),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black87],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.5, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.play_arrow_rounded, color: Colors.white, size: 12),
                          SizedBox(width: 2),
                          Text(
                            'Short',
                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 10,
                    right: 10,
                    child: Text(
                      short.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ─── Single Video Card ─────────────────────────────────────────────────────
  Widget _buildVideoCard(Video video) {
    final isSelected = _selectedVideoId == video.youtubeId;

    return GestureDetector(
      onTap: () => _playVideo(video.youtubeId),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? primaryPlum : const Color(0xFFF3E5EB),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: primaryPlum.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail with Play Button
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      video.thumbnailUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFFF0E5EC),
                        child: const Center(
                          child: Icon(Icons.smart_display_rounded, color: primaryPlum, size: 48),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: primaryPlum.withOpacity(0.85),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 30),
                    ),
                  ),
                ),
                if (_selectedType == 'live')
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'LIVE SATSANG',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Video Information
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: charcoalText,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBF4F7),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFF0DEE8)),
                        ),
                        child: Text(
                          video.category.isNotEmpty ? video.category : 'Satsang',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: richRose,
                          ),
                        ),
                      ),
                      Text(
                        _formatDate(video.publishedAt),
                        style: const TextStyle(
                          fontSize: 11,
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                  if (video.description.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      video.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: subtitleColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Pagination ────────────────────────────────────────────────────────────
  Widget _buildPaginationControls() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            onPressed: _currentPage > 1
                ? () {
                    setState(() => _currentPage--);
                    _loadVideos();
                  }
                : null,
            icon: const Icon(Icons.arrow_back_rounded, size: 15),
            label: const Text('Previous', style: TextStyle(fontSize: 12)),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryPlum,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade200,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          Text(
            'Page $_currentPage / $_totalPages',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12.5,
              color: charcoalText,
            ),
          ),
          ElevatedButton.icon(
            onPressed: _currentPage < _totalPages
                ? () {
                    setState(() => _currentPage++);
                    _loadVideos();
                  }
                : null,
            icon: const Icon(Icons.arrow_forward_rounded, size: 15),
            label: const Text('Next', style: TextStyle(fontSize: 12)),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryPlum,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade200,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.video_collection_outlined, size: 52, color: primaryPlum),
          const SizedBox(height: 12),
          Text(
            'No ${_selectedType} videos available right now',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: charcoalText),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadVideos,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryPlum,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 48, color: Colors.redAccent),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: charcoalText),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadVideos,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryPlum,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
