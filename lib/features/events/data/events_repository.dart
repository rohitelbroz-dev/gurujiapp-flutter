import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:guruji/features/events/models/event_model.dart';

class EventsRepository {
  final String _baseUrl = 'https://gurujiappbackend.onrender.com/api';

  Future<EventsResponse> fetchEvents({
    int page = 1,
    int limit = 10,
  }) async {
    final url = Uri.parse('$_baseUrl/events?page=$page&limit=$limit');
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

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return EventsResponse.fromJson(data);
      }
      throw Exception(data['message'] ?? 'Unable to fetch events');
    } on SocketException {
      throw Exception('No internet connection.');
    } on TimeoutException {
      throw Exception('Server timeout, please try again.');
    }
  }
}
