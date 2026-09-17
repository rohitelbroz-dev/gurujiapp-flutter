import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:guruji/core/constant/api_constants.dart';
import 'package:guruji/features/videos/models/video_model.dart';
import 'package:guruji/core/services/user_persistence_service.dart';

class VideosRepository {
  final String _baseUrl = ApiConstants.baseUrl;
  Future<VideosResponse> fetchVideos({
    int page = 1,
    int limit = 10,
    String type = 'regular',
  }) async {
    final token = await UserPersistenceService.getToken();
    final url = Uri.parse(
      '$_baseUrl/videos?page=$page&limit=$limit&type=$type',
    );

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
          'Server returned HTML instead of JSON. Please verify the videos API URL.',
        );
      }

      final data = jsonDecode(body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return VideosResponse.fromJson(data);
      }

      throw Exception(data['message'] ?? 'Unable to fetch videos');
    } on SocketException {
      throw Exception('No internet connection.');
    } on TimeoutException {
      throw Exception('Server timeout, please try again.');
    } on FormatException {
      throw Exception('Invalid videos response from server.');
    }
  }
}
