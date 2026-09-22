import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:guruji/core/localization/app_strings.dart';
import 'package:guruji/core/localization/data_localization_helper.dart';
import 'package:guruji/core/widgets/app_bottom_nav.dart';

class AudioLibraryScreen extends StatefulWidget {
  const AudioLibraryScreen({super.key});

  @override
  State<AudioLibraryScreen> createState() => _AudioLibraryScreenState();
}

class _AudioLibraryScreenState extends State<AudioLibraryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedDeity = 'All';

  final List<Map<String, dynamic>> _audioList = [
    {
      'id': '1',
      'title': 'Hanuman Chalisa',
      'author': 'Goswami Tulsidas',
      'duration': '10 mins',
      'totalSeconds': 600,
      'image': 'assets/images/ram_divine.jpg',
      'lyrics': 'श्रीगुरु चरन सरोज रज निज मनु मुकुरु सुधारि ।\nबरनउँ रघुबर बिमल जसु जो दायकु फल चारि ॥',
    },
    {
      'id': '2',
      'title': 'Vishnu Sahasranama',
      'author': 'Maharishi Ved Vyas',
      'duration': '25 mins',
      'totalSeconds': 1500,
      'image': 'assets/images/krishna_divine.jpg',
      'lyrics': 'शुक्लाम्बरधरं विष्णुं शशिवर्णं चतुर्भुजम् ।\nप्रसन्नवदनं ध्यायेत् सर्वविघ्नोपशान्तये ॥',
    },
    {
      'id': '3',
      'title': 'Shiva Tandava Stotram',
      'author': 'Ravana',
      'duration': '8 mins',
      'totalSeconds': 480,
      'image': 'assets/images/shiva_divine.jpg',
      'lyrics': 'जटाटवीगलज्जलप्रवाहपावितस्थले\nगलेऽवलम्ब्य लम्बितां भुजङ्गतुङ्गमालिकाम् ॥',
    },
    {
      'id': '4',
      'title': 'Gayatri Mantra',
      'author': 'Rigveda Samhita',
      'duration': '15 mins',
      'totalSeconds': 900,
      'image': 'assets/images/ram_divine.jpg',
      'lyrics': 'ॐ भूर्भुवः स्वः तत्सवितुर्वरेण्यं\nभर्गो देवस्य धीमहि धियो यो नः प्रचोदयात् ॥',
    },
    {
      'id': '5',
      'title': 'Shri Ram Stuti',
      'author': 'Goswami Tulsidas',
      'duration': '04:12',
      'totalSeconds': 252,
      'image': 'assets/images/ram_divine.jpg',
      'lyrics': 'श्रीरामचन्द्र कृपालु भजु मन हरण भवभय दारुणम् ।\nनवकञ्जलोचन कञ्जमुख करकञ्ज पद कञ्जारुणम् ॥',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAudioPlayer(Map<String, dynamic> audio) {
    context.push(
      '/now-playing',
      extra: audio,
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
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ─── Header: Back/Menu, Hari Path, Profile ───
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_rounded, size: 24, color: Color(0xFF221C20)),
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
                            border: Border.all(color: const Color(0xFFE8D0DC), width: 1.5),
                            color: const Color(0xFFFAF2E7),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/sadhak_avatar.jpg',
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
                  const SizedBox(height: 24),

                  // ─── Divine Focus Section ───
                  Text(
                    context.tr('allDeities'),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'serif',
                      color: charcoalText,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildDeityItem(
                        title: context.trData('Ram'),
                        imagePath: 'assets/images/ram_divine.jpg',
                        charcoalText: charcoalText,
                        onTap: () => setState(() => _selectedDeity = 'Ram'),
                      ),
                      _buildDeityItem(
                        title: context.trData('Krishna'),
                        imagePath: 'assets/images/krishna_divine.jpg',
                        charcoalText: charcoalText,
                        onTap: () => setState(() => _selectedDeity = 'Krishna'),
                      ),
                      _buildDeityItem(
                        title: context.trData('Shiva'),
                        imagePath: 'assets/images/shiva_divine.jpg',
                        charcoalText: charcoalText,
                        onTap: () => setState(() => _selectedDeity = 'Shiva'),
                      ),
                    ],
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
                            style: TextStyle(
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ─── Library Audio List ───
                  Text(
                    context.tr('navLibrary'),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'serif',
                      color: charcoalText,
                    ),
                  ),
                  const SizedBox(height: 14),

                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _audioList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = _audioList[index];
                      return _buildAudioCard(
                        item: item,
                        primaryPlum: primaryPlum,
                        charcoalText: charcoalText,
                        subtitleColor: subtitleColor,
                        onTap: () => _openAudioPlayer(item),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
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
    required String title,
    required String imagePath,
    required Color charcoalText,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Center(
                  child: Icon(Icons.temple_hindu_rounded, size: 36, color: Color(0xFF7E2B58)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
              color: charcoalText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioCard({
    required Map<String, dynamic> item,
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
                    context.trData(item['title'] as String),
                    style: TextStyle(
                      fontSize: 17.5,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'serif',
                      color: charcoalText,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: Color(0xFF8A7D84),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        context.trData(item['duration'] as String),
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w400,
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFFFBEBF1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.play_arrow_rounded,
                  size: 26,
                  color: primaryPlum,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
