import 'package:guruji/core/services/user_persistence_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:guruji/core/localization/app_strings.dart';
import 'package:guruji/core/localization/data_localization_helper.dart';
import 'package:guruji/core/widgets/app_bottom_nav.dart';
import 'package:guruji/features/amrit_vachan/data/amrit_vachan_repository.dart';
import 'package:guruji/features/amrit_vachan/models/amrit_vachan_model.dart';
import 'package:guruji/features/events/data/events_repository.dart';
import 'package:guruji/features/events/models/event_model.dart';
import 'package:guruji/features/home/data/panchang_models.dart';
import 'package:guruji/features/home/data/panchang_repository.dart';
import 'package:guruji/features/leaderboard/data/leaderboard_repository.dart';
import 'package:guruji/features/leaderboard/models/leaderboard_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedLocation = 'Vrindavan';
  final List<String> _locations = [
    'Vrindavan',
    'Ayodhya',
    'Varanasi',
    'Haridwar',
    'Mathura',
    'New Delhi',
    'Mumbai',
  ];

  final PanchangRepository _panchangRepo = PanchangRepository();
  final AmritVachanRepository _amritVachanRepo = AmritVachanRepository();
  final EventsRepository _eventsRepo = EventsRepository();
  final LeaderboardRepository _leaderboardRepo = LeaderboardRepository();

  DailyPanchangData? _panchangData;
  List<FestivalItem> _festivals = [];
  AmritVachan? _todayAmritVachan;
  Event? _featuredEvent;
  LeaderboardEntry? _topSadhak;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllHomeData();
  }

  Future<void> _loadAllHomeData() async {
    setState(() => _isLoading = true);

    try {
      final results = await Future.wait([
        _panchangRepo.fetchDailyPanchang(location: _selectedLocation),
        _panchangRepo.fetchUpcomingFestivals(),
        _amritVachanRepo.fetchTodayPosts().then((list) async {
          if (list.isNotEmpty) return list.first;
          final all = await _amritVachanRepo.fetchAllPosts();
          return all.isNotEmpty ? all.first : null;
        }).catchError((_) => null),
        _eventsRepo.fetchEvents(page: 1, limit: 1).then((res) => res.events.isNotEmpty ? res.events.first : null).catchError((_) => null),
        _leaderboardRepo.fetchLeaderboard().then((res) => res.leaderboard.isNotEmpty ? res.leaderboard.first : null).catchError((_) => null),
      ]);

      if (mounted) {
        setState(() {
          _panchangData = results[0] as DailyPanchangData?;
          _festivals = results[1] as List<FestivalItem>? ?? [];
          _todayAmritVachan = results[2] as AmritVachan?;
          _featuredEvent = results[3] as Event?;
          _topSadhak = results[4] as LeaderboardEntry?;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _onLocationChanged(String newLocation) {
    UserPersistenceService.savePreferredCity(newLocation);
    if (_selectedLocation == newLocation) return;
    setState(() {
      _selectedLocation = newLocation;
    });
    _panchangRepo.fetchDailyPanchang(location: newLocation).then((data) {
      if (mounted) {
        setState(() => _panchangData = data);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color bgGradientStart = Color(0xFFFFFDFE);
    const Color bgGradientEnd = Color(0xFFFBF4F7);
    const Color primaryPlum = Color(0xFF7E2B58);
    const Color charcoalText = Color(0xFF1F1A1D);
    const Color subtitleColor = Color(0xFF6B5F66);
    const Color mauveCard = Color(0xFFCE6590);

    return AnnotatedRegion<SystemUiOverlayStyle>(
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
            bottom: false,
            child: RefreshIndicator(
              onRefresh: _loadAllHomeData,
              color: primaryPlum,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ─── Header: Today's Panchang & Location ───
                    _buildHeader(primaryPlum),
                    const SizedBox(height: 20),

                    // ─── Hindu Date Title & Subtitle ───
                    _buildDateSection(charcoalText, subtitleColor),
                    const SizedBox(height: 24),

                    // ─── 2x2 Grid (Tithi, Nakshatra, Yoga, Karana) ───
                    _buildPanchangGrid(primaryPlum, charcoalText, subtitleColor),
                    const SizedBox(height: 20),

                    // ─── Auspicious Timing Card (Abhijit Muhurat) ───
                    _buildAuspiciousTimingCard(mauveCard),
                    const SizedBox(height: 20),

                    // ─── Celestial Timings (Sun & Moon) ───
                    _buildCelestialTimingsCard(charcoalText, subtitleColor),
                    const SizedBox(height: 20),

                    // ─── Inauspicious Period (Rahu Kaal) ───
                    _buildInauspiciousPeriodCard(primaryPlum, charcoalText, subtitleColor),
                    const SizedBox(height: 24),

                    // ─── Upcoming Festivals ───
                    _buildUpcomingFestivals(primaryPlum, charcoalText, subtitleColor),
                    const SizedBox(height: 24),

                    // ─── Sacred Contributions / Donate Section ───
                    _buildSacredLinksSection(primaryPlum, charcoalText, subtitleColor),
                    const SizedBox(height: 24),

                    // ─── 1) Divine Videos & Satsang (Shorts, Videos, Live) ───
                    _buildVideosSection(primaryPlum, charcoalText, subtitleColor),
                    const SizedBox(height: 24),

                    // ─── 2) Amrit Vachan Card ───
                    _buildAmritVachanSection(primaryPlum, charcoalText, subtitleColor),
                    const SizedBox(height: 24),

                    // ─── 3) Spiritual Events Card ───
                    _buildEventsSection(primaryPlum, charcoalText, subtitleColor),
                    const SizedBox(height: 24),

                    // ─── 4) Family Jaap Card ───
                    _buildFamilySection(primaryPlum, charcoalText, subtitleColor),
                    const SizedBox(height: 24),

                    // ─── 5) Leaderboard Card ───
                    _buildLeaderboardSection(primaryPlum, charcoalText, subtitleColor),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: const AppBottomNav(currentTab: AppNavTab.home),
      ),
    );
  }

  // ─── Header ─────────────────────────────────────────────────────────────
  Widget _buildHeader(Color primaryPlum) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                size: 22,
                color: primaryPlum,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  context.tr('todayAuspicious'),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'serif',
                    color: primaryPlum,
                    letterSpacing: -0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        PopupMenuButton<String>(
          onSelected: _onLocationChanged,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          itemBuilder: (context) => _locations
              .map(
                (loc) => PopupMenuItem(
                  value: loc,
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 18,
                        color: loc == _selectedLocation ? primaryPlum : Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        loc,
                        style: TextStyle(
                          fontWeight: loc == _selectedLocation
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 18,
                color: Color(0xFF6B5F66),
              ),
              const SizedBox(width: 4),
              Text(
                _selectedLocation,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A3E45),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Date Section ────────────────────────────────────────────────────────
  Widget _buildDateSection(Color charcoalText, Color subtitleColor) {
    final gregorian = _panchangData?.gregorianFormatted.isNotEmpty == true
        ? _panchangData!.gregorianFormatted
        : context.tr('panchangGregorianDate');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('panchangDateHeader'),
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            fontFamily: 'serif',
            color: charcoalText,
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          gregorian,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: subtitleColor,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }

  // ─── Panchang Grid (2x2) ────────────────────────────────────────────────
  Widget _buildPanchangGrid(
    Color primaryPlum,
    Color charcoalText,
    Color subtitleColor,
  ) {
    final tithiName = _panchangData?.tithi.name.isNotEmpty == true
        ? context.trData(_panchangData!.tithi.name)
        : context.tr('tithiVal');
    final tithiEndsAt = _panchangData?.tithi.endsAt.isNotEmpty == true
        ? context.trData(_panchangData!.tithi.endsAt)
        : context.tr('tithiEndsAt');

    final nakshatraName = _panchangData?.nakshatra.name.isNotEmpty == true
        ? context.trData(_panchangData!.nakshatra.name)
        : context.tr('nakshatraVal');
    final nakshatraEndsAt = _panchangData?.nakshatra.endsAt.isNotEmpty == true
        ? context.trData(_panchangData!.nakshatra.endsAt)
        : context.tr('nakshatraEndsAt');

    final yogaName = _panchangData?.yoga.name.isNotEmpty == true
        ? context.trData(_panchangData!.yoga.name)
        : context.tr('yogaVal');
    final yogaEndsAt = _panchangData?.yoga.endsAt.isNotEmpty == true
        ? context.trData(_panchangData!.yoga.endsAt)
        : context.tr('yogaEndsAt');

    final karanaName = _panchangData?.karana.name.isNotEmpty == true
        ? context.trData(_panchangData!.karana.name)
        : context.tr('karanaVal');
    final karanaEndsAt = _panchangData?.karana.endsAt.isNotEmpty == true
        ? context.trData(_panchangData!.karana.endsAt)
        : context.tr('karanaEndsAt');

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildPanchangCard(
                icon: Icons.brightness_6_outlined,
                iconColor: primaryPlum,
                title: context.tr('tithi'),
                value: tithiName,
                time: tithiEndsAt,
                charcoalText: charcoalText,
                subtitleColor: subtitleColor,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildPanchangCard(
                icon: Icons.auto_awesome_outlined,
                iconColor: primaryPlum,
                title: context.tr('nakshatra'),
                value: nakshatraName,
                time: nakshatraEndsAt,
                charcoalText: charcoalText,
                subtitleColor: subtitleColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _buildPanchangCard(
                icon: Icons.all_inclusive_rounded,
                iconColor: primaryPlum,
                title: context.tr('yoga'),
                value: yogaName,
                time: yogaEndsAt,
                charcoalText: charcoalText,
                subtitleColor: subtitleColor,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildPanchangCard(
                icon: Icons.adjust_rounded,
                iconColor: primaryPlum,
                title: context.tr('karana'),
                value: karanaName,
                time: karanaEndsAt,
                charcoalText: charcoalText,
                subtitleColor: subtitleColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPanchangCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String time,
    required Color charcoalText,
    required Color subtitleColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF0E6EB), width: 1),
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
            children: [
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: subtitleColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              fontFamily: 'serif',
              color: charcoalText,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 3),
          Text(
            time,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: subtitleColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ─── Auspicious Timing Card (Abhijit Muhurat) ────────────────────────────
  Widget _buildAuspiciousTimingCard(Color mauveCard) {
    final timeRange = _panchangData?.abhijitMuhurat.timeRange ?? '11:51 AM - 12:45 PM';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: mauveCard,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: mauveCard.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.wb_sunny_rounded,
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        context.tr('auspiciousTiming').toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'SHUBH',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            context.tr('abhijitMuhurat'),
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              fontFamily: 'serif',
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            timeRange,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            context.tr('abhijitDesc'),
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCelestialTimingsCard(Color charcoalText, Color subtitleColor) {
    final sunrise = _panchangData?.celestial.sunrise ?? '05:32 AM';
    final sunset = _panchangData?.celestial.sunset ?? '07:05 PM';
    final moonrise = _panchangData?.celestial.moonrise ?? '02:15 PM';
    final moonset = _panchangData?.celestial.moonset ?? '03:40 AM';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFF0E6EB), width: 1),
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
          Text(
            context.tr('celestialTimings').toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF6A5D64),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildSunMoonItem(
                  icon: Icons.wb_sunny_rounded,
                  iconColor: const Color(0xFFF39C12),
                  title: context.tr('sunrise'),
                  time: sunrise,
                  charcoalText: charcoalText,
                  subtitleColor: subtitleColor,
                ),
              ),
              Expanded(
                child: _buildSunMoonItem(
                  icon: Icons.wb_twilight_rounded,
                  iconColor: const Color(0xFFE67E22),
                  title: context.tr('sunset'),
                  time: sunset,
                  charcoalText: charcoalText,
                  subtitleColor: subtitleColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF5EDF1)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSunMoonItem(
                  icon: Icons.nightlight_round,
                  iconColor: const Color(0xFF8E44AD),
                  title: context.tr('moonrise'),
                  time: moonrise,
                  charcoalText: charcoalText,
                  subtitleColor: subtitleColor,
                ),
              ),
              Expanded(
                child: _buildSunMoonItem(
                  icon: Icons.bedtime_outlined,
                  iconColor: const Color(0xFF5C6BC0),
                  title: context.tr('moonset'),
                  time: moonset,
                  charcoalText: charcoalText,
                  subtitleColor: subtitleColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSunMoonItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String time,
    required Color charcoalText,
    required Color subtitleColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: subtitleColor,
              ),
            ),
            Text(
              time,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: charcoalText,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─── Inauspicious Period (Rahu Kaal) ────────────────────────────────────
  Widget _buildInauspiciousPeriodCard(
    Color primaryPlum,
    Color charcoalText,
    Color subtitleColor,
  ) {
    final rahuTime = _panchangData?.rahuKaal.timeRange ?? '05:15 PM - 06:55 PM';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF4F7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEDDFE6), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryPlum.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.warning_amber_rounded,
              size: 20,
              color: primaryPlum,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        context.tr('rahuKaal'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: charcoalText,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      rahuTime,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: primaryPlum,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  context.tr('rahuKaalCaution'),
                  style: TextStyle(
                    fontSize: 11,
                    color: subtitleColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Upcoming Festivals ─────────────────────────────────────────────────
  Widget _buildUpcomingFestivals(
    Color primaryPlum,
    Color charcoalText,
    Color subtitleColor,
  ) {
    final fest1 = _festivals.isNotEmpty
        ? _festivals[0]
        : const FestivalItem(
            id: 'f1',
            title: 'गोवर्धन पूजा',
            subtitle: 'कार्तिक शुक्ल प्रतिपदा',
            date: '',
            badge: 'कल',
            daysLeft: 1,
            description: '',
          );

    final fest2 = _festivals.length > 1
        ? _festivals[1]
        : const FestivalItem(
            id: 'f2',
            title: 'वरूथिनी एकादशी',
            subtitle: 'श्री हरि विष्णु पूजन एवं व्रत',
            date: '',
            badge: '3 दिनों में',
            daysLeft: 3,
            description: '',
          );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                context.tr('upcomingFestivals').toUpperCase(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF6A5D64),
                  letterSpacing: 0.8,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () => context.push('/events'),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                context.tr('viewAll'),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: primaryPlum,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildFestivalCard(
                badge: context.trData(fest1.badge),
                hasIcon: true,
                title: context.trData(fest1.title),
                subtitle: context.trData(fest1.subtitle),
                charcoalText: charcoalText,
                subtitleColor: subtitleColor,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildFestivalCard(
                badge: context.trData(fest2.badge),
                hasIcon: false,
                title: context.trData(fest2.title),
                subtitle: context.trData(fest2.subtitle),
                charcoalText: charcoalText,
                subtitleColor: subtitleColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFestivalCard({
    required String badge,
    required bool hasIcon,
    required String title,
    required String subtitle,
    required Color charcoalText,
    required Color subtitleColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF0E6EB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFFCE8EF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  badge,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF8E3763),
                  ),
                ),
                if (hasIcon) ...[
                  const SizedBox(width: 4),
                  const Text('🎉', style: TextStyle(fontSize: 10)),
                ],
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              fontFamily: 'serif',
              color: charcoalText,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: subtitleColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ─── Sacred Contributions / Donate Section ──────────────────────────────
  Widget _buildSacredLinksSection(
    Color primaryPlum,
    Color charcoalText,
    Color subtitleColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('sacredSeva').toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Color(0xFF6A5D64),
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => context.push('/donate'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFF0F5), Color(0xFFFBE4ED)],
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFF7D9E4), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: primaryPlum.withOpacity(0.06),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: primaryPlum.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('🐄', style: TextStyle(fontSize: 22)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              context.tr('supportOurCows'),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'serif',
                                color: charcoalText,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8E3763),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              context.tr('donateBtn'),
                              style: const TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        context.tr('donateDesc'),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: subtitleColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: primaryPlum,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── 1) Divine Videos & Satsang Section ──────────────────────────────────
  Widget _buildVideosSection(
    Color primaryPlum,
    Color charcoalText,
    Color subtitleColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                context.tr('videosTitle').toUpperCase(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF6A5D64),
                  letterSpacing: 0.8,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => context.push('/videos'),
              child: Text(
                context.tr('viewAll'),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: primaryPlum,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildVideoCategoryCard(
                icon: Icons.play_circle_fill_rounded,
                title: context.tr('shortsTab'),
                subtitle: 'Quick Darshan',
                iconColor: const Color(0xFFE91E63),
                onTap: () => context.push('/videos'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildVideoCategoryCard(
                icon: Icons.video_library_rounded,
                title: context.tr('videosTab'),
                subtitle: 'Katha & Pravachan',
                iconColor: const Color(0xFF9C27B0),
                onTap: () => context.push('/videos'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildVideoCategoryCard(
                icon: Icons.sensors_rounded,
                title: context.tr('liveTab'),
                subtitle: 'Aarti & Utsav',
                iconColor: const Color(0xFFFF5722),
                isLive: true,
                onTap: () => context.push('/videos'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVideoCategoryCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    bool isLive = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFF2E7EC)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.025),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.09),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                if (isLive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'LIVE',
                      style: TextStyle(
                        fontSize: 7.5,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2E2428),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF8C8287),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── 2) Amrit Vachan Card ────────────────────────────────────────────────
  Widget _buildAmritVachanSection(
    Color primaryPlum,
    Color charcoalText,
    Color subtitleColor,
  ) {
    final vachanQuote = _todayAmritVachan?.caption.isNotEmpty == true
        ? _todayAmritVachan!.caption
        : 'जो व्यक्ति हर पल में ईश्वर का स्मरण करता है, उसके जीवन की समस्त चिंताएं प्रभु हर लेते हैं।';
    final imageUrl = _todayAmritVachan?.imageUrl;
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                context.tr('amritVachanHeader').toUpperCase(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF6A5D64),
                  letterSpacing: 0.8,
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => context.push('/amrit-vachan'),
              child: Text(
                context.tr('viewAll'),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: primaryPlum,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => context.push('/amrit-vachan'),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasImage)
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                          'assets/images/temple_welcome.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFBEBF1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.auto_awesome, size: 12, color: primaryPlum),
                                  const SizedBox(width: 4),
                                  Text(
                                    context.tr('amritVachanHeader'),
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w800,
                                      color: primaryPlum,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          vachanQuote,
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            color: charcoalText,
                            fontFamily: 'serif',
                            height: 1.45,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventsSection(
    Color primaryPlum,
    Color charcoalText,
    Color subtitleColor,
  ) {
    final eventTitle = _featuredEvent?.title.isNotEmpty == true
        ? _featuredEvent!.title
        : context.tr('featuredEventTitle');
    final eventLocation = _featuredEvent?.location.isNotEmpty == true
        ? _featuredEvent!.location
        : context.tr('featuredEventLocation');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                context.tr('spiritualEvents').toUpperCase(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF6A5D64),
                  letterSpacing: 0.8,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => context.push('/events'),
              child: Text(
                context.tr('viewAll'),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: primaryPlum,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => context.push('/events'),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2F0EA)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2E8A68).withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBF7F2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Text(
                        context.tr('featuredEventMonth'),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2E8A68),
                        ),
                      ),
                      Text(
                        context.tr('featuredEventDate'),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1B6349),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eventTitle,
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: charcoalText,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            size: 13,
                            color: Color(0xFF2E8A68),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              eventLocation,
                              style: TextStyle(
                                fontSize: 11.5,
                                color: subtitleColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Color(0xFF2E8A68),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── 4) Family Jaap Card ─────────────────────────────────────────────────
  Widget _buildFamilySection(
    Color primaryPlum,
    Color charcoalText,
    Color subtitleColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                context.tr('familyHeader').toUpperCase(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF6A5D64),
                  letterSpacing: 0.8,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => context.push('/family'),
              child: Text(
                context.tr('viewAll'),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: primaryPlum,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => context.push('/family'),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFAF7FF), Color(0xFFF3EDFB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE4D7F5)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF764BB2).withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF764BB2).withOpacity(0.1),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('👨‍👩‍👧‍👦', style: TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr('familyTree'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: charcoalText,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        context.tr('familyDesc'),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Color(0xFF764BB2),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── 5) Leaderboard Card ─────────────────────────────────────────────────
  Widget _buildLeaderboardSection(
    Color primaryPlum,
    Color charcoalText,
    Color subtitleColor,
  ) {
    final topSadhakName = _topSadhak?.name.isNotEmpty == true ? _topSadhak!.name : 'शीर्ष साधक';
    final topSadhakJaps = _topSadhak != null ? '${_topSadhak!.totalJaps} ${context.tr('jaapUnit')} • ${_topSadhak!.totalMalas} ${context.tr('malasUnit')}' : 'वैश्विक साधक रैंकिंग';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                context.tr('leaderboardHeader').toUpperCase(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF6A5D64),
                  letterSpacing: 0.8,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => context.push('/leaderboard'),
              child: Text(
                context.tr('viewAll'),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: primaryPlum,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => context.push('/leaderboard'),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFF7ED), Color(0xFFFEF3C7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFFDE68A)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD97706).withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFD97706).withOpacity(0.12),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('🏆', style: TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              topSadhakName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: charcoalText,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD97706),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              '#1',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        topSadhakJaps,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Color(0xFFD97706),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
