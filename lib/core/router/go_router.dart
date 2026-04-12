import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guruji/features/auth/presentation/login_screen.dart';
import 'package:guruji/features/auth/presentation/otp_screen.dart';
import 'package:guruji/features/home/presentation/homescreen.dart';
import 'package:guruji/features/auth/presentation/register_screen.dart';
import 'package:guruji/features/auth/presentation/profile_screen.dart';
import 'package:guruji/features/events/presentation/events_screen.dart';
import 'package:guruji/features/videos/presentation/videos_screen.dart';
import 'package:guruji/core/services/user_persistence_service.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) async {
    final isLoggedIn = await UserPersistenceService.isLoggedIn();

    // If user is logged in and trying to access auth routes, redirect to home
    if (isLoggedIn) {
      if (state.matchedLocation == '/' ||
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register') {
        return '/home';
      }
    } else {
      // If user is not logged in and trying to access protected routes, redirect to login
      if (state.matchedLocation == '/home') {
        return '/login';
      }
    }

    // Default redirect from root to login
    if (state.matchedLocation == '/') {
      return '/login';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        if (extra == null) {
          return const LoginScreen(); // Fallback if no extra data
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
      path: '/profile',
      builder: (context, state) => const ProfileSettingsScreen(),
    ),
    GoRoute(
      path: '/events',
      builder: (context, state) => const EventsScreen(),
    ),
    GoRoute(
      path: '/videos',
      builder: (context, state) => const VideosScreen(),
    ),
  ],
);
