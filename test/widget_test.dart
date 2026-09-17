import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guruji/features/language/bloc/language_bloc.dart';
import 'package:guruji/features/language/presentation/choose_language_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('ChooseLanguageScreen displays supported languages and selects Hindi by default', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => LanguageBloc(),
          child: const ChooseLanguageScreen(),
        ),
      ),
    );

    // Verify Initial Hindi Title and Button (default 'hi')
    expect(find.text('अपनी भाषा\nचुनें'), findsOneWidget);
    expect(find.text('शुरू करें'), findsOneWidget);

    // Verify native languages are rendered
    expect(find.text('हिन्दी'), findsOneWidget);
    expect(find.text('English'), findsWidgets);
    expect(find.text('मराठी'), findsOneWidget);
    expect(find.text('ગુજરાતી'), findsOneWidget);
    expect(find.text('தமிழ்'), findsOneWidget);
    expect(find.text('తెలుగు'), findsOneWidget);

    // Tap English card to change language
    await tester.tap(find.text('English').first);
    await tester.pumpAndSettle();

    // Verify reactive update to English
    expect(find.text('Choose Your\nLanguage'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
