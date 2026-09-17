import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:guruji/app.dart';
import 'package:guruji/features/videos/bloc/videos_bloc.dart';
import 'package:guruji/features/videos/bloc/videos_event.dart';
import 'package:guruji/features/videos/bloc/videos_state.dart';
import 'package:guruji/features/videos/models/video_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({super.key});

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  int _currentPage = 1;
  final int _limit = 10;
  int _totalPages = 0;
  YoutubePlayerController? _playerController;
  String? _selectedVideoId;
  String _selectedType = 'regular';

  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    _clearSelectedVideo();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: isLandscape
          ? null
          : AppBar(
              centerTitle: true,
              title: const Text('Videos'),
              elevation: 1,
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: AppTheme.white,
            ),
      body: BlocListener<VideosBloc, VideosState>(
        listener: (context, state) {
          if (state is VideosFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        child: BlocBuilder<VideosBloc, VideosState>(
          builder: (context, state) {
            if (state is VideosLoading && _selectedVideoId == null) {
              return Center(
                child: CircularProgressIndicator(color: colorScheme.primary),
              );
            } else if (state is VideosLoadSuccess) {
              _totalPages = state.videosResponse.totalPages;
              final videos = state.videosResponse.videos;

              if (isLandscape && _selectedVideoId != null) {
                return Container(
                  color: Colors.black,
                  child: SafeArea(
                    child: Center(
                      child: YoutubePlayer(
                        key: ValueKey(_selectedVideoId),
                        controller: _playerController!,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: colorScheme.primary,
                        onReady: () {},
                      ),
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildTypeButton(
                            label: 'Videos',
                            type: 'regular',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildTypeButton(
                            label: 'Shorts',
                            type: 'short',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildTypeButton(label: 'Live', type: 'live'),
                        ),
                      ],
                    ),
                  ),
                  // Video Player Section
                  if (_selectedVideoId != null)
                    Container(
                      color: Colors.black,
                      child: Column(
                        children: [
                          YoutubePlayer(
                            key: ValueKey(_selectedVideoId),
                            controller: _playerController!,
                            showVideoProgressIndicator: true,
                            progressIndicatorColor: colorScheme.primary,
                            onReady: () {},
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  videos
                                      .firstWhere(
                                        (v) => v.youtubeId == _selectedVideoId,
                                        orElse: () => videos.first,
                                      )
                                      .title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  videos
                                      .firstWhere(
                                        (v) => v.youtubeId == _selectedVideoId,
                                        orElse: () => videos.first,
                                      )
                                      .description,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Videos List Section
                  Expanded(
                    child: videos.isEmpty
                        ? const Center(child: Text('No videos available'))
                        : ListView.builder(
                            padding: const EdgeInsets.all(12),
                            itemCount: videos.length,
                            itemBuilder: (context, index) {
                              final video = videos[index];
                              return _buildVideoCard(video);
                            },
                          ),
                  ),
                  // Pagination Controls
                  if (_totalPages > 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
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
                            icon: const Icon(Icons.arrow_back),
                            label: const Text('Previous'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              disabledBackgroundColor: Colors.grey.shade300,
                              disabledForegroundColor: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            'Page $_currentPage / $_totalPages',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: _currentPage < _totalPages
                                ? () {
                                    setState(() => _currentPage++);
                                    _loadVideos();
                                  }
                                : null,
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text('Next'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              disabledBackgroundColor: Colors.grey.shade300,
                              disabledForegroundColor: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            } else if (state is VideosFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadVideos,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                      ),
                      child: const Text(
                        'Retry',
                        style: TextStyle(color: AppTheme.white),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: Text('No videos found'));
          },
        ),
      ),
      bottomNavigationBar: isLandscape ? null : _buildBottomNav(),
    );
  }

  Widget _buildTypeButton({required String label, required String type}) {
    final isSelected = _selectedType == type;

    return InkWell(
      onTap: () => _changeVideoType(type),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : AppTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryDark : AppTheme.primaryColor,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isSelected ? AppTheme.white : AppTheme.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoCard(Video video) {
    final isSelected = _selectedVideoId == video.youtubeId;
    return GestureDetector(
      onTap: () => _playVideo(video.youtubeId),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: AppTheme.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail with play button overlay
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(11),
                      topRight: Radius.circular(11),
                    ),
                    color: Colors.grey.shade200,
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(11),
                      topRight: Radius.circular(11),
                    ),
                    child: Image.network(
                      video.thumbnailUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade300,
                          alignment: Alignment.center,
                          child: const Icon(Icons.image_not_supported),
                        );
                      },
                    ),
                  ),
                ),
                // Play button
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Video Info
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          video.category,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.primaryDark,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _formatDate(video.publishedAt),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    video.description,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (video.views > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        '${video.views} views',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                ],
              ),
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

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: 3, // Videos tab
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppTheme.white,
      selectedItemColor: AppTheme.primaryColor,
      unselectedItemColor: Colors.grey.shade400,
      items: [
        BottomNavigationBarItem(icon: const Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: const Icon(Icons.event), label: 'Events'),
        BottomNavigationBarItem(
          icon: const Icon(Icons.play_circle_fill_rounded),
          label: 'Shorts',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.video_library),
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
            context.go('/shorts');
            break;
          case 3:
            // Stay on videos
            break;
        }
      },
    );
  }
}
