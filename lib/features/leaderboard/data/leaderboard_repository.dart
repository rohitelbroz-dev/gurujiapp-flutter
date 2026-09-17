import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:guruji/core/constant/api_constants.dart';
import 'package:guruji/core/services/user_persistence_service.dart';
import 'package:guruji/features/leaderboard/models/leaderboard_model.dart';
import 'package:http/http.dart' as http;

class LeaderboardRepository {
  final String _baseUrl = ApiConstants.baseUrl;

  Future<LeaderboardResponse> fetchLeaderboard() async {
    final token = await UserPersistenceService.getToken();
    final url = Uri.parse('$_baseUrl/mantra/leaderboard');

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
          'Server returned HTML instead of JSON. Please verify the leaderboard API URL.',
        );
      }

      final data = jsonDecode(body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return LeaderboardResponse.fromJson(data);
      }

      throw Exception(data['message'] ?? 'Unable to fetch leaderboard');
    } on SocketException {
      throw Exception('No internet connection.');
    } on TimeoutException {
      throw Exception('Server timeout, please try again.');
    } on FormatException {
      throw Exception('Invalid leaderboard response from server.');
    }
  }
}
