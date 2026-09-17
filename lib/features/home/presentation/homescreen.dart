import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:guruji/core/localization/app_strings.dart';
import 'package:guruji/core/widgets/app_bottom_nav.dart';

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
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
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

                  // ─── Celestial Timings ───
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
        bottomNavigationBar: const AppBottomNav(currentTab: AppNavTab.panchang),
      ),
    );
  }

  // ─── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader(Color primaryPlum) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 24,
              color: primaryPlum,
            ),
            const SizedBox(width: 8),
            Text(
              context.tr('todayAuspicious'),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: 'serif',
                color: primaryPlum,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        PopupMenuButton<String>(
          onSelected: (loc) {
            setState(() {
              _selectedLocation = loc;
            });
          },
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

  // ─── Date Section ──────────────────────────────────────────────────────────
  Widget _buildDateSection(Color charcoalText, Color subtitleColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Margashirsha, Krishna Paksha',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w800,
            fontFamily: 'serif',
            color: charcoalText,
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Tuesday, 14 Nov 2023',
          style: TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w500,
            color: subtitleColor,
          ),
        ),
      ],
    );
  }

  // ─── 2x2 Panchang Grid ─────────────────────────────────────────────────────
  Widget _buildPanchangGrid(
    Color primaryPlum,
    Color charcoalText,
    Color subtitleColor,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildPanchangCard(
                icon: Icons.nightlight_round,
                title: 'TITHI',
                value: 'Pratipada',
                endsAt: 'Ends at 02:36 PM',
                charcoalText: charcoalText,
                subtitleColor: subtitleColor,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildPanchangCard(
                icon: Icons.star_border_rounded,
                title: 'NAKSHATRA',
                value: 'Krittika',
                endsAt: 'Ends at 04:12 AM (Next Day)',
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
                icon: Icons.self_improvement_rounded,
                title: 'YOGA',
                value: 'Shiva',
                endsAt: 'Ends at 09:15 AM',
                charcoalText: charcoalText,
                subtitleColor: subtitleColor,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildPanchangCard(
                icon: Icons.timelapse_rounded,
                title: 'KARANA',
                value: 'Bava',
                endsAt: 'Ends at 02:36 PM',
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
    required String title,
    required String value,
    required String endsAt,
    required Color charcoalText,
    required Color subtitleColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: const Color(0xFF6A5D64)),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF6A5D64),
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              fontFamily: 'serif',
              color: charcoalText,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            endsAt,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: subtitleColor,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Auspicious Timing Card ────────────────────────────────────────────────
  Widget _buildAuspiciousTimingCard(Color mauveCard) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
            children: [
              const Icon(
                Icons.wb_sunny_outlined,
                size: 16,
                color: Colors.white,
              ),
              const SizedBox(width: 6),
              Text(
                'AUSPICIOUS TIMING',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withOpacity(0.9),
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Abhijit Muhurat',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              fontFamily: 'serif',
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.22),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  size: 20,
                  color: Colors.white,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '11:45 AM - 12:28 PM',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Ideal for important new beginnings',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Celestial Timings Card ────────────────────────────────────────────────
  Widget _buildCelestialTimingsCard(Color charcoalText, Color subtitleColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _buildCelestialItem(
                  icon: Icons.wb_twilight_rounded,
                  label: context.tr('sunrise'),
                  time: '06:42 AM',
                  bgColor: const Color(0xFFFBEBF1),
                  iconColor: const Color(0xFF9E3A6B),
                  charcoalText: charcoalText,
                  subtitleColor: subtitleColor,
                ),
              ),
              Expanded(
                child: _buildCelestialItem(
                  icon: Icons.wb_sunny_rounded,
                  label: context.tr('sunset'),
                  time: '05:28 PM',
                  bgColor: const Color(0xFFF1EFF1),
                  iconColor: const Color(0xFF6B5F66),
                  charcoalText: charcoalText,
                  subtitleColor: subtitleColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildCelestialItem(
                  icon: Icons.nightlight_round,
                  label: context.tr('moonrise'),
                  time: '07:15 AM',
                  bgColor: const Color(0xFFFBEBF1),
                  iconColor: const Color(0xFF9E3A6B),
                  charcoalText: charcoalText,
                  subtitleColor: subtitleColor,
                ),
              ),
              Expanded(
                child: _buildCelestialItem(
                  icon: Icons.bedtime_outlined,
                  label: context.tr('moonset'),
                  time: '06:05 PM',
                  bgColor: const Color(0xFFF5EFEA),
                  iconColor: const Color(0xFF8A6B52),
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

  Widget _buildCelestialItem({
    required IconData icon,
    required String label,
    required String time,
    required Color bgColor,
    required Color iconColor,
    required Color charcoalText,
    required Color subtitleColor,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: subtitleColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 1),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  time,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: charcoalText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Inauspicious Period Card (Rahu Kaal) ───────────────────────────────────
  Widget _buildInauspiciousPeriodCard(
    Color primaryPlum,
    Color charcoalText,
    Color subtitleColor,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF4F6),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFF7E2E8), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 16,
                color: primaryPlum,
              ),
              const SizedBox(width: 6),
              Text(
                context.tr('inauspiciousPeriod').toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: primaryPlum,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 3,
                      height: 38,
                      decoration: BoxDecoration(
                        color: primaryPlum,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr('rahuKaal'),
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'serif',
                              color: charcoalText,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            context.tr('rahuKaalCaution'),
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w400,
                              color: subtitleColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  '03:00 PM -\n04:30 PM',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: charcoalText,
                    height: 1.25,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Upcoming Festivals ────────────────────────────────────────────────────
  Widget _buildUpcomingFestivals(
    Color primaryPlum,
    Color charcoalText,
    Color subtitleColor,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.tr('upcomingFestivals').toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF6A5D64),
                letterSpacing: 0.8,
              ),
            ),
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
                badge: 'TOMORROW',
                hasIcon: true,
                title: 'Govardhan Puja',
                subtitle: 'Kartik Shukla Pratipada',
                charcoalText: charcoalText,
                subtitleColor: subtitleColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFestivalCard(
                badge: 'IN 3 DAYS',
                hasIcon: false,
                title: 'Bhai Dooj',
                subtitle: 'Kartik Shukla Dwitiya',
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
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBEBF1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF8A305D),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              if (hasIcon) ...[
                const SizedBox(width: 4),
                const Icon(
                  Icons.celebration_outlined,
                  size: 14,
                  color: Color(0xFF8A305D),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
                fontFamily: 'serif',
                color: charcoalText,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
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
    );
  }

  // ─── Sacred Contributions / Donate Section ────────────────────────────────
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

  // ─── 1) Divine Videos & Satsang Section ───────────────────────────────────
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
            Text(
              context.tr('videosTitle').toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF6A5D64),
                letterSpacing: 0.8,
              ),
            ),
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
        // Row of 3 Video Category cards: Shorts, Videos, Live
        Row(
          children: [
            Expanded(
              child: _buildVideoCategoryCard(
                title: context.tr('shortsTab'),
                subtitle: 'Quick Darshan',
                icon: Icons.play_circle_filled_rounded,
                badgeColor: const Color(0xFFE91E63),
                bgColor: const Color(0xFFFFF0F5),
                onTap: () => context.push('/videos', extra: {'initialType': 'short'}),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildVideoCategoryCard(
                title: context.tr('videosTab'),
                subtitle: 'Katha & Pravachan',
                icon: Icons.video_library_rounded,
                badgeColor: primaryPlum,
                bgColor: const Color(0xFFFBF4F7),
                onTap: () => context.push('/videos', extra: {'initialType': 'regular'}),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildVideoCategoryCard(
                title: context.tr('liveTab'),
                subtitle: 'Aarti & Utsav',
                icon: Icons.sensors_rounded,
                badgeColor: const Color(0xFFE53935),
                bgColor: const Color(0xFFFFEBEE),
                isLive: true,
                onTap: () => context.push('/videos', extra: {'initialType': 'live'}),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Featured Video Highlight Card
        GestureDetector(
          onTap: () => context.push('/videos', extra: {'initialType': 'regular'}),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFF3E5EB)),
              boxShadow: [
                BoxShadow(
                  color: primaryPlum.withOpacity(0.04),
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
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7E2B58), Color(0xFFCE6590)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr('videosAndSatsang'),
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: charcoalText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        context.tr('videosDesc'),
                        style: TextStyle(
                          fontSize: 11.5,
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: primaryPlum,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoCategoryCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color badgeColor,
    required Color bgColor,
    required VoidCallback onTap,
    bool isLive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFF3E5EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: badgeColor, size: 22),
                ),
                if (isLive)
                  Positioned(
                    top: -4,
                    right: -6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'LIVE',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F1A1D),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 9.5,
                color: Color(0xFF6B5F66),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // ─── 2) Amrit Vachan Section ───────────────────────────────────────────────
  Widget _buildAmritVachanSection(
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
            Text(
              context.tr('amritVachanHeader').toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF6A5D64),
                letterSpacing: 0.8,
              ),
            ),
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
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFF9F0), Color(0xFFFFF0E6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFFFE0CC)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFC86134).withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC86134),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.auto_stories_rounded, color: Colors.white, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            context.tr('amritVachanHeader'),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const Text('📜', style: TextStyle(fontSize: 20)),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  '“जिसका मन प्रभु के चरणों में समर्पित है, उसे संसार का कोई भी भय विचलित नहीं कर सकता।”',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'serif',
                    color: Color(0xFF4A2810),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.tr('amritVachanTitle'),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF9E4B25),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          context.tr('share'),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: primaryPlum,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 14,
                          color: primaryPlum,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── 3) Spiritual Events Section ──────────────────────────────────────────
  Widget _buildEventsSection(
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
            Text(
              context.tr('spiritualEvents').toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF6A5D64),
                letterSpacing: 0.8,
              ),
            ),
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
                  child: const Column(
                    children: [
                      Text(
                        'NOV',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2E8A68),
                        ),
                      ),
                      Text(
                        '27',
                        style: TextStyle(
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
                        'Kartik Purnima Mahotsav',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: charcoalText,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 13, color: subtitleColor),
                          const SizedBox(width: 3),
                          Text(
                            'Shri Dham Vrindavan • Live Darshan',
                            style: TextStyle(
                              fontSize: 11,
                              color: subtitleColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: primaryPlum,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── 4) Family Jaap Section ───────────────────────────────────────────────
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
            Text(
              context.tr('familyHeader').toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF6A5D64),
                letterSpacing: 0.8,
              ),
            ),
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
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: charcoalText,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        context.tr('familyDesc'),
                        style: TextStyle(
                          fontSize: 11.5,
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF764BB2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    context.tr('familyTree'),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── 5) Leaderboard Section ───────────────────────────────────────────────
  Widget _buildLeaderboardSection(
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
            Text(
              context.tr('leaderboardHeader').toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF6A5D64),
                letterSpacing: 0.8,
              ),
            ),
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
                colors: [Color(0xFFFFFDF5), Color(0xFFFFF8E1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFFFECB3)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFB8860B).withOpacity(0.06),
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
                        color: const Color(0xFFB8860B).withOpacity(0.12),
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
                      Text(
                        context.tr('sadhakLeaderboard'),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: charcoalText,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        context.tr('leaderboardDesc'),
                        style: TextStyle(
                          fontSize: 11.5,
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: primaryPlum,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

