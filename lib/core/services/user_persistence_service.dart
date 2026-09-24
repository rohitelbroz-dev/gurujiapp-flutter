import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserPersistenceService {
  static const String _tokenKey = 'auth_token';
  static const String _userDataKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';

  static Future<void> saveUserSession(String token, Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userDataKey, jsonEncode(userData));
    await prefs.setBool(_isLoggedInKey, true);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(_userDataKey);
    if (userDataString != null) {
      try {
        return jsonDecode(userDataString) as Map<String, dynamic>;
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userDataKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
  static const String _profileImagePathKey = 'user_profile_image_path';
  static const String _favoriteAudiosKey = 'user_favorite_audios';

  static Future<void> saveUserProfileImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileImagePathKey, path);
  }

  static Future<String?> getUserProfileImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_profileImagePathKey);
  }

  static Future<void> clearUserProfileImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileImagePathKey);
  }

  static Future<Set<String>> getFavoriteAudioIds() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_favoriteAudiosKey) ?? [];
    return list.toSet();
  }

  static Future<bool> toggleFavoriteAudioId(String trackId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_favoriteAudiosKey) ?? [];
    final set = list.toSet();
    bool isNowFav;
    if (set.contains(trackId)) {
      set.remove(trackId);
      isNowFav = false;
    } else {
      set.add(trackId);
      isNowFav = true;
    }
    await prefs.setStringList(_favoriteAudiosKey, set.toList());
    return isNowFav;
  }
  static const String _preferredCityKey = 'user_preferred_city';
  static const String _muhuratAlertsKey = 'pref_muhurat_alerts';
  static const String _prayerRemindersKey = 'pref_prayer_reminders';
  static const String _totalDonationsKey = 'user_total_donations';

  static Future<void> savePreferredCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_preferredCityKey, city);
  }

  static Future<String?> getPreferredCity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_preferredCityKey);
  }

  static Future<void> saveMuhuratAlerts(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_muhuratAlertsKey, enabled);
  }

  static Future<bool> getMuhuratAlerts() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_muhuratAlertsKey) ?? true;
  }

  static Future<void> savePrayerReminders(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prayerRemindersKey, enabled);
  }

  static Future<bool> getPrayerReminders() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prayerRemindersKey) ?? true;
  }

  static Future<void> saveTotalDonation(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_totalDonationsKey, amount);
  }

  static Future<int> getTotalDonation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_totalDonationsKey) ?? 0;
  }
}