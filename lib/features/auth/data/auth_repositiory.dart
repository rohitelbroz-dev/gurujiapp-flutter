import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:guruji/core/constant/api_constants.dart';
import 'package:guruji/core/services/user_persistence_service.dart';
import '../models/profile_model.dart';

class AuthRepository {
  final String _baseUrl = ApiConstants.baseUrl;

  Future<Map<String, dynamic>> sendOtp(String phone) async {
    final url = Uri.parse('$_baseUrl/auth/send-otp');
    try {
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'phone': phone}),
          )
          .timeout(const Duration(seconds: 60));

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200 && data['success'] == true) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Something went wrong');
      }
    } on SocketException {
      throw Exception('No internet connection.');
    } on TimeoutException {
      throw Exception('Server timeout, please try again.');
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    final url = Uri.parse('$_baseUrl/auth/verify-otp');
    try {
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'phone': phone, 'otp': otp}),
          )
          .timeout(const Duration(seconds: 60));

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200 && data['token'] != null) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Invalid OTP');
      }
    } on SocketException {
      throw Exception('No internet connection.');
    } on TimeoutException {
      throw Exception('Server timeout, please try again.');
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String phone,
    required String email,
    required String city,
    required String state,
    required String dateOfBirth,
    required String gotra,
  }) async {
    final url = Uri.parse('$_baseUrl/auth/register');
    try {
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'name': name,
              'phone': phone,
              'email': email,
              'city': city,
              'state': state,
              'dateOfBirth': dateOfBirth,
              'gotra': gotra,
            }),
          )
          .timeout(const Duration(seconds: 60));

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['success'] == true ||
            data['message']?.toString().contains('successfully') == true) {
          return data;
        }
      }

      throw Exception(data['message'] ?? 'Registration failed');
    } on SocketException {
      throw Exception('No internet connection.');
    } on TimeoutException {
      throw Exception('Server timeout, please try again.');
    }
  }

  Future<Profile> getProfile() async {
    final token = await UserPersistenceService.getToken();
    if (token == null) {
      throw Exception('No authentication token found. Please login again.');
    }

    final url = Uri.parse('$_baseUrl/user/profile');
    try {
      final response = await http
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 60));

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return Profile.fromJson(data);
      }
      throw Exception(data['message'] ?? 'Unable to fetch profile');
    } on SocketException {
      throw Exception('No internet connection.');
    } on TimeoutException {
      throw Exception('Server timeout, please try again.');
    }
  }

  Future<Profile> updateProfile({
    String? name,
    String? phone,
    String? email,
    String? city,
    String? state,
    String? dateOfBirth,
    String? gotra,
    bool? muhuratAlerts,
    bool? prayerReminders,
    File? profileImageFile,
  }) async {
    final token = await UserPersistenceService.getToken();
    if (token == null) {
      throw Exception('No authentication token found. Please login again.');
    }

    final url = Uri.parse('$_baseUrl/user/profile');

    if (profileImageFile == null) {
      // Send clean JSON payload
      final Map<String, dynamic> body = {};
      if (name != null && name.isNotEmpty) body['name'] = name;
      if (phone != null && phone.isNotEmpty) body['phone'] = phone;
      if (email != null && email.isNotEmpty) body['email'] = email;
      if (city != null && city.isNotEmpty) body['city'] = city;
      if (state != null && state.isNotEmpty) body['state'] = state;
      if (dateOfBirth != null && dateOfBirth.isNotEmpty) body['dateOfBirth'] = dateOfBirth;
      if (gotra != null && gotra.isNotEmpty) body['gotra'] = gotra;
      if (muhuratAlerts != null) body['muhuratAlerts'] = muhuratAlerts;
      if (prayerReminders != null) body['prayerReminders'] = prayerReminders;

      try {
        final response = await http
            .put(
              url,
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $token',
              },
              body: jsonEncode(body),
            )
            .timeout(const Duration(seconds: 60));

        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (response.statusCode == 200) {
          return Profile.fromJson(data);
        }
        throw Exception(data['message'] ?? 'Unable to update profile');
      } on SocketException {
        throw Exception('No internet connection.');
      } on TimeoutException {
        throw Exception('Server timeout, please try again.');
      }
    }

    // Multipart request when image file is present
    final request = http.MultipartRequest('PUT', url)
      ..headers['Accept'] = 'application/json'
      ..headers['Authorization'] = 'Bearer $token';

    if (name != null && name.isNotEmpty) request.fields['name'] = name;
    if (phone != null && phone.isNotEmpty) request.fields['phone'] = phone;
    if (email != null && email.isNotEmpty) request.fields['email'] = email;
    if (city != null && city.isNotEmpty) request.fields['city'] = city;
    if (state != null && state.isNotEmpty) request.fields['state'] = state;
    if (dateOfBirth != null && dateOfBirth.isNotEmpty) request.fields['dateOfBirth'] = dateOfBirth;
    if (gotra != null && gotra.isNotEmpty) request.fields['gotra'] = gotra;
    if (muhuratAlerts != null) request.fields['muhuratAlerts'] = muhuratAlerts.toString();
    if (prayerReminders != null) request.fields['prayerReminders'] = prayerReminders.toString();

    final fileName = profileImageFile.uri.pathSegments.last;
    final lowerName = fileName.toLowerCase();
    final mimeType = lowerName.endsWith('.png')
        ? 'image/png'
        : lowerName.endsWith('.gif')
        ? 'image/gif'
        : 'image/jpeg';
    final splitMime = mimeType.split('/');

    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        profileImageFile.path,
        filename: fileName,
        contentType: MediaType(splitMime[0], splitMime[1]),
      ),
    );

    try {
      final responseStream = await request.send().timeout(
        const Duration(seconds: 60),
      );
      final response = await http.Response.fromStream(responseStream);
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return Profile.fromJson(data);
      }
      throw Exception(data['message'] ?? 'Unable to update profile');
    } on SocketException {
      throw Exception('No internet connection.');
    } on TimeoutException {
      throw Exception('Server timeout, please try again.');
    }
  }

  Future<void> logout() async {
    final token = await UserPersistenceService.getToken();
    if (token == null) {
      throw Exception('No authentication token found.');
    }

    final url = Uri.parse('$_baseUrl/auth/logout');
    try {
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 60));

      if (response.statusCode != 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>?;
        throw Exception(data?['message'] ?? 'Unable to logout');
      }
    } on SocketException {
      throw Exception('No internet connection.');
    } on TimeoutException {
      throw Exception('Server timeout, please try again.');
    }
  }

  Future<void> deleteAccount() async {
    final token = await UserPersistenceService.getToken();
    if (token == null) {
      throw Exception('No authentication token found.');
    }

    final url = Uri.parse('$_baseUrl/user/account');
    try {
      final response = await http
          .delete(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 60));

      if (response.statusCode != 200 && response.statusCode != 204) {
        final data = jsonDecode(response.body) as Map<String, dynamic>?;
        throw Exception(data?['message'] ?? 'Unable to delete account');
      }
    } on SocketException {
      throw Exception('No internet connection.');
    } on TimeoutException {
      throw Exception('Server timeout, please try again.');
    }
  }
}
