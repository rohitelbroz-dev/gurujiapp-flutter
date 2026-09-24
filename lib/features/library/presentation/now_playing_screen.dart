import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
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
  late final AudioPlayer _audioPlayer;

  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration>? _durationSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<void>? _completeSubscription;

  bool _isPlaying = false;
  bool _isLoading = true;
  int _currentSeconds = 0;
  int _totalSeconds = 252;
  String _selectedScript = 'Dev';
  bool _isSaved = false;
  String? _audioUrl;

  @override
  void initState() {
    super.initState();
    _totalSeconds = widget.audioData['totalSeconds'] as int? ?? 252;
    _isSaved = widget.audioData['isFavorite'] as bool? ?? false;
    _audioUrl = widget.audioData['audioUrl']?.toString();

    _audioPlayer = AudioPlayer();
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    // Listen to current audio position
    _positionSubscription = _audioPlayer.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() {
          _currentSeconds = position.inSeconds;
        });
      }
    });

    // Listen to total duration from audio stream
    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      if (mounted && duration.inSeconds > 0) {
        setState(() {
          _totalSeconds = duration.inSeconds;
        });
      }
    });

    // Listen to player state
    _playerStateSubscription = _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
          if (state == PlayerState.playing || state == PlayerState.paused) {
            _isLoading = false;
          }
        });
      }
    });

    // Listen to track completion
    _completeSubscription = _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _currentSeconds = 0;
          _isPlaying = false;
        });
      }
    });

    // Play initial audio track
    await _startPlayback();
  }

  Future<void> _startPlayback() async {
    final url = _audioUrl;
    if (url == null || url.trim().isEmpty) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      setState(() => _isLoading = true);
      Source source;
      if (url.startsWith('http://') || url.startsWith('https://')) {
        source = UrlSource(url);
      } else if (url.startsWith('assets/')) {
        source = AssetSource(url.replaceFirst('assets/', ''));
      } else {
        final resolved = url.startsWith('/')
            ? 'https://gurujiappbackend.onrender.com$url'
            : 'https://gurujiappbackend.onrender.com/$url';
        source = UrlSource(resolved);
      }

      await _audioPlayer.play(source);
      if (mounted) {
        setState(() {
          _isPlaying = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isPlaying = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Audio stream notice: ${e.toString()}'),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _togglePlayPause() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        if (_audioPlayer.state == PlayerState.paused) {
          await _audioPlayer.resume();
        } else {
          await _startPlayback();
        }
      }
    } catch (_) {}
  }

  Future<void> _seekTo(int seconds) async {
    final clamped = seconds.clamp(0, _totalSeconds);
    setState(() {
      _currentSeconds = clamped;
    });
    try {
      await _audioPlayer.seek(Duration(seconds: clamped));
    } catch (_) {}
  }

  void _seekBy(int seconds) {
    _seekTo(_currentSeconds + seconds);
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
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _completeSubscription?.cancel();
    _audioPlayer.stop();
    _audioPlayer.dispose();
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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [bgGradientStart, bgGradientEnd],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  child: Column(
                    children: [
                      // Top Bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 32, color: primaryPlum),
                            onPressed: () {
                              if (context.canPop()) {
                                context.pop();
                              } else {
                                context.go('/library');
                              }
                            },
                          ),
                          Text(
                            context.tr('nowPlaying').toUpperCase(),
                            style: const TextStyle(
                              color: primaryPlum,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.playlist_play_rounded, size: 28, color: primaryPlum),
                            onPressed: () {
                              if (context.canPop()) {
                                context.pop();
                              } else {
                                context.go('/library');
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Circular Deity Artwork with soft shadow & aura
                      Center(
                        child: Container(
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: primaryPlum.withValues(alpha: 0.15),
                                blurRadius: 36,
                                spreadRadius: 4,
                                offset: const Offset(0, 10),
                              ),
                            ],
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: ClipOval(
                            child: isNetworkImage
                                ? Image.network(
                                    imagePath,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Image.asset(
                                      'assets/images/ram_divine.jpg',
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => const Icon(
                                        Icons.music_note_rounded,
                                        size: 64,
                                        color: primaryPlum,
                                      ),
                                    ),
                                  )
                                : Image.asset(
                                    imagePath,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.music_note_rounded,
                                      size: 64,
                                      color: primaryPlum,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Title, Artist, & Favorite Button
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                                    color: charcoalText,
                                    fontFamily: 'serif',
                                    height: 1.2,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  context.trData(author),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: subtitleColor,
                                    fontWeight: FontWeight.w500,
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
                              color: _isSaved ? primaryPlum : const Color(0xFF8A7D84),
                              size: 26,
                            ),
                            onPressed: _toggleFavorite,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Progress Slider
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 3.5,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                          activeTrackColor: primaryPlum,
                          inactiveTrackColor: const Color(0xFFE8DCE2),
                          thumbColor: primaryPlum,
                          overlayColor: primaryPlum.withValues(alpha: 0.2),
                        ),
                        child: Slider(
                          value: _totalSeconds > 0 ? _currentSeconds.clamp(0, _totalSeconds).toDouble() : 0.0,
                          min: 0,
                          max: _totalSeconds > 0 ? _totalSeconds.toDouble() : 1.0,
                          onChanged: (val) {
                            setState(() {
                              _currentSeconds = val.toInt();
                            });
                          },
                          onChangeEnd: (val) {
                            _seekTo(val.toInt());
                          },
                        ),
                      ),

                      // Timestamps (Current / Total)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatTime(_currentSeconds),
                              style: const TextStyle(
                                fontSize: 12,
                                color: subtitleColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              _formatTime(_totalSeconds),
                              style: const TextStyle(
                                fontSize: 12,
                                color: subtitleColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Playback Controls (10s Back, Play/Pause, 10s Forward)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.replay_10_rounded, size: 30, color: charcoalText),
                            onPressed: () => _seekBy(-10),
                          ),
                          const SizedBox(width: 24),
                          GestureDetector(
                            onTap: _togglePlayPause,
                            child: Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: playBtnColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: playBtnColor.withValues(alpha: 0.35),
                                    blurRadius: 18,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 28,
                                        height: 28,
                                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                      )
                                    : Icon(
                                        _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          IconButton(
                            icon: const Icon(Icons.forward_10_rounded, size: 30, color: charcoalText),
                            onPressed: () => _seekBy(10),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // Lyrics & Text Section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: primaryPlum.withValues(alpha: 0.04),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header + Script Switcher (No Overflow)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        'LYRICS',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: primaryPlum,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Flexible(
                                        child: Text(
                                          '/ ${context.tr('pathText')}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: subtitleColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF6EFF3),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _buildScriptToggle('Dev', 'देवनागरी'),
                                      _buildScriptToggle('Eng', 'English'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Actual Lyrics Text
                            Text(
                              lyrics,
                              style: const TextStyle(
                                fontSize: 15,
                                height: 1.7,
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
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScriptToggle(String scriptKey, String label) {
    final isSelected = _selectedScript == scriptKey;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedScript = scriptKey;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7E2B58) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : const Color(0xFF7E2B58),
          ),
        ),
      ),
    );
  }
}
