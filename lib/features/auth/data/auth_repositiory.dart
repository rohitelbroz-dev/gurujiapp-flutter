import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:guruji/core/constant/api_constants.dart';
import 'package:guruji/core/services/user_persistence_service.dart';
import 'package:guruji/features/auth/models/profile_model.dart';

class AuthRepository {
  final String _baseUrl = ApiConstants.baseUrl;
  Future<Map<String, dynamic>> sendOtp(String phone) async {
    final url = Uri.parse('$_baseUrl/auth/request-otp');
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
        print('OTP sent successfully: ${data['otpCode']}');
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
      print('Register API Response: $data');
      print('Status Code: ${response.statusCode}');

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
    required String name,
    required String phone,
    required String email,
    required String city,
    required String state,
    required String dateOfBirth,
    required String gotra,
    File? profileImageFile,
  }) async {
    final token = await UserPersistenceService.getToken();
    if (token == null) {
      throw Exception('No authentication token found. Please login again.');
    }

    final url = Uri.parse('$_baseUrl/user/profile');
    final request = http.MultipartRequest('PUT', url)
      ..headers['Accept'] = 'application/json'
      ..headers['Authorization'] = 'Bearer $token';

    if (name.isNotEmpty) request.fields['name'] = name;
    if (phone.isNotEmpty) request.fields['phone'] = phone;
    if (email.isNotEmpty) request.fields['email'] = email;
    if (city.isNotEmpty) request.fields['city'] = city;
    if (state.isNotEmpty) request.fields['state'] = state;
    if (dateOfBirth.isNotEmpty) request.fields['dateOfBirth'] = dateOfBirth;
    if (gotra.isNotEmpty) request.fields['gotra'] = gotra;

    if (profileImageFile != null) {
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
    }

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
}
