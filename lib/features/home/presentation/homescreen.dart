import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
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
                  const SizedBox(height: 16),
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
              "Today's Panchang",
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
          const Text(
            'CELESTIAL TIMINGS',
            style: TextStyle(
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
                  label: 'Sunrise',
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
                  label: 'Sunset',
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
                  label: 'Moonrise',
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
                  label: 'Moonset',
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
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: subtitleColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              time,
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: charcoalText,
              ),
            ),
          ],
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
      padding: const EdgeInsets.all(18),
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
                'INAUSPICIOUS PERIOD',
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
              Row(
                children: [
                  Container(
                    width: 3,
                    height: 38,
                    decoration: BoxDecoration(
                      color: primaryPlum,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rahu Kaal',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'serif',
                          color: charcoalText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Avoid starting important tasks',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                '03:00 PM -\n04:30 PM',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: charcoalText,
                  height: 1.25,
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
            const Text(
              'UPCOMING FESTIVALS',
              style: TextStyle(
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
                'View All',
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
            const SizedBox(width: 14),
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
      padding: const EdgeInsets.all(16),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBEBF1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF8A305D),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              if (hasIcon) ...[
                const SizedBox(width: 6),
                const Icon(
                  Icons.celebration_outlined,
                  size: 16,
                  color: Color(0xFF8A305D),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16.5,
              fontWeight: FontWeight.w700,
              fontFamily: 'serif',
              color: charcoalText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
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
        const Text(
          'SACRED SEVA & CONTRIBUTIONS',
          style: TextStyle(
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
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFF0F5), Color(0xFFFBE4ED)],
              ),
              borderRadius: BorderRadius.circular(24),
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
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: primaryPlum.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('🐄', style: TextStyle(fontSize: 26)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Support Our Cows',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'serif',
                              color: charcoalText,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8E3763),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'Donate',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Ensure daily nourishment & care for Gaumata',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
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
}
