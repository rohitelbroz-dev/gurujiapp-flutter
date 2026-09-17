import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

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
  bool _isPlaying = true;
  int _currentSeconds = 84; // 01:24
  late int _totalSeconds;
  String _selectedScript = 'Dev';
  Timer? _playbackTimer;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _totalSeconds = widget.audioData['totalSeconds'] as int? ?? 252;
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
          }
        });
      }
    });
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
    final lyrics = widget.audioData['lyrics'] as String? ?? 'हरण भवभय दारुणम्';

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
                // ─── Header: Down arrow, NOW PLAYING, more icon ───
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 30, color: Color(0xFF221C20)),
                        onPressed: () => context.pop(),
                      ),
                      const Text(
                        'NOW PLAYING',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF6B5E66),
                          letterSpacing: 1.5,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert_rounded, size: 24, color: Color(0xFF221C20)),
                        onPressed: () {},
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
                        const SizedBox(height: 12),

                        // ─── Center Hero Circle Artwork ───
                        Center(
                          child: Container(
                            width: 250,
                            height: 250,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: primaryPlum.withOpacity(0.14),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                imagePath,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: const Color(0xFFFBEBF1),
                                  child: const Center(
                                    child: Icon(
                                      Icons.music_note_rounded,
                                      size: 80,
                                      color: primaryPlum,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // ─── Title & Subtitle ───
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'serif',
                            color: charcoalText,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          author,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: subtitleColor,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ─── Script Selector: Dev, Eng, Mean ───
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFBEBF1),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: ['Dev', 'Eng', 'Mean'].map((s) {
                              final isSel = _selectedScript == s;
                              return GestureDetector(
                                onTap: () => setState(() => _selectedScript = s),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                                  decoration: BoxDecoration(
                                    color: isSel ? Colors.white : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: isSel
                                        ? [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.04),
                                              blurRadius: 6,
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Text(
                                    s,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                                      color: isSel ? charcoalText : subtitleColor,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // ─── Lyrics Text Display ───
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Text(
                            lyrics,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF9E4F73).withOpacity(0.8),
                              fontFamily: 'serif',
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ─── Seekbar & Timestamps ───
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 4,
                            activeTrackColor: primaryPlum,
                            inactiveTrackColor: const Color(0xFFEBDCE3),
                            thumbColor: primaryPlum,
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
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
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatTime(_currentSeconds),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: subtitleColor,
                                ),
                              ),
                              Text(
                                _formatTime(_totalSeconds),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: subtitleColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),

                        // ─── Audio Playback Controls ───
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.shuffle_rounded, size: 22, color: Color(0xFF6B5E66)),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.skip_previous_rounded, size: 30, color: charcoalText),
                              onPressed: () {
                                setState(() => _currentSeconds = 0);
                              },
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isPlaying = !_isPlaying;
                                });
                              },
                              child: Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: playBtnColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: playBtnColor.withOpacity(0.4),
                                      blurRadius: 18,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                    size: 38,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.skip_next_rounded, size: 30, color: charcoalText),
                              onPressed: () {
                                setState(() => _currentSeconds = 0);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.repeat_rounded, size: 22, color: Color(0xFF6B5E66)),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),

                        // ─── Divider ───
                        const Divider(color: Color(0xFFF1E3EA), height: 1),
                        const SizedBox(height: 18),

                        // ─── Bottom Actions: Save, Playlist, Share ───
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildBottomAction(
                              icon: _isSaved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                              label: 'Save',
                              color: _isSaved ? primaryPlum : subtitleColor,
                              onTap: () {
                                setState(() => _isSaved = !_isSaved);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(_isSaved ? 'Added to Sacred Favorites' : 'Removed from Favorites'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                            ),
                            _buildBottomAction(
                              icon: Icons.playlist_add_rounded,
                              label: 'Playlist',
                              color: subtitleColor,
                              onTap: () {},
                            ),
                            _buildBottomAction(
                              icon: Icons.share_outlined,
                              label: 'Share',
                              color: subtitleColor,
                              onTap: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
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

  Widget _buildBottomAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
