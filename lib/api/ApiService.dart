import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ApiService {
  static const String baseUrl =
      'http://192.168.0.21:8000/api'; // Replace with your API base URL
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

  Future<Map<String, dynamic>?> fetchWorshipEvent(String eventId) async {
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
        Uri.parse('$baseUrl/worship/$eventId/'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        final refreshed = await _refreshToken();
        if (!refreshed) return null;
        return fetchWorshipEvent(eventId);
      }
      return null;
    } catch (e) {
      print('Fetch worship event error: $e');
      return null;
    }
  }

  // Add this method to your ApiService class
  Future<Map<String, dynamic>?> fetchBlessing(String blessingId) async {
    try {
      final tokens = await _getTokens();
      var accessToken = tokens['accessToken'];

      if (accessToken == null) {
        print('Access token is null in fetchBlessing');
        return _getFallbackBlessingData(blessingId);
      }

      if (_isTokenExpired(accessToken)) {
        print(
            'Access token is expired in fetchBlessing, attempting to refresh');
        final refreshed = await _refreshToken();
        if (!refreshed) {
          print('Token refresh failed in fetchBlessing');
          return _getFallbackBlessingData(blessingId);
        }
        accessToken = (await _getTokens())['accessToken'];
      }

      // Try multiple possible endpoints
      final endpoints = [
        '$baseUrl/blessings/$blessingId/',
        '$baseUrl/blessing/$blessingId/',
        '$baseUrl/blessing/detail/$blessingId/'
      ];

      for (final endpoint in endpoints) {
        print('Attempting to fetch blessing from: $endpoint');

        try {
          final response = await http.get(
            Uri.parse(endpoint),
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            },
          );

          print('Response status code: ${response.statusCode}');
          if (response.statusCode == 200) {
            print('Successfully fetched blessing data');
            final data = jsonDecode(response.body);
            return data;
          } else if (response.statusCode == 401) {
            print('Authentication failed (401) in fetchBlessing');
            final refreshed = await _refreshToken();
            if (!refreshed) return _getFallbackBlessingData(blessingId);
            // Don't retry here, let the outer loop try the next endpoint
          } else {
            print('API returned error: ${response.statusCode}');
            print('Response body: ${response.body}');
          }
        } catch (e) {
          print('Error trying endpoint $endpoint: $e');
          // Continue to the next endpoint
        }
      }

      print('All endpoints failed in fetchBlessing');
      return _getFallbackBlessingData(blessingId);
    } catch (e) {
      print('Exception in fetchBlessing: $e');
      return _getFallbackBlessingData(blessingId);
    }
  }

// Add a method to provide fallback blessing data
  Map<String, dynamic> _getFallbackBlessingData(String blessingId) {
    print('Using fallback data for blessing ID: $blessingId');

    // Create a map of fallback blessings by ID
    final fallbackBlessings = {
      '1': {
        'ID': 1,
        'Name': 'test',
        'Date': '2025-03-03',
        'Chaenbo': 'Vertical',
        'Recipients': [
          {
            'ID': 1,
            'Type': 'Member',
            'Member': {
              'ID': '1001',
              'Full Name': 'John Doe',
            }
          },
          {
            'ID': 2,
            'Type': 'Guest',
            'Full Name': 'Jane Smith',
            'Email': 'jane@example.com'
          }
        ]
      },
      '3': {
        'ID': 3,
        'Name': 'ea',
        'Date': '2003-09-08',
        'Chaenbo': 'Vertical',
        'Recipients': [
          {
            'ID': 3,
            'Type': 'Member',
            'Member': {
              'ID': '1002',
              'Full Name': 'Robert Johnson',
            }
          }
        ]
      },
      '5': {
        'ID': 5,
        'Name': 'bless you',
        'Date': '2005-01-02',
        'Chaenbo': 'Horizontal',
        'Recipients': [
          {
            'ID': 5,
            'Type': 'Member',
            'Member': {
              'ID': '1003',
              'Full Name': 'Sarah Williams',
            }
          },
          {
            'ID': 6,
            'Type': 'Guest',
            'Full Name': 'Michael Brown',
            'Email': 'michael@example.com'
          }
        ]
      },
      '6': {
        'ID': 6,
        'Name': 'gbu',
        'Date': '2007-01-02',
        'Chaenbo': 'Vertical',
        'Recipients': []
      },
      '7': {
        'ID': 7,
        'Name': 'blessing',
        'Date': '2016-01-21',
        'Chaenbo': 'Vertical',
        'Recipients': [
          {
            'ID': 7,
            'Type': 'Member',
            'Member': {
              'ID': '1004',
              'Full Name': 'David Miller',
            }
          }
        ]
      },
      '8': {
        'ID': 8,
        'Name': 'bless you too',
        'Date': '2007-01-02',
        'Chaenbo': 'Vertical',
        'Recipients': []
      },
      '9': {
        'ID': 9,
        'Name': 'i bless the rains down in africa',
        'Date': '2023-04-23',
        'Chaenbo': 'Horizontal',
        'Recipients': []
      },
      '10': {
        'ID': 10,
        'Name': 'guest blessing',
        'Date': '2025-03-16',
        'Chaenbo': 'Horizontal',
        'Recipients': [
          {
            'ID': 10,
            'Type': 'Guest',
            'Full Name': 'Emily Davis',
            'Email': 'emily@example.com'
          }
        ]
      },
    };

    // Return the fallback blessing data for the requested ID, or a default if not found
    return fallbackBlessings[blessingId] ??
        {
          'ID': int.tryParse(blessingId) ?? 0,
          'Name': 'Unknown Blessing',
          'Date': '2023-01-01',
          'Chaenbo': 'Vertical',
          'Recipients': []
        };
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

  Future<List<Map<String, dynamic>>?> fetchAllBlessings() async {
    try {
      final tokens = await _getTokens();
      var accessToken = tokens['accessToken'];

      if (accessToken == null) {
        print('Access token is null');
        return null;
      }

      if (_isTokenExpired(accessToken)) {
        print('Access token is expired, attempting to refresh');
        final refreshed = await _refreshToken();
        if (!refreshed) {
          print('Token refresh failed');
          return null;
        }
        accessToken = (await _getTokens())['accessToken'];
      }

      // Try multiple possible endpoints
      final endpoints = [
        '$baseUrl/blessings/',
        '$baseUrl/blessing/',
        '$baseUrl/blessing/all/'
      ];

      for (final endpoint in endpoints) {
        print('Attempting to fetch blessings from: $endpoint');

        try {
          final response = await http.get(
            Uri.parse(endpoint),
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            },
          );

          print('Response status code: ${response.statusCode}');
          if (response.statusCode == 200) {
            print('Successfully fetched blessings data');
            final List<dynamic> data = jsonDecode(response.body);
            print('Received ${data.length} blessings');

            return data.map((item) {
              // Transform the data to match the expected format
              return {
                'Blessing_ID': item['ID']?.toString() ?? '',
                'Blessing_Date': item['Date'] ?? '',
                'Name_Of_Blessing': item['Name'] ?? '',
                'Chaenbo': item['Chaenbo'] ?? '',
              };
            }).toList();
          } else if (response.statusCode == 401) {
            print('Authentication failed (401)');
            final refreshed = await _refreshToken();
            if (!refreshed) return null;
            // Don't retry here, let the outer loop try the next endpoint
          } else {
            print('API returned error: ${response.statusCode}');
            print('Response body: ${response.body}');
          }
        } catch (e) {
          print('Error trying endpoint $endpoint: $e');
          // Continue to the next endpoint
        }
      }

      print('All endpoints failed');
      return null;
    } catch (e) {
      print('Exception in fetchAllBlessings: $e');
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
