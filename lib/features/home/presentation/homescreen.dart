import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'dart:ui';
import 'package:go_router/go_router.dart';
import 'package:guruji/app.dart';
import 'package:guruji/features/auth/bloc/auth_bloc.dart';
import 'package:myanmar_calendar_widget/myanmar_calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  static const double _ayodhyaLatitude = 26.7992;
  static const double _ayodhyaLongitude = 82.2040;
  static final Uri _ramLallaBhawanUrl = Uri.parse(
    'https://ramlallabhawan.com/',
  );
  static final Uri _madhavBhawanUrl = Uri.parse('https://madhavbhawan.com/');
  static const List<String> _bannerUrls = [
    'https://jagadgurushridharacharyji.com/wp-content/uploads/2026/02/banner-2.jpg.jpeg',
    'https://jagadgurushridharacharyji.com/wp-content/uploads/2026/01/Artboard-3.jpg-2.jpeg',
    'https://jagadgurushridharacharyji.com/wp-content/uploads/2026/01/Artboard-2.jpg-3.jpeg',
    'https://jagadgurushridharacharyji.com/wp-content/uploads/2026/02/Artboard-1.jpg.jpeg',
  ];

  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoPlayTimer;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final List<CarouselItem> _carouselItems = [
    CarouselItem(
      emoji: '🎨',
      title: 'Draw to Jaap',
      subtitle: 'ड्रॉ करके जाप का नया अनुभव करें 🙏',
      hint: '(Games सेक्शन में देखें)',
      accentColor: const Color(0xFF7C5CBF),
    ),
    CarouselItem(
      emoji: '👨‍👩‍👧',
      title: 'Family Jaap',
      subtitle: 'परिवार के साथ जाप करें और एक साथ गिनें',
      accentColor: const Color(0xFFE07C54),
    ),
    CarouselItem(
      emoji: '🏆',
      title: 'Daily Streak',
      subtitle: 'हर दिन जाप करें और अपनी streak बनाएं',
      accentColor: const Color(0xFF4A90D9),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
    _startAutoPlay();
    context.read<AuthBloc>().add(const GetProfileEvent());
  }

  void _startAutoPlay() {
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      final next = (_currentPage + 1) % _bannerUrls.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F4F9),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        toolbarHeight: 88,
        titleSpacing: 16,
        scrolledUnderElevation: 0,
        title: Text(
          'Guruji', // or your app name/logo
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
          ),
        ),
        // title: _buildHinduCalendarTitle(today),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: BlocBuilder<AuthBloc, AuthState>(
                buildWhen: (previous, current) =>
                    current is ProfileLoading ||
                    current is ProfileLoadSuccess ||
                    current is ProfileUpdateSuccess ||
                    current is AuthFailure,
                builder: (context, state) => _buildProfileAvatar(state),
              ),
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildCarousel()),
              SliverToBoxAdapter(child: const SizedBox(height: 16)),
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(child: const SizedBox(height: 18)),
              SliverToBoxAdapter(child: _buildNaamJaapCard()),
              SliverToBoxAdapter(child: const SizedBox(height: 20)),
              SliverToBoxAdapter(child: _buildAmritVachanSection()),
              SliverToBoxAdapter(child: const SizedBox(height: 20)),
              SliverToBoxAdapter(child: _buildSectionHeader('Explore', '')),
              SliverToBoxAdapter(child: const SizedBox(height: 10)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.15,
                  children: [
                    ExploreItem(
                      '🎮',
                      'Hotel',
                      'Book a staycation In Ayodhya',
                      const Color(0xFFE3EEFF),
                      const Color(0xFF4A7AE0),
                    ),
                    ExploreItem(
                      '\u{1F46A}',
                      'Family',
                      'View your family tree',
                      const Color(0xFFFFF4DE),
                      const Color(0xFFD18C00),
                    ),
                    ExploreItem(
                      '👨‍👩‍👧',
                      'DashBoard',
                      'Personal Information',
                      const Color(0xFFFFEDE8),
                      const Color(0xFFE05A30),
                    ),
                    ExploreItem(
                      '🖼',
                      'LeaderBoard',
                      'Divine Collection',
                      const Color(0xFFE8F9F0),
                      const Color(0xFF2DAA6E),
                    ),
                    ExploreItem(
                      '🎵',
                      'Donate',
                      'Support for Humanity',
                      const Color(0xFFF0E8FF),
                      const Color(0xFF8B5CF6),
                    ),
                    ExploreItem(
                      '🎵',
                      'Jaap',
                      'Support for Humanity',
                      const Color(0xFFF0E8FF),
                      const Color(0xFF8B5CF6),
                    ),
                  ].map(_buildExploreCard).toList(),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 90)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ── Header ─────────────────────────────────────────────────
  Widget _buildHinduCalendarTitle(DateTime today) {
    return SizedBox(
      width: 240,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: ColoredBox(
          color: Colors.white.withOpacity(0.14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: HinduCalendarWidget(
              year: today.year,
              month: today.month,
              day: today.day,
              compact: true,
              latitude: _ayodhyaLatitude,
              longitude: _ayodhyaLongitude,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final today = DateTime.now();

    // ── Get live Panchanga data from the package ───────────────
    final Map<String, dynamic> calculation =
        HinduCalculationEngine.calculateHinduDate(
          today.year,
          today.month,
          today.day,
          latitude: _ayodhyaLatitude,
          longitude: _ayodhyaLongitude,
        );
    final PancangaDate p = PancangaDate.fromCalculation(calculation);

    // ── Gregorian helpers (no hardcoding) ──────────────────────
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    const dayNames = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    // Moon phase: elongation 0–360 → 0.0–1.0
    double elongation = (p.moonLongitude - p.sunLongitude) % 360;
    if (elongation < 0) elongation += 360;
    final double moonPhase = elongation / 360.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 236, 135, 19),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Top row ────────────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Moon phase painter
                  CustomPaint(
                    size: const Size(52, 52),
                    painter: _MoonPhasePainter(moonPhase),
                  ),

                  const SizedBox(width: 12),

                  // Tithi / Paksha / Samvat
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${p.tithiNumber}, ${p.lunarMonth}',
                          style: const TextStyle(
                            color: Color(0xFFE8C84A),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${p.paksha}, ${p.tithiName}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${p.hinduYear} Vikrama Samvata',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Gregorian date (right side)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${today.day}',
                        style: const TextStyle(
                          color: Color(0xFFE8C84A),
                          fontSize: 38,
                          fontWeight: FontWeight.w800,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${monthNames[today.month - 1]} ${today.year}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        dayNames[today.weekday - 1],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // ── Location ───────────────────────────────────────
              // const Text(
              //   'Ayodhya, India',
              //   style: TextStyle(
              //     color: Colors.white70,
              //     fontSize: 11.5,
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),

              // ── Festival / special day ─────────────────────────
              // varaName = weekday, rituName = season; show nakshatra as festival line
              if (p.nakshatraName.isNotEmpty) ...[
                const Divider(
                  color: Colors.white24,
                  height: 16,
                  thickness: 0.5,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    '${p.nakshatraName} Nakshatra · ${p.rituName}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarButton() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: const Text('🕉', style: TextStyle(fontSize: 18)),
    );
  }

  // ── Carousel ──────────────────────────────────────────────
  Widget _buildProfileAvatar(AuthState state) {
    final profileImageUrl = _profileImageUrlFromState(state);

    return GestureDetector(
      onTap: () => context.push('/profile'),
      child: Container(
        width: 40,
        height: 40,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          gradient: profileImageUrl == null
              ? const LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: profileImageUrl == null ? null : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: profileImageUrl == null
            ? const Icon(Icons.person, color: Colors.white, size: 22)
            : Image.network(
                profileImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.person, color: Colors.white, size: 22),
              ),
      ),
    );
  }

  String? _profileImageUrlFromState(AuthState state) {
    if (state is ProfileLoadSuccess) {
      return _normalizeProfileImageUrl(state.profile.profileImage);
    }
    if (state is ProfileUpdateSuccess) {
      return _normalizeProfileImageUrl(state.profile.profileImage);
    }
    return null;
  }

  String? _normalizeProfileImageUrl(String? imageUrl) {
    final trimmed = imageUrl?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  Widget _buildCarousel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(
            height: 195,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _bannerUrls.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (_, i) => _buildCarouselSlide(_bannerUrls[i], i),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_bannerUrls.length, _buildDot),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselSlide(String imageUrl, int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.only(right: index != _bannerUrls.length - 1 ? 8 : 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned.fill(
              child: ColoredBox(
                color: const Color(0xFFF3E5C8),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.fill,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    final expectedBytes = loadingProgress.expectedTotalBytes;
                    final progress = expectedBytes == null
                        ? null
                        : loadingProgress.cumulativeBytesLoaded / expectedBytes;

                    return Center(
                      child: CircularProgressIndicator(
                        value: progress,
                        color: AppTheme.primaryDark,
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => Center(
                    child: Text(
                      'Banner unavailable',
                      style: TextStyle(
                        color: AppTheme.primaryDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.06),
                      Colors.black.withOpacity(0.18),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    final isActive = index == _currentPage;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: isActive ? 22 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: isActive
            ? AppTheme.primaryColor
            : AppTheme.primaryColor.withOpacity(0.25),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  // ── Naam Jaap Card ─────────────────────────────────────────
  Widget _buildNaamJaapCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () => context.go('/naam-jaap'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.12),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryColor, AppTheme.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text('🕉', style: TextStyle(fontSize: 24)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Naam Jaap',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Start your daily chant',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textPrimary.withOpacity(0.5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmritVachanSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () => context.go('/amrit-vachan'),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFE2A8), Color(0xFFFFF1D2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.16),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(18),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.auto_stories_rounded,
                  color: AppTheme.primaryDark,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amrit-Vachan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'View today\'s post and all uploaded vachan cards',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: AppTheme.textPrimary.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: AppTheme.primaryDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Section Header ─────────────────────────────────────────
  Widget _buildSectionHeader(String title, String action) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              action,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Explore Card ───────────────────────────────────────────
  Widget _buildExploreCard(ExploreItem item) {
    return GestureDetector(
      onTap: () => _handleExploreTap(item),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: item.accentColor.withOpacity(0.08),
              blurRadius: 14,
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
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: item.iconBg,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    item.resolvedEmoji,
                    style: const TextStyle(fontSize: 21),
                  ),
                ),
                Icon(
                  Icons.arrow_outward_rounded,
                  size: 16,
                  color: item.accentColor.withOpacity(0.6),
                ),
              ],
            ),
            const Spacer(),
            Text(
              item.title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              item.subtitle,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: item.accentColor.withOpacity(0.7),
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleExploreTap(ExploreItem item) {
    if (item.title == 'Hotel') {
      _showHotelWebsiteOptions();
      return;
    }

    if (item.title == 'LeaderBoard') {
      context.go('/leaderboard');
      return;
    }

    if (item.title == 'Jaap') {
      context.go('/naam-jaap');
      return;
    }

    if (item.title == 'Family') {
      context.go('/family');
    }
  }

  Future<void> _showHotelWebsiteOptions() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Choose Hotel',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Open the hotel website you want to explore.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textPrimary.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                _buildHotelWebsiteButton(
                  label: 'Ramlalla Bhawan',
                  // subtitle: 'ramlallabhawan.com',
                  accentColor: const Color(0xFF4A7AE0),
                  onTap: () => _openHotelWebsite(_ramLallaBhawanUrl),
                ),
                const SizedBox(height: 12),
                _buildHotelWebsiteButton(
                  label: 'Madhav Bhawan',
                  // subtitle: 'madhavbhawan.com',
                  accentColor: const Color(0xFFE05A30),
                  onTap: () => _openHotelWebsite(_madhavBhawanUrl),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHotelWebsiteButton({
    required String label,
    String? subtitle,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            // Text(
            //   subtitle!,
            //   style: TextStyle(
            //     fontSize: 12,
            //     color: Colors.white.withOpacity(0.85),
            //     fontWeight: FontWeight.w500,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Future<void> _openHotelWebsite(Uri url) async {
    Navigator.of(context).pop();

    final launched = await launchUrl(url, mode: LaunchMode.inAppBrowserView);
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open the hotel website.')),
      );
    }
  }

  // ── Bottom Nav ─────────────────────────────────────────────
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home_rounded, 'Home', true, null),
              _navItem(
                Icons.event_rounded,
                'Events',
                false,
                () => context.go('/events'),
              ),
              _navItem(
                Icons.play_circle_fill_rounded,
                'Shorts',
                false,
                () => context.go('/shorts'),
              ),
              _navItem(
                Icons.video_library_rounded,
                'Videos',
                false,
                () => context.go('/videos'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(
    IconData icon,
    String label,
    bool isActive,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isActive ? Colors.deepPurple.shade100 : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: isActive
                  ? Colors.deepPurple.shade600
                  : Colors.grey.shade400,
              size: 22,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isActive
                  ? Colors.deepPurple.shade600
                  : Colors.grey.shade400,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _navCenterButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.primaryColor, AppTheme.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.45),
              blurRadius: 14,
              spreadRadius: 1,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }
}

// ── Data models ────────────────────────────────────────────────
class CarouselItem {
  final String emoji;
  final String title;
  final String subtitle;
  final String? hint;
  final Color? accentColor;

  CarouselItem({
    required this.emoji,
    required this.title,
    required this.subtitle,
    this.hint,
    this.accentColor,
  });
}

class ExploreItem {
  final String emoji;
  final String title;
  final String subtitle;
  final Color iconBg;
  final Color accentColor;

  ExploreItem(
    this.emoji,
    this.title,
    this.subtitle,
    this.iconBg,
    this.accentColor,
  );

  String get resolvedEmoji {
    switch (title) {
      case 'Hotel':
        return '\u{1F3E8}';
      case 'DashBoard':
        return '\u{1F4CA}';
      case 'Family':
        return '\u{1F46A}';
      case 'LeaderBoard':
        return '\u{1F3C6}';
      case 'Donate':
        return '\u{1F91D}';
      case 'Jaap':
        return '\u{1F64F}';
      default:
        return emoji;
    }
  }

  String get displayEmoji {
    switch (title) {
      case 'Hotel':
        return '🏨';
      case 'DashBoard':
        return '📊';
      case 'LeaderBoard':
        return '🏆';
      case 'Donate':
        return '🤝';
      default:
        return emoji;
    }
  }
}

class _MoonPhasePainter extends CustomPainter {
  final double phase; // 0.0 = new moon → 0.5 = full moon → 1.0 = new moon

  const _MoonPhasePainter(this.phase);

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2;
    final center = Offset(r, r);

    // Dark background
    canvas.drawCircle(center, r, Paint()..color = const Color(0xFF1A1A2E));

    final litPaint = Paint()..color = const Color.fromARGB(255, 250, 247, 239);
    final darkPaint = Paint()..color = const Color.fromARGB(255, 5, 5, 8);

    // Draw lit half based on phase
    final deg = phase * 360;
    if (deg < 180) {
      // Waxing: right half lit
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: r),
        -math.pi / 2,
        math.pi,
        false,
        litPaint,
      );
      // Overlay ellipse to shape waxing crescent→gibbous
      final scaleX = math.cos(deg * math.pi / 180);
      canvas.drawOval(
        Rect.fromCenter(
          center: center,
          width: r * 2 * scaleX.abs(),
          height: r * 2,
        ),
        deg < 90 ? darkPaint : litPaint,
      );
    } else {
      // Waning: left half lit
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: r),
        math.pi / 2,
        math.pi,
        false,
        litPaint,
      );
      final scaleX = math.cos(deg * math.pi / 180);
      canvas.drawOval(
        Rect.fromCenter(
          center: center,
          width: r * 2 * scaleX.abs(),
          height: r * 2,
        ),
        deg < 270 ? litPaint : darkPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_MoonPhasePainter old) => old.phase != phase;
}
