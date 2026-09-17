import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guruji/core/services/language_service.dart';
import 'package:guruji/core/services/user_persistence_service.dart';
import 'package:guruji/features/amrit_vachan/presentation/amrit_vachan_screen.dart';
import 'package:guruji/features/auth/presentation/login_screen.dart';
import 'package:guruji/features/auth/presentation/otp_screen.dart';
import 'package:guruji/features/auth/presentation/profile_screen.dart';
import 'package:guruji/features/auth/presentation/register_screen.dart';
import 'package:guruji/features/events/presentation/events_screen.dart';
import 'package:guruji/features/family/presentation/family_screen.dart';
import 'package:guruji/features/home/presentation/homescreen.dart';
import 'package:guruji/features/language/presentation/choose_language_screen.dart';
import 'package:guruji/features/leaderboard/presentation/leaderboard_screen.dart';
import 'package:guruji/features/naam_jaap/presentation/naam_jaap_screen.dart';
import 'package:guruji/features/videos/presentation/shorts_screen.dart';
import 'package:guruji/features/videos/presentation/videos_screen.dart';
import 'package:guruji/features/welcome/presentation/welcome_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) async {
    final hasChosenLang = await LanguageService.hasChosenLanguage();
    final hasSeenWelcome = await LanguageService.hasSeenWelcome();
    final isLoggedIn = await UserPersistenceService.isLoggedIn();

    final matched = state.matchedLocation;

    // First time launch: Choose Language Screen
    if (!hasChosenLang) {
      if (matched == '/choose-language') return null;
      return '/choose-language';
    }

    // After language chosen: Welcome Onboarding Screen
    if (!hasSeenWelcome) {
      if (matched == '/welcome' || matched == '/choose-language') return null;
      return '/welcome';
    }

    // Once welcome is completed, root or welcome redirect directly to home
    if (matched == '/' || matched == '/welcome') {
      return '/home';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/choose-language',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final isFromSettings = extra?['fromSettings'] as bool? ?? false;
        return ChooseLanguageScreen(isFromSettings: isFromSettings);
      },
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        if (extra == null) {
          return const LoginScreen();
        }
        return OtpScreen(
          phone: extra['phone'] as String,
          expiresIn: extra['expiresIn'] as int,
          otpCode: extra['otpCode'] as String?,
        );
      },
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/naam-jaap',
      builder: (context, state) => const NaamJaapScreen(),
    ),
    GoRoute(
      path: '/leaderboard',
      builder: (context, state) => const LeaderboardScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileSettingsScreen(),
    ),
    GoRoute(
      path: '/events',
      builder: (context, state) => const EventsScreen(),
    ),
    GoRoute(
      path: '/amrit-vachan',
      builder: (context, state) => const AmritVachanScreen(),
    ),
    GoRoute(
      path: '/videos',
      builder: (context, state) => const VideosScreen(),
    ),
    GoRoute(
      path: '/shorts',
      builder: (context, state) => const ShortsScreen(),
    ),
    GoRoute(
      path: '/family',
      builder: (context, state) => const FamilyScreen(),
    ),
  ],
);
