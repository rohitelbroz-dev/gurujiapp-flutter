import 'package:shared_preferences/shared_preferences.dart';

class AppLanguage {
  final String code;
  final String nativeName;
  final String englishName;

  const AppLanguage({
    required this.code,
    required this.nativeName,
    required this.englishName,
  });
}

class LanguageService {
  static const String _languageKey = 'app_language_code';
  static const String _hasChosenLanguageKey = 'has_chosen_language';
  static const String _hasSeenWelcomeKey = 'has_seen_welcome';

  static const List<AppLanguage> supportedLanguages = [
    AppLanguage(
      code: 'hi',
      nativeName: 'हिन्दी',
      englishName: 'Hindi',
    ),
    AppLanguage(
      code: 'en',
      nativeName: 'English',
      englishName: 'English',
    ),
    AppLanguage(
      code: 'mr',
      nativeName: 'मराठी',
      englishName: 'Marathi',
    ),
    AppLanguage(
      code: 'gu',
      nativeName: 'ગુજરાતી',
      englishName: 'Gujarati',
    ),
    AppLanguage(
      code: 'ta',
      nativeName: 'தமிழ்',
      englishName: 'Tamil',
    ),
    AppLanguage(
      code: 'te',
      nativeName: 'తెలుగు',
      englishName: 'Telugu',
    ),
  ];

  static Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
    await prefs.setBool(_hasChosenLanguageKey, true);
  }

  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'hi';
  }

  static Future<bool> hasChosenLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasChosenLanguageKey) ?? false;
  }

  static Future<void> setHasSeenWelcome(bool seen) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSeenWelcomeKey, seen);
  }

  static Future<bool> hasSeenWelcome() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasSeenWelcomeKey) ?? false;
  }
}
