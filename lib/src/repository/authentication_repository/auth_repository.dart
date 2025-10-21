import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/constants/external_endpoints.dart';
import 'package:expense_tracker/src/features/authentication/models/user.dart';
import 'package:expense_tracker/src/repository/preferences/user_preferences.dart';
import 'package:http/http.dart' as http;

class AuthRepository extends ChangeNotifier {
  static AuthRepository get instance => Get.find();

  // Check email availability
  Future<Map<String, dynamic>> checkEmailAvailability(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$tBaseUrl/users/check-availability?email=${Uri.encodeComponent(email)}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'status': true,
          'data': responseData['email']
        };
      } else {
        return {
          'status': false,
          'message': 'Failed to check email availability',
        };
      }
    } catch (error) {
      return {
        'status': false,
        'message': 'Network error occurred',
        'data': error.toString()
      };
    }
  }

  // Send verification code to email
  Future<Map<String, dynamic>> sendVerificationCode(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$tBaseUrl/users/send-verification-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'status': true,
          'message': responseData['message'],
          'expires_in_minutes': responseData['expires_in_minutes']
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'status': false,
          'message': errorData['detail'] ?? 'Failed to send verification code',
        };
      }
    } catch (error) {
      return {
        'status': false,
        'message': 'Network error occurred',
        'data': error.toString()
      };
    }
  }

  // Verify email code
  Future<Map<String, dynamic>> verifyEmailCode(String email, String code) async {
    try {
      final response = await http.post(
        Uri.parse('$tBaseUrl/users/verify-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'code': code,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'status': true,
          'message': responseData['message'],
          'verification_token': responseData['verification_token']
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'status': false,
          'message': errorData['detail'] ?? 'Invalid verification code',
        };
      }
    } catch (error) {
      return {
        'status': false,
        'message': 'Network error occurred',
        'data': error.toString()
      };
    }
  }

  // Resend verification code
  Future<Map<String, dynamic>> resendVerificationCode(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$tBaseUrl/users/resend-verification-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'status': true,
          'message': responseData['message'],
          'expires_in_minutes': responseData['expires_in_minutes']
        };
      } else if (response.statusCode == 429) {
        final errorData = jsonDecode(response.body);
        final retryAfter = response.headers['retry-after'];
        return {
          'status': false,
          'message': errorData['detail'] ?? 'Too many attempts',
          'retry_after': retryAfter
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'status': false,
          'message': errorData['detail'] ?? 'Failed to resend code',
        };
      }
    } catch (error) {
      return {
        'status': false,
        'message': 'Network error occurred',
        'data': error.toString()
      };
    }
  }

  // Complete registration
  Future<Map<String, dynamic>> completeRegistration({
    required String verificationToken,
    required String username,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$tBaseUrl/users/complete-registration'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'verification_token': verificationToken,
          'username': username,
          'password': password,
          'first_name': firstName,
          'last_name': lastName,
        }),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return {
          'status': true,
          'message': 'Registration completed successfully',
          'data': responseData
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'status': false,
          'message': errorData['detail'] ?? 'Registration failed',
        };
      }
    } catch (error) {
      return {
        'status': false,
        'message': 'Network error occurred',
        'data': error.toString()
      };
    }
  }

  Future<Map<String, dynamic>> loginUser(String username, String password) async {
    notifyListeners();

    try {
      // Using JSON for cleaner API calls
      final response = await http.post(
        Uri.parse(tLoginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'grant_type': 'password',
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Save tokens from Spendlee API response
        await UserPreferences().saveAccessToken(responseData['access_token']);
        await UserPreferences().saveRefreshToken(responseData['refresh_token']);

        // Get user profile after successful login
        final userProfile = await getCurrentUserProfile(responseData['access_token']);

        if (userProfile['status']) {
          await UserPreferences().saveUser(User.fromSpendleeJson(userProfile['data']));

          return {
            'status': true,
            'message': 'Successfully Logged In',
            'data': userProfile['data']
          };
        } else {
          return userProfile;
        }
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'status': false,
          'message': 'Login failed',
          'data': errorData['detail'] ?? 'Invalid credentials'
        };
      }
    } catch (error) {
      return {
        'status': false,
        'message': 'Network error occurred',
        'data': error.toString()
      };
    }
  }

  // ADD THIS METHOD - Google Login
  Future<Map<String, dynamic>> loginWithGoogle({
    required String email,
    required String firstName,
    required String lastName,
    required String googleId,
  }) async {
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(tGoogleLoginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'first_name': firstName,
          'last_name': lastName,
          'google_id': googleId,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        print(response.body);
        // Save tokens from Google login response
        await UserPreferences().saveAccessToken(responseData['access_token']);
        await UserPreferences().saveRefreshToken(responseData['refresh_token']);

        // Get user profile after successful login
        final userProfile = await getCurrentUserProfile(responseData['access_token']);

        if (userProfile['status']) {
          await UserPreferences().saveUser(User.fromSpendleeJson(userProfile['data']));

          return {
            'status': true,
            'message': 'Google login successful',
            'data': userProfile['data']
          };
        } else {
          return userProfile;
        }
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'status': false,
          'message': 'Google login failed',
          'data': errorData['detail'] ?? 'Google authentication failed'
        };
      }
    } catch (error) {
      return {
        'status': false,
        'message': 'Network error during Google login',
        'data': error.toString()
      };
    }
  }


  Future<Map<String, dynamic>> setDefaultCurrency(String currencyCode, String accessToken) async {
    try {
      final response = await http.post(
        Uri.parse(tCurrencyUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'default_currency': currencyCode
        }),
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        //update currency
        return {
          'status': true,
          'message': 'Currency Successfully Set',
          'data': userData
        };
      } else {
        return {
          'status': false,
          'message': 'Failed to get user profile',
          'data': null
        };
      }
    } catch (error) {
      return {
        'status': false,
        'message': 'Error getting user profile',
        'data': error.toString()
      };
    }
  }

  Future<Map<String, dynamic>> getCurrentUserProfile(String accessToken) async {
    try {
      final response = await http.get(
        Uri.parse(tUserProfileUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        return {
          'status': true,
          'message': 'User profile retrieved',
          'data': userData
        };
      } else {
        return {
          'status': false,
          'message': 'Failed to get user profile',
          'data': null
        };
      }
    } catch (error) {
      return {
        'status': false,
        'message': 'Error getting user profile',
        'data': error.toString()
      };
    }
  }

  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      final response = await http.post(
        Uri.parse('$tRefreshTokenUrl?refresh_token=$refreshToken'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Save new tokens
        await UserPreferences().saveAccessToken(responseData['access_token']);
        await UserPreferences().saveRefreshToken(responseData['refresh_token']);

        return {
          'status': true,
          'message': 'Token refreshed successfully',
          'data': responseData
        };
      } else {
        return {
          'status': false,
          'message': 'Token refresh failed',
          'data': null
        };
      }
    } catch (error) {
      return {
        'status': false,
        'message': 'Token refresh error',
        'data': error.toString()
      };
    }
  }

  Future<Map<String, dynamic>> registerUser({
    required String email,
    required String username,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(tRegisterUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'username': username,
          'password': password,
          'first_name': firstName,
          'last_name': lastName,
        }),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return {
          'status': true,
          'message': 'User registered successfully',
          'data': responseData
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'status': false,
          'message': 'Registration failed',
          'data': errorData['detail'] ?? 'Registration error'
        };
      }
    } catch (error) {
      return {
        'status': false,
        'message': 'Registration error',
        'data': error.toString()
      };
    }
  }

  Future<void> logout() async {
    final accessToken = await UserPreferences().getAccessToken();

    if (accessToken != null) {
      try {
        await http.post(
          Uri.parse(tLogoutUrl),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        );
      } catch (e) {
        // Continue with local logout even if API call fails
        print('Logout API call failed: $e');
      }
    }

    // Clear local storage
    await UserPreferences().clearAll();
  }
}