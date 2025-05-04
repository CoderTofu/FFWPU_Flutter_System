import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ApiService {
  static const String baseUrl =
      'http://192.168.1.11:8000/api'; // Replace with your API base URL
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';

  // Store both tokens
  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(accessTokenKey, accessToken);
    await prefs.setString(refreshTokenKey, refreshToken);
  }

  // Get both tokens
  Future<Map<String, String?>> _getTokens() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'accessToken': prefs.getString(accessTokenKey),
      'refreshToken': prefs.getString(refreshTokenKey),
    };
  }

  // Check if token is expired using jwt_decoder
  bool _isTokenExpired(String token) {
    try {
      final decodedToken = JwtDecoder.decode(token);
      final expirationDate =
          DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000);
      return DateTime.now().isAfter(expirationDate);
    } catch (e) {
      return true;
    }
  }

  // Refresh token
  Future<bool> _refreshToken() async {
    try {
      final tokens = await _getTokens();
      final refreshToken = tokens['refreshToken'];

      if (refreshToken == null) {
        await logout();
        return false;
      }

      if (_isTokenExpired(refreshToken)) {
        await logout();
        return false;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/refresh-token/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveTokens(data['access'], refreshToken);
        return true;
      }

      await logout();
      return false;
    } catch (e) {
      print('Token refresh error: $e');
      await logout();
      return false;
    }
  }

  // Modified login method to handle both tokens
  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveTokens(data['access'], data['refresh']);
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  // Modified method to handle token refresh
  Future<Map<String, dynamic>?> fetchMemberData(String memberId) async {
    try {
      final tokens = await _getTokens();
      var accessToken = tokens['accessToken'];

      if (accessToken == null) {
        return null;
      }

      // Check if access token is expired
      if (_isTokenExpired(accessToken)) {
        // Try to refresh the token
        final refreshed = await _refreshToken();
        if (!refreshed) {
          return null;
        }
        // Get new access token after refresh
        accessToken = (await _getTokens())['accessToken'];
      }

      final response = await http.get(
        Uri.parse('$baseUrl/member/$memberId/'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        // Token might have expired between check and request
        final refreshed = await _refreshToken();
        if (!refreshed) {
          return null;
        }
        // Retry the request with new token
        return fetchMemberData(memberId);
      }
      return null;
    } catch (e) {
      print('Fetch member error: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> fetchAllMembers() async {
    try {
      final tokens = await _getTokens();
      var accessToken = tokens['accessToken'];

      if (accessToken == null) {
        return null;
      }

      if (_isTokenExpired(accessToken)) {
        final refreshed = await _refreshToken();
        if (!refreshed) return null;
        accessToken = (await _getTokens())['accessToken'];
      }

      final response = await http.get(
        Uri.parse('$baseUrl/member/'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else if (response.statusCode == 401) {
        final refreshed = await _refreshToken();
        if (!refreshed) return null;
        return fetchAllMembers();
      }
      return null;
    } catch (e) {
      print('Fetch all members error: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> fetchWorshipEvents() async {
    try {
      final tokens = await _getTokens();
      var accessToken = tokens['accessToken'];

      if (accessToken == null) return null;

      if (_isTokenExpired(accessToken)) {
        final refreshed = await _refreshToken();
        if (!refreshed) return null;
        accessToken = (await _getTokens())['accessToken'];
      }

      final response = await http.get(
        Uri.parse('$baseUrl/worship/'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) {
          var transformed = Map<String, dynamic>.from(item);
          transformed['Church'] = item['Church']['Name'];
          return transformed;
        }).toList();
      } else if (response.statusCode == 401) {
        final refreshed = await _refreshToken();
        if (!refreshed) return null;
        return fetchWorshipEvents();
      }
      return null;
    } catch (e) {
      print('Fetch worship events error: $e');
      return null;
    }
  }

  // Modified logout to clear both tokens
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(accessTokenKey);
    await prefs.remove(refreshTokenKey);
  }
}
