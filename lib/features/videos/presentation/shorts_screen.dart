import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:guruji/app.dart';
import 'package:guruji/features/videos/bloc/videos_bloc.dart';
import 'package:guruji/features/videos/bloc/videos_event.dart';
import 'package:guruji/features/videos/bloc/videos_state.dart';
import 'package:guruji/features/videos/models/video_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ShortsScreen extends StatefulWidget {
  const ShortsScreen({super.key});

  @override
  State<ShortsScreen> createState() => _ShortsScreenState();
}

class _ShortsScreenState extends State<ShortsScreen> {
  static const int _pageSize = 25;

  YoutubePlayerController? _playerController;
  int _currentIndex = 0;
  bool _isVideoPlaying = true;

  @override
  void initState() {
    super.initState();
    context.read<VideosBloc>().add(
      const FetchVideosEvent(page: 1, limit: _pageSize, type: 'short'),
    );
  }

  @override
  void dispose() {
    _playerController?.dispose();
    super.dispose();
  }

  void _initializePlayer(String youtubeId) {
    _playerController?.dispose();
    _playerController = YoutubePlayerController(
      initialVideoId: youtubeId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: false,
        loop: false,
      ),
    );
    _isVideoPlaying = true;
  }

  void _playShortAt(List<Video> shorts, int index) {
    if (shorts.isEmpty || index < 0 || index >= shorts.length) {
      return;
    }

    setState(() {
      _currentIndex = index;
      _initializePlayer(shorts[index].youtubeId);
    });
  }

  void _togglePlayback() {
    final controller = _playerController;
    if (controller == null) {
      return;
    }

    final isPlaying = controller.value.isPlaying;
    if (isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }

    setState(() {
      _isVideoPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<VideosBloc, VideosState>(
        listener: (context, state) {
          if (state is VideosFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red.shade600,
              ),
            );
          }

          if (state is VideosLoadSuccess && state.videosResponse.videos.isNotEmpty) {
            final shorts = state.videosResponse.videos;
            final safeIndex = _currentIndex >= shorts.length ? 0 : _currentIndex;
            if (_playerController == null) {
              setState(() {
                _currentIndex = safeIndex;
                _initializePlayer(shorts[safeIndex].youtubeId);
              });
            }
          }
        },
        builder: (context, state) {
          if (state is VideosLoading && _playerController == null) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (state is VideosFailure) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<VideosBloc>().add(
                        const FetchVideosEvent(
                          page: 1,
                          limit: _pageSize,
                          type: 'short',
                        ),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is! VideosLoadSuccess) {
            return const SizedBox.shrink();
          }

          final shorts = state.videosResponse.videos;
          if (shorts.isEmpty) {
            return const Center(
              child: Text(
                'No shorts available',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return Stack(
            children: [
              PageView.builder(
                scrollDirection: Axis.vertical,
                itemCount: shorts.length,
                onPageChanged: (index) => _playShortAt(shorts, index),
                itemBuilder: (context, index) {
                  final short = shorts[index];
                  final isActive = index == _currentIndex;

                  return _ShortVideoPage(
                    video: short,
                    isActive: isActive,
                    isPlaying: isActive && _isVideoPlaying,
                    onTap: isActive ? _togglePlayback : null,
                    player: isActive && _playerController != null
                        ? YoutubePlayer(
                            key: ValueKey(short.youtubeId),
                            controller: _playerController!,
                            aspectRatio: 9 / 16,
                            showVideoProgressIndicator: true,
                            progressIndicatorColor: AppTheme.primaryColor,
                          )
                        : null,
                  );
                },
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: Row(
                    children: const [
                      Icon(Icons.play_circle_fill_rounded, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Shorts',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: 2,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.black,
      selectedItemColor: AppTheme.primaryColor,
      unselectedItemColor: Colors.white60,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
        BottomNavigationBarItem(
          icon: Icon(Icons.play_circle_fill_rounded),
          label: 'Shorts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.video_library),
          label: 'Videos',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/home');
            break;
          case 1:
            context.go('/events');
            break;
          case 2:
            break;
          case 3:
            context.go('/videos');
            break;
        }
      },
    );
  }
}

class _ShortVideoPage extends StatelessWidget {
  final Video video;
  final bool isActive;
  final bool isPlaying;
  final VoidCallback? onTap;
  final Widget? player;

  const _ShortVideoPage({
    required this.video,
    required this.isActive,
    required this.isPlaying,
    required this.onTap,
    required this.player,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: ColoredBox(
            color: Colors.black,
            child: isActive && player != null
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      Center(child: player!),
                      Positioned.fill(
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: onTap,
                        ),
                      ),
                      if (!isPlaying)
                        const Center(
                          child: CircleAvatar(
                            radius: 34,
                            backgroundColor: Color(0x66000000),
                            child: Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 38,
                            ),
                          ),
                        ),
                    ],
                  )
                : Image.network(
                    video.thumbnailUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.white54,
                        size: 42,
                      ),
                    ),
                  ),
          ),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0x73000000),
                Colors.transparent,
                Colors.transparent,
                Color(0xC0000000),
              ],
            ),
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 28,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                video.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                video.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    video.category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${video.views} views',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
