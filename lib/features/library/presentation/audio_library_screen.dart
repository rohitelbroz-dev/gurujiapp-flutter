import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:guruji/core/localization/app_strings.dart';
import 'package:guruji/core/localization/data_localization_helper.dart';
import 'package:guruji/core/widgets/app_bottom_nav.dart';
import 'package:guruji/features/library/data/audio_library_models.dart';
import 'package:guruji/features/library/data/audio_library_repository.dart';

class AudioLibraryScreen extends StatefulWidget {
  const AudioLibraryScreen({super.key});

  @override
  State<AudioLibraryScreen> createState() => _AudioLibraryScreenState();
}

class _AudioLibraryScreenState extends State<AudioLibraryScreen> {
  final AudioLibraryRepository _repository = AudioLibraryRepository();
  final TextEditingController _searchController = TextEditingController();

  List<DeityCategory> _deities = [];
  List<AudioTrackItem> _tracks = [];
  String _selectedDeityKey = 'All';
  bool _isLoading = true;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _loadDeitiesAndTracks();
  }

  Future<void> _loadDeitiesAndTracks() async {
    setState(() => _isLoading = true);

    try {
      final deities = await _repository.fetchDeities();
      final tracks = await _repository.fetchAudioTracks(
        deity: _selectedDeityKey,
        search: _searchController.text,
      );

      if (mounted) {
        setState(() {
          _deities = deities;
          _tracks = tracks;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _onSelectDeity(String key) {
    if (_selectedDeityKey == key) {
      _selectedDeityKey = 'All';
    } else {
      _selectedDeityKey = key;
    }
    setState(() {});
    _fetchFilteredTracks();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _fetchFilteredTracks();
    });
  }

  Future<void> _fetchFilteredTracks() async {
    try {
      final tracks = await _repository.fetchAudioTracks(
        deity: _selectedDeityKey,
        search: _searchController.text,
      );
      if (mounted) {
        setState(() {
          _tracks = tracks;
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _openAudioPlayer(AudioTrackItem item) {
    context.push(
      '/now-playing',
      extra: {
        'id': item.id,
        'title': item.title,
        'author': item.artist,
        'duration': item.durationFormatted,
        'totalSeconds': item.totalSeconds,
        'image': item.coverImage.isNotEmpty ? item.coverImage : (item.assetFallback ?? 'assets/images/ram_divine.jpg'),
        'lyrics': item.lyrics,
        'audioUrl': item.audioUrl,
        'isFavorite': item.isFavorite,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color bgGradientStart = Color(0xFFFFFDFE);
    const Color bgGradientEnd = Color(0xFFFBF4F7);
    const Color primaryPlum = Color(0xFF7E2B58);
    const Color charcoalText = Color(0xFF1E1A1D);
    const Color subtitleColor = Color(0xFF6B5E66);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/home');
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: bgGradientEnd,
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
              child: RefreshIndicator(
                onRefresh: _loadDeitiesAndTracks,
                color: primaryPlum,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ─── Header: Back/Menu, Hari Path, Profile ───
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                              size: 24,
                              color: Color(0xFF221C20),
                            ),
                            onPressed: () {
                              if (context.canPop()) {
                                context.pop();
                              } else {
                                context.go('/home');
                              }
                            },
                          ),
                          Text(
                            context.tr('hariPath'),
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'serif',
                              color: primaryPlum,
                              letterSpacing: -0.5,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.push('/profile'),
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFE8D0DC),
                                  width: 1.5,
                                ),
                                color: const Color(0xFFFAF2E7),
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/temple_welcome.jpg',
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.person,
                                    size: 20,
                                    color: primaryPlum,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // ─── Title: All Deities ───
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.tr('allDeities'),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'serif',
                              color: charcoalText,
                              letterSpacing: -0.5,
                              height: 1.15,
                            ),
                          ),
                          if (_selectedDeityKey != 'All')
                            TextButton.icon(
                              onPressed: () => _onSelectDeity('All'),
                              icon: const Icon(Icons.close_rounded, size: 16, color: primaryPlum),
                              label: Text(
                                context.tr('viewAll'),
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: primaryPlum),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // ─── Deities Horizontal Row ───
                      if (_deities.isNotEmpty)
                        Row(
                          children: _deities.map((deity) {
                            final isSelected = _selectedDeityKey.toLowerCase() == deity.key.toLowerCase();
                            return _buildDeityItem(
                              deity: deity,
                              isSelected: isSelected,
                              charcoalText: charcoalText,
                              primaryPlum: primaryPlum,
                              onTap: () => _onSelectDeity(deity.key),
                            );
                          }).toList(),
                        ),
                      const SizedBox(height: 24),

                      // ─── Search Bar ───
                      Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(26),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.search_rounded,
                              size: 22,
                              color: Color(0xFF8A7D84),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                onChanged: _onSearchChanged,
                                style: const TextStyle(
                                  fontSize: 14.5,
                                  color: charcoalText,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  hintText: context.tr('audioSearchHint'),
                                  hintStyle: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFFB8ADB4),
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                              ),
                            ),
                            if (_searchController.text.isNotEmpty)
                              GestureDetector(
                                onTap: () {
                                  _searchController.clear();
                                  _fetchFilteredTracks();
                                },
                                child: const Icon(Icons.close_rounded, size: 18, color: Color(0xFF8A7D84)),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // ─── Library Audio List ───
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.tr('navLibrary'),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'serif',
                              color: charcoalText,
                            ),
                          ),
                          Text(
                            '${_tracks.length} ${context.tr("chants")}',
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: subtitleColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      if (_tracks.isEmpty && !_isLoading)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Column(
                            children: [
                              const Icon(Icons.music_off_rounded, size: 48, color: Color(0xFFC4B4BD)),
                              const SizedBox(height: 12),
                              Text(
                                'कोई भजन या मंत्र नहीं मिला',
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF6B5E66)),
                              ),
                            ],
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _tracks.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final track = _tracks[index];
                            return _buildAudioCard(
                              item: track,
                              primaryPlum: primaryPlum,
                              charcoalText: charcoalText,
                              subtitleColor: subtitleColor,
                              onTap: () => _openAudioPlayer(track),
                            );
                          },
                        ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: const AppBottomNav(currentTab: AppNavTab.library),
        ),
      ),
    );
  }

  Widget _buildDeityItem({
    required DeityCategory deity,
    required bool isSelected,
    required Color charcoalText,
    required Color primaryPlum,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? primaryPlum : const Color(0xFFE8DFE4),
                  width: isSelected ? 3 : 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected ? primaryPlum.withOpacity(0.2) : Colors.black.withOpacity(0.05),
                    blurRadius: isSelected ? 10 : 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipOval(
                child: deity.imageUrl.isNotEmpty
                    ? Image.network(
                        deity.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildFallbackImage(deity),
                      )
                    : _buildFallbackImage(deity),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.trData(deity.name),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? primaryPlum : charcoalText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackImage(DeityCategory deity) {
    if (deity.assetFallback != null && deity.assetFallback!.isNotEmpty) {
      return Image.asset(
        deity.assetFallback!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Center(
          child: Icon(Icons.temple_hindu_rounded, size: 32, color: Color(0xFF7E2B58)),
        ),
      );
    }
    return const Center(
      child: Icon(Icons.temple_hindu_rounded, size: 32, color: Color(0xFF7E2B58)),
    );
  }

  Widget _buildAudioCard({
    required AudioTrackItem item,
    required Color primaryPlum,
    required Color charcoalText,
    required Color subtitleColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.035),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.trData(item.title),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'serif',
                      color: Color(0xFF1E1A1D),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: Color(0xFF8A7D84),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        context.trData(item.durationFormatted),
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF8A7D84),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '• ${context.trData(item.artist)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF8A7D84),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFFFBF1F5),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: Color(0xFF8E3763),
                  size: 26,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
