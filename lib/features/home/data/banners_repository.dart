import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:guruji/core/constant/api_constants.dart';

class BannersRepository {
  final String _baseUrl = ApiConstants.baseUrl;

  Future<List<String>> fetchBanners() async {
    final url = Uri.parse('$_baseUrl/banners');

    try {
      final response = await http
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 60));

      final body = response.body.trimLeft();
      if (body.startsWith('<')) {
        throw Exception(
          'Server returned HTML instead of JSON. Please verify the banners API URL.',
        );
      }

      final data = jsonDecode(body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        final banners = data['banners'] as List<dynamic>? ?? const [];
        return banners.map((item) => item.toString()).toList();
      }

      throw Exception(data['message'] ?? 'Unable to fetch banners');
    } on SocketException {
      throw Exception('No internet connection.');
    } on TimeoutException {
      throw Exception('Server timeout, please try again.');
    } on FormatException {
      throw Exception('Invalid banners response from server.');
    }
  }
}
