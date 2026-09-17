import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:guruji/core/constant/api_constants.dart';
import 'package:guruji/features/amrit_vachan/models/amrit_vachan_model.dart';
import 'package:http/http.dart' as http;

class AmritVachanRepository {
  final String _baseUrl = ApiConstants.baseUrl;

  Future<List<AmritVachan>> fetchAllPosts() async {
    return _fetchList('$_baseUrl/daily-vachan');
  }

  Future<List<AmritVachan>> fetchTodayPosts() async {
    return _fetchList('$_baseUrl/daily-vachan/today');
  }

  Future<List<AmritVachan>> _fetchList(String url) async {
    try {
      final response = await http
          .get(
            Uri.parse(url),
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 60));

      final body = jsonDecode(response.body);
      if (response.statusCode == 200 && body is List) {
        return body
            .map((item) => AmritVachan.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      throw Exception('Unable to fetch Amrit Vachan data');
    } on SocketException {
      throw Exception('No internet connection.');
    } on TimeoutException {
      throw Exception('Server timeout, please try again.');
    }
  }
}
