import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class DonateScreen extends StatefulWidget {
  const DonateScreen({super.key});

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  String _selectedPlan = 'Monthly';

  @override
  Widget build(BuildContext context) {
    const Color bgGradientStart = Color(0xFFFFFDFE);
    const Color bgGradientEnd = Color(0xFFFBF4F7);
    const Color primaryPlum = Color(0xFF7E2B58);
    const Color buttonColor = Color(0xFF8E3763);
    const Color charcoalText = Color(0xFF1E1A1D);
    const Color subtitleColor = Color(0xFF6B5E66);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

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
            bottom: false,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ─── Header: Back, Hari Path, Profile ───
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Color(0xFF221C20)),
                              onPressed: () {
                                if (context.canPop()) {
                                  context.pop();
                                } else {
                                  context.go('/home');
                                }
                              },
                            ),
                            Text(
                              'Hari Path',
                              style: TextStyle(
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
                        const SizedBox(height: 24),

                        // ─── Step Indicator ───
                        const Text(
                          'STEP 1 OF 3',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF7A6D74),
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // ─── Title & Subtitle ───
                        Text(
                          'Support Our Cows',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'serif',
                            color: primaryPlum,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Choose a recurring contribution to ensure daily nourishment and care for the sacred cows.',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w400,
                            color: subtitleColor,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 28),

                        // ─── Daily Plan Card ───
                        _buildDonationCard(
                          planId: 'Daily',
                          title: 'Daily',
                          subtitle: 'A small gesture every day.',
                          priceText: '₹11',
                          frequencyText: '/day',
                          isMostPopular: false,
                          primaryPlum: primaryPlum,
                          charcoalText: charcoalText,
                          subtitleColor: subtitleColor,
                        ),
                        const SizedBox(height: 16),

                        // ─── Monthly Plan Card (Most Popular) ───
                        _buildDonationCard(
                          planId: 'Monthly',
                          title: 'Monthly',
                          subtitle: 'Consistent monthly support.',
                          priceText: '₹300',
                          frequencyText: '/month',
                          isMostPopular: true,
                          primaryPlum: primaryPlum,
                          charcoalText: charcoalText,
                          subtitleColor: subtitleColor,
                        ),
                        const SizedBox(height: 16),

                        // ─── Yearly Plan Card ───
                        _buildDonationCard(
                          planId: 'Yearly',
                          title: 'Yearly',
                          subtitle: 'Long-term devotion and care.',
                          priceText: '₹3100',
                          frequencyText: '/year',
                          isMostPopular: false,
                          primaryPlum: primaryPlum,
                          charcoalText: charcoalText,
                          subtitleColor: subtitleColor,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // ─── Bottom Button ───
                Padding(
                  padding: EdgeInsets.fromLTRB(24, 8, 24, bottomPadding + 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            title: Text(
                              '🙏 Sacred Gauseva',
                              style: TextStyle(
                                fontFamily: 'serif',
                                fontWeight: FontWeight.w700,
                                color: primaryPlum,
                              ),
                            ),
                            content: Text(
                              'Thank you for selecting the $_selectedPlan plan. Your devotion and contribution helps nourish and protect the holy Gaumata.',
                              style: const TextStyle(fontSize: 14.5, height: 1.4),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  context.pop();
                                },
                                child: Text(
                                  'Proceed to Gateway',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: primaryPlum,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: Colors.white,
                        elevation: 6,
                        shadowColor: buttonColor.withOpacity(0.45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: const Text(
                        'Continue to Payment',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
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

  Widget _buildDonationCard({
    required String planId,
    required String title,
    required String subtitle,
    required String priceText,
    required String frequencyText,
    required bool isMostPopular,
    required Color primaryPlum,
    required Color charcoalText,
    required Color subtitleColor,
  }) {
    final isSelected = _selectedPlan == planId;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPlan = planId;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? primaryPlum : const Color(0xFFF1E3EA),
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? primaryPlum.withOpacity(0.1)
                  : Colors.black.withOpacity(0.03),
              blurRadius: isSelected ? 14 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Most Popular Tag
              if (isMostPopular)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    decoration: const BoxDecoration(
                      color: Color(0xFF8E3763),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Most Popular',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'serif',
                              color: charcoalText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: subtitleColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          priceText,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'serif',
                            color: primaryPlum,
                          ),
                        ),
                        Text(
                          frequencyText,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: subtitleColor,
                          ),
                        ),
                        if (isSelected) ...[
                          const SizedBox(height: 6),
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: primaryPlum, width: 2),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.check,
                                size: 14,
                                color: primaryPlum,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
