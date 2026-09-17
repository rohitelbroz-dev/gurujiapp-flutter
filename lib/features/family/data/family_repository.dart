import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:guruji/core/constant/api_constants.dart';
import 'package:guruji/core/services/user_persistence_service.dart';
import 'package:guruji/features/family/models/family_member.dart';
import 'package:http/http.dart' as http;

class FamilyRepository {
  final String _baseUrl = ApiConstants.baseUrl;

  Future<FamilyMember> fetchFamilyTree() async {
    final token = await UserPersistenceService.getToken();
    final url = Uri.parse('$_baseUrl/family/tree');

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
          'Server returned HTML instead of JSON. Please verify the family API URL.',
        );
      }

      final data = jsonDecode(body);
      if (response.statusCode == 200) {
        if (data is Map<String, dynamic>) {
          final treeData = data['data'] is Map<String, dynamic>
              ? data['data'] as Map<String, dynamic>
              : data;
          return FamilyMember.fromJson(treeData);
        }
        throw Exception('Invalid family response from server.');
      }

      if (data is Map<String, dynamic>) {
        throw Exception(data['message'] ?? 'Unable to fetch family tree');
      }

      throw Exception('Unable to fetch family tree');
    } on SocketException {
      throw Exception('No internet connection.');
    } on TimeoutException {
      throw Exception('Server timeout, please try again.');
    } on FormatException {
      throw Exception('Invalid family response from server.');
    }
  }
}
