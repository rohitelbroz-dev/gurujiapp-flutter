import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:guruji/core/constant/api_constants.dart';
import 'package:guruji/core/services/user_persistence_service.dart';
import 'package:guruji/features/naam_jaap/models/naam_jaap_stats.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NaamJaapRepository {
  final String _baseUrl = ApiConstants.baseUrl;
  static const String _draftSessionCountKey = 'naam_jaap_draft_session_count';

  Future<void> saveMantraCount(int count) async {
    final token = await UserPersistenceService.getToken();
    final url = Uri.parse('$_baseUrl/mantra/count');

    try {
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              if (token != null && token.isNotEmpty)
                'Authorization': 'Bearer $token',
            },
            body: jsonEncode({'count': count}),
          )
          .timeout(const Duration(seconds: 60));

      final body = response.body.trimLeft();
      if (body.startsWith('<')) {
        throw Exception(
          'Server returned HTML instead of JSON. Please verify the mantra count API URL.',
        );
      }

      final data = body.isNotEmpty
          ? jsonDecode(body) as Map<String, dynamic>
          : <String, dynamic>{};

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      }

      throw Exception(data['message'] ?? 'Unable to save mantra count');
    } on SocketException {
      throw Exception('No internet connection.');
    } on TimeoutException {
      throw Exception('Server timeout, please try again.');
    } on FormatException {
      throw Exception('Invalid mantra count response from server.');
    }
  }

  Future<int> getDraftSessionCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_draftSessionCountKey) ?? 0;
  }

  Future<void> saveDraftSessionCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_draftSessionCountKey, count);
  }

  Future<void> clearDraftSessionCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_draftSessionCountKey);
  }

  Future<NaamJaapStatsResponse> fetchStats() async {
    final token = await UserPersistenceService.getToken();
    final url = Uri.parse('$_baseUrl/mantra/stats');

    try {
      final response = await http
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              if (token != null && token.isNotEmpty)
                'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 60));

      final body = response.body.trimLeft();
      if (body.startsWith('<')) {
        throw Exception(
          'Server returned HTML instead of JSON. Please verify the mantra stats API URL.',
        );
      }

      final data = jsonDecode(body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return NaamJaapStatsResponse.fromJson(data);
      }

      throw Exception(data['message'] ?? 'Unable to fetch mantra stats');
    } on SocketException {
      throw Exception('No internet connection.');
    } on TimeoutException {
      throw Exception('Server timeout, please try again.');
    } on FormatException {
      throw Exception('Invalid mantra stats response from server.');
    }
  }
}
