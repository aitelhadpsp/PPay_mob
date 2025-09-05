import 'dart:convert';
import 'dart:io';
import 'package:denta_incomes/models/api_response_dto.dart';
import 'package:denta_incomes/models/auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Custom exceptions
class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class UnauthorizedException extends ApiException {
  UnauthorizedException() : super('Unauthorized', 401);
}

class NetworkException extends ApiException {
  NetworkException(String message) : super('Network error: $message', 0);
}

// Unified API Client
class ApiClient {
  static const String baseUrl =  'https://dinc.maachaba.com/api';
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userKey = 'user_data';

  static const Duration _timeout = Duration(seconds: 30);
  static bool _isRefreshing = false;
  static final List<Function()> _refreshCallbacks = [];

  // Generic GET request
  static Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? queryParams,
    T Function(dynamic)? fromJson,
    bool requiresAuth = true,
  }) async {
    return _makeRequest<T>(
      'GET',
      endpoint,
      queryParams: queryParams,
      fromJson: fromJson,
      requiresAuth: requiresAuth,
    );
  }

  // Generic POST request
  static Future<ApiResponse<T>> post<T>(
    String endpoint, {
    dynamic body,
    Map<String, String>? queryParams,
    T Function(dynamic)? fromJson,
    bool requiresAuth = true,
  }) async {
    return _makeRequest<T>(
      'POST',
      endpoint,
      body: body,
      queryParams: queryParams,
      fromJson: fromJson,
      requiresAuth: requiresAuth,
    );
  }

  // Generic PUT request
  static Future<ApiResponse<T>> put<T>(
    String endpoint, {
    dynamic body,
    Map<String, String>? queryParams,
    T Function(dynamic)? fromJson,
    bool requiresAuth = true,
  }) async {
    return _makeRequest<T>(
      'PUT',
      endpoint,
      body: body,
      queryParams: queryParams,
      fromJson: fromJson,
      requiresAuth: requiresAuth,
    );
  }

  // Generic PATCH request
  static Future<ApiResponse<T>> patch<T>(
    String endpoint, {
    dynamic body,
    Map<String, String>? queryParams,
    T Function(dynamic)? fromJson,
    bool requiresAuth = true,
  }) async {
    return _makeRequest<T>(
      'PATCH',
      endpoint,
      body: body,
      queryParams: queryParams,
      fromJson: fromJson,
      requiresAuth: requiresAuth,
    );
  }

  // Generic DELETE request
  static Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    Map<String, String>? queryParams,
    T Function(dynamic)? fromJson,
    bool requiresAuth = true,
  }) async {
    return _makeRequest<T>(
      'DELETE',
      endpoint,
      queryParams: queryParams,
      fromJson: fromJson,
      requiresAuth: requiresAuth,
    );
  }

  // Core request method
  static Future<ApiResponse<T>> _makeRequest<T>(
    String method,
    String endpoint, {
    dynamic body,
    Map<String, String>? queryParams,
    T Function(dynamic)? fromJson,
    bool requiresAuth = true,
    bool isRetry = false,
  }) async {
    try {
      // Build URI
      final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParams);

      // Prepare headers
      final headers = await _buildHeaders(requiresAuth);

      // Make HTTP request
      final request = http.Request(method, uri);
      request.headers.addAll(headers);

      if (body != null) {
        if (body is String) {
          request.body = body;
        } else if (body is Map) {
          request.body = jsonEncode(body);
        } else {
          request.body = jsonEncode(body);
        }
      }

      final streamedResponse = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);

      // Handle response
      return await _handleResponse<T>(
        response,
        fromJson,
        () => _makeRequest<T>(
          method,
          endpoint,
          body: body,
          queryParams: queryParams,
          fromJson: fromJson,
          requiresAuth: requiresAuth,
          isRetry: true,
        ),
        isRetry,
      );
    } on SocketException catch (e) {
      return _createErrorResponse<T>('No internet connection: ${e.message}', 0);
    } on HttpException catch (e) {
      return _createErrorResponse<T>('HTTP error: ${e.message}', 0);
    } on FormatException catch (e) {
      return _createErrorResponse<T>('Invalid response format: ${e.message}', 0);
    } catch (e) {
      return _createErrorResponse<T>('Unexpected error: ${e.toString()}', 0);
    }
  }

  // Build request headers
  static Future<Map<String, String>> _buildHeaders(bool requiresAuth) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      final token = await getAccessToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // Handle HTTP response
  static Future<ApiResponse<T>> _handleResponse<T>(
    http.Response response,
    T Function(dynamic)? fromJson,
    Future<ApiResponse<T>> Function() retryRequest,
    bool isRetry,
  ) async {
    final statusCode = response.statusCode;

    switch (statusCode) {
      case 200:
      case 201:
        return _parseSuccessResponse<T>(response, fromJson);

      case 204:
        return ApiResponse<T>(success: true, statusCode: 204, message: "");

      case 400:
        return _parseErrorResponse<T>(response, 'Bad request');

      case 401:
        if (!isRetry) {
          final refreshed = await _refreshTokenIfNeeded();
          if (refreshed) {
            return await retryRequest();
          }
        }
        return _parseErrorResponse<T>(response, 'Unauthorized');

      case 403:
        return _parseErrorResponse<T>(response, 'Forbidden');

      case 404:
        return _parseErrorResponse<T>(response, 'Not found');

      case 409:
        return _parseErrorResponse<T>(response, 'Conflict');

      case 422:
        return _parseErrorResponse<T>(response, 'Validation error');

      case 500:
        return _parseErrorResponse<T>(response, 'Internal server error');

      case 502:
        return _createErrorResponse<T>('Bad gateway', 502);

      case 503:
        return _createErrorResponse<T>('Service unavailable', 503);

      default:
        return _parseErrorResponse<T>(response, 'Request failed');
    }
  }

  // ------------------- $values Handling -------------------
  static dynamic _unwrapDotNetValues(dynamic json) {
    if (json is Map<String, dynamic>) {
      if (json.containsKey(r'$values')) {
        return (json[r'$values'] as List).map(_unwrapDotNetValues).toList();
      } else {
        return json.map((key, value) => MapEntry(key, _unwrapDotNetValues(value)));
      }
    } else if (json is List) {
      return json.map(_unwrapDotNetValues).toList();
    } else {
      return json;
    }
  }

  static ApiResponse<T> _parseSuccessResponse<T>(
    http.Response response,
    T Function(dynamic)? fromJson,
  ) {
    try {
      if (response.body.isEmpty) {
        return ApiResponse<T>(
          success: true,
          statusCode: response.statusCode,
          message: "",
        );
      }

      final jsonData = jsonDecode(response.body);
      final normalizedData = _unwrapDotNetValues(jsonData);

      if (fromJson != null) {
        if (normalizedData is Map<String, dynamic>) {
          if (normalizedData.containsKey('data')) {
            final dataValue = _unwrapDotNetValues(normalizedData['data']);

            if (dataValue != null) {
              try {
                final data = fromJson(dataValue);
                return ApiResponse<T>.fromJson(normalizedData, (_) => data);
              } catch (e) {
                print('fromJson error: $e');
                return _createErrorResponse<T>(
                  'Failed to parse response data: ${e.toString()}',
                  response.statusCode,
                );
              }
            } else {
              return ApiResponse<T>.fromJson(normalizedData, fromJson);
            }
          } else {
            try {
              final data = fromJson(normalizedData);
              return ApiResponse<T>(
                success: true,
                statusCode: response.statusCode,
                message: normalizedData['message'] as String? ?? '',
                data: data,
              );
            } catch (e) {
              print('Direct object parsing error: $e');
              return _createErrorResponse<T>(
                'Failed to parse response: ${e.toString()}',
                response.statusCode,
              );
            }
          }
        } else if (normalizedData is List) {
          try {
            final data = fromJson(normalizedData);
            return ApiResponse<T>(
              success: true,
              statusCode: response.statusCode,
              message: '',
              data: data,
            );
          } catch (e) {
            print('List parsing error: $e');
            return _createErrorResponse<T>(
              'Failed to parse list response: ${e.toString()}',
              response.statusCode,
            );
          }
        } else {
          try {
            final data = fromJson(normalizedData);
            return ApiResponse<T>(
              success: true,
              statusCode: response.statusCode,
              message: '',
              data: data,
            );
          } catch (e) {
            print('Primitive parsing error: $e');
            return _createErrorResponse<T>(
              'Failed to parse primitive response: ${e.toString()}',
              response.statusCode,
            );
          }
        }
      }

      if (normalizedData is Map<String, dynamic>) {
        return ApiResponse<T>.fromJson(normalizedData, fromJson);
      } else {
        return ApiResponse<T>(
          success: true,
          statusCode: response.statusCode,
          message: '',
          data: normalizedData as T?,
        );
      }
    } catch (e) {
      print('General parsing error: $e');
      return _createErrorResponse<T>(
        'Failed to parse response: ${e.toString()}',
        response.statusCode,
      );
    }
  }

  static ApiResponse<T> _parseErrorResponse<T>(
    http.Response response,
    String defaultMessage,
  ) {
    try {
      if (response.body.isEmpty) {
        return _createErrorResponse<T>(defaultMessage, response.statusCode);
      }

      final jsonData = jsonDecode(response.body);
      return ApiResponse<T>.fromJson(jsonData, null);
    } catch (e) {
      return _createErrorResponse<T>(defaultMessage, response.statusCode);
    }
  }

  static ApiResponse<T> _createErrorResponse<T>(String message, int statusCode) {
    return ApiResponse<T>(
      success: false,
      message: message,
      statusCode: statusCode,
    );
  }

  // ------------------- Token refresh logic -------------------
  static Future<bool> _refreshTokenIfNeeded() async {
    if (_isRefreshing) {
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        return _isRefreshing;
      });
      return await getAccessToken() != null;
    }

    _isRefreshing = true;
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        await _clearTokens();
        return false;
      }

      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/refresh-token'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'refreshToken': refreshToken}),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final apiResponse = ApiResponse<LoginResponseDto>.fromJson(
          responseData,
          (data) => LoginResponseDto.fromJson(data),
        );

        if (apiResponse.success && apiResponse.data != null) {
          await _storeTokens(apiResponse.data!);
          return true;
        }
      }

      await _clearTokens();
      return false;
    } catch (e) {
      await _clearTokens();
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  // ------------------- Token management -------------------
  static Future<void> _storeTokens(LoginResponseDto loginResponse) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, loginResponse.accessToken);
    await prefs.setString(_refreshTokenKey, loginResponse.refreshToken);
    await prefs.setString(_userKey, jsonEncode(loginResponse.user.toJson()));
  }

  static Future<void> _clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userKey);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  static Future<UserDto?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userKey);
    if (userData != null) {
      try {
        return UserDto.fromJson(jsonDecode(userData));
      } catch (e) {
        await prefs.remove(_userKey);
        return null;
      }
    }
    return null;
  }

  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // ------------------- Specialized auth -------------------
  static Future<ApiResponse<LoginResponseDto>> login(LoginDto loginDto) async {
    var respo = await post<LoginResponseDto>(
      '/auth/login',
      body: loginDto.toJson(),
      fromJson: (data) => LoginResponseDto.fromJson(data),
      requiresAuth: false,
    );
    if (respo.success) {
      _storeTokens(respo.data!);
    }
    return respo;
  }

  static Future<ApiResponse<bool>> logout() async {
    final refreshToken = await getRefreshToken();
    final result = await post<bool>(
      '/auth/logout',
      body: {'refreshToken': refreshToken},
      fromJson: (data) => data is bool ? data : (data == true || data == 'true'),
    );

    await _clearTokens();
    return result;
  }

  static Future<ApiResponse<bool>> changePassword(ChangePasswordDto dto) async {
    return post<bool>(
      '/auth/change-password',
      body: dto.toJson(),
      fromJson: (data) => data is bool ? data : (data == true || data == 'true'),
    );
  }

  static Future<ApiResponse<bool>> forgotPassword(String email) async {
    return post<bool>(
      '/auth/forgot-password',
      body: {'email': email},
      fromJson: (data) => data is bool ? data : (data == true || data == 'true'),
      requiresAuth: false,
    );
  }

  static Future<ApiResponse<bool>> resetPassword(ResetPasswordDto dto) async {
    return post<bool>(
      '/auth/reset-password',
      body: dto.toJson(),
      fromJson: (data) => data is bool ? data : (data == true || data == 'true'),
      requiresAuth: false,
    );
  }
}
