import 'package:denta_incomes/models/api_response_dto.dart';
import 'package:denta_incomes/utils/api_client.dart';
import 'package:denta_incomes/models/auth.dart';

class AuthService {
  static Future<ApiResponse<LoginResponseDto>> login(LoginDto loginDto) async {
    final result = await ApiClient.login(loginDto);
    if (result.success && result.data != null) {
      
    }
    return result;
  }

  static Future<ApiResponse<bool>> logout() => ApiClient.logout();
  
  static Future<ApiResponse<bool>> changePassword(ChangePasswordDto dto) =>
      ApiClient.changePassword(dto);
  
  static Future<ApiResponse<bool>> forgotPassword(String email) =>
      ApiClient.forgotPassword(email);
  
  static Future<ApiResponse<bool>> resetPassword(ResetPasswordDto dto) =>
      ApiClient.resetPassword(dto);

  static Future<String?> getAccessToken() => ApiClient.getAccessToken();
  static Future<String?> getRefreshToken() => ApiClient.getRefreshToken();
  static Future<UserDto?> getCurrentUser() => ApiClient.getCurrentUser();
  static Future<bool> isLoggedIn() => ApiClient.isLoggedIn();
}
