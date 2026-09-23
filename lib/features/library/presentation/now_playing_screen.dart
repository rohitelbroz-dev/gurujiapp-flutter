import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:guruji/core/localization/app_strings.dart';
import 'package:guruji/core/localization/data_localization_helper.dart';
import 'package:guruji/features/library/data/audio_library_repository.dart';

class NowPlayingScreen extends StatefulWidget {
  final Map<String, dynamic> audioData;

  const NowPlayingScreen({
    super.key,
    required this.audioData,
  });

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  final AudioLibraryRepository _repository = AudioLibraryRepository();
  bool _isPlaying = true;
  int _currentSeconds = 0;
  late int _totalSeconds;
  String _selectedScript = 'Dev';
  Timer? _playbackTimer;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _totalSeconds = widget.audioData['totalSeconds'] as int? ?? 252;
    _isSaved = widget.audioData['isFavorite'] as bool? ?? false;
    _startTimer();
  }

  void _startTimer() {
    _playbackTimer?.cancel();
    _playbackTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isPlaying && mounted) {
        setState(() {
          if (_currentSeconds < _totalSeconds) {
            _currentSeconds++;
          } else {
            _currentSeconds = 0;
            _isPlaying = false;
          }
        });
      }
    });
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _seekBy(int seconds) {
    setState(() {
      _currentSeconds = (_currentSeconds + seconds).clamp(0, _totalSeconds);
    });
  }

  void _toggleFavorite() async {
    final trackId = widget.audioData['id']?.toString() ?? '';
    setState(() {
      _isSaved = !_isSaved;
    });
    if (trackId.isNotEmpty) {
      await _repository.toggleFavorite(trackId);
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isSaved ? context.tr('addedToFavorites') : context.tr('removedFromFavorites')),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    super.dispose();
  }

  String _formatTime(int sec) {
    final mins = sec ~/ 60;
    final secs = sec % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    const Color bgGradientStart = Color(0xFFFFFDFE);
    const Color bgGradientEnd = Color(0xFFFBF2F6);
    const Color primaryPlum = Color(0xFF7E2B58);
    const Color playBtnColor = Color(0xFFCE6590);
    const Color charcoalText = Color(0xFF1E1A1D);
    const Color subtitleColor = Color(0xFF6B5E66);

    final title = widget.audioData['title'] as String? ?? 'Shri Ram Stuti';
    final author = widget.audioData['author'] as String? ?? 'Goswami Tulsidas';
    final imagePath = widget.audioData['image'] as String? ?? 'assets/images/ram_divine.jpg';
    final lyrics = widget.audioData['lyrics'] as String? ?? 'श्री रामचन्द्र कृपालु भजु मन हरण भवभय दारुणम्।';

    final isNetworkImage = imagePath.startsWith('http');

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/library');
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [bgGradientStart, bgGradientEnd],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // ─── Header: Back, NOW PLAYING, Playlist ───
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 32,
                            color: Color(0xFF221C20),
                          ),
                          onPressed: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go('/library');
                            }
                          },
                        ),
                        Text(
                          context.tr('nowPlaying'),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.4,
                            color: Color(0xFF7E2B58),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.queue_music_rounded,
                            size: 24,
                            color: Color(0xFF221C20),
                          ),
                          onPressed: () => context.pop(),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),

                          // ─── Center Album Art ───
                          Container(
                            width: 220,
                            height: 220,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFFEFE3EA), width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryPlum.withOpacity(0.12),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: isNetworkImage
                                  ? Image.network(
                                      imagePath,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Image.asset(
                                        'assets/images/ram_divine.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Image.asset(
                                      imagePath,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => const Center(
                                        child: Icon(Icons.temple_hindu_rounded, size: 64, color: primaryPlum),
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // ─── Track Title & Save Heart ───
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      context.trData(title),
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        fontFamily: 'serif',
                                        color: charcoalText,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      context.trData(author),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: subtitleColor,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  _isSaved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                  color: _isSaved ? const Color(0xFFE91E63) : const Color(0xFF8A7D84),
                                  size: 26,
                                ),
                                onPressed: _toggleFavorite,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // ─── Progress Slider & Time Labels ───
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: primaryPlum,
                              inactiveTrackColor: const Color(0xFFEBDCE3),
                              thumbColor: primaryPlum,
                              trackHeight: 3.5,
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                            ),
                            child: Slider(
                              value: _currentSeconds.toDouble().clamp(0.0, _totalSeconds.toDouble()),
                              min: 0,
                              max: _totalSeconds.toDouble(),
                              onChanged: (val) {
                                setState(() {
                                  _currentSeconds = val.toInt();
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatTime(_currentSeconds),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: subtitleColor,
                                  ),
                                ),
                                Text(
                                  _formatTime(_totalSeconds),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: subtitleColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // ─── Player Controls (Rewind, Play/Pause, Forward) ───
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.replay_10_rounded),
                                iconSize: 32,
                                color: charcoalText,
                                onPressed: () => _seekBy(-10),
                              ),
                              const SizedBox(width: 24),
                              GestureDetector(
                                onTap: _togglePlayPause,
                                child: Container(
                                  width: 68,
                                  height: 68,
                                  decoration: BoxDecoration(
                                    color: playBtnColor,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: playBtnColor.withOpacity(0.4),
                                        blurRadius: 16,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 38,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 24),
                              IconButton(
                                icon: const Icon(Icons.forward_10_rounded),
                                iconSize: 32,
                                color: charcoalText,
                                onPressed: () => _seekBy(10),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // ─── Lyrics Section ───
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: const Color(0xFFF2E6ED)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.025),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'LYRICS / पाठ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1,
                                        color: Color(0xFF8A7D84),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        _buildScriptPill('Dev', 'देवनागरी'),
                                        const SizedBox(width: 6),
                                        _buildScriptPill('Eng', 'English'),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  lyrics,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: _selectedScript == 'Dev' ? 'serif' : null,
                                    height: 1.65,
                                    color: charcoalText,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScriptPill(String key, String label) {
    final isSelected = _selectedScript == key;
    return GestureDetector(
      onTap: () => setState(() => _selectedScript = key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7E2B58) : const Color(0xFFF5ECF1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : const Color(0xFF7E2B58),
          ),
        ),
      ),
    );
  }
}
