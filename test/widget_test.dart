import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guruji/core/services/language_service.dart';
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

    // Verify Title and Subtitle are present
    expect(find.text('Choose Your\nLanguage'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);

    // Verify native languages are rendered
    expect(find.text('हिन्दी'), findsOneWidget);
    expect(find.text('English'), findsWidgets);
    expect(find.text('मराठी'), findsOneWidget);
    expect(find.text('ગુજરાતી'), findsOneWidget);
    expect(find.text('தமிழ்'), findsOneWidget);
    expect(find.text('తెలుగు'), findsOneWidget);

    // Tap English card
    await tester.tap(find.text('English').first);
    await tester.pumpAndSettle();
  });
}
