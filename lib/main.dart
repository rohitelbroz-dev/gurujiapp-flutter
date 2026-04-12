import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:guruji/core/router/go_router.dart';
import 'package:guruji/core/services/user_persistence_service.dart';
import 'package:guruji/features/auth/bloc/auth_bloc.dart';
import 'package:guruji/features/auth/data/auth_repositiory.dart';
import 'package:guruji/features/events/bloc/events_bloc.dart';
import 'package:guruji/features/events/data/events_repository.dart';
import 'package:guruji/features/videos/bloc/videos_bloc.dart';
import 'package:guruji/features/videos/data/videos_repository.dart';

// Custom HttpOverrides to handle certificate verification
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        // Allow all certificates for development
        return true;
      };
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Allow certificate tolerance for development only
  if (!kReleaseMode) {
    HttpOverrides.global = MyHttpOverrides();
  }

  // Check if user is already logged in
  final isLoggedIn = await UserPersistenceService.isLoggedIn();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(authRepository: AuthRepository()),
        ),
        BlocProvider(
          create: (_) => EventsBloc(eventsRepository: EventsRepository()),
        ),
        BlocProvider(
          create: (_) => VideosBloc(videosRepository: VideosRepository()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Guruji',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}
