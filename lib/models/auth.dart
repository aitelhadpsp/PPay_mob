

// Models
class LoginDto {
  final String username;
  final String password;
  final bool rememberMe;

  LoginDto({
    required this.username,
    required this.password,
    this.rememberMe = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'rememberMe': rememberMe,
    };
  }
}

class LoginResponseDto {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
  final UserDto user;

  LoginResponseDto({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.user,
  });

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    return LoginResponseDto(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      expiresAt: DateTime.parse(json['expiresAt']),
      user: UserDto.fromJson(json['user']),
    );
  }
}

class UserDto {
  final int id;
  final String fullName;
  final String username;
  final String email;
  final String? phone;
  final String role;
  final bool isActive;
  final DateTime? lastLoginDate;
  final DateTime createdDate;
  final String? profileImagePath; // maps backend ProfileImagePath
  final String roleDisplay;
  final String statusDisplay;
  final bool isLocked;

  UserDto({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    this.phone,
    required this.role,
    required this.isActive,
    this.lastLoginDate,
    required this.createdDate,
    this.profileImagePath,
    required this.roleDisplay,
    required this.statusDisplay,
    required this.isLocked,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json["id"] is String ? int.parse(json["id"]) : json["id"],
      fullName: json['fullName'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      role: json['role'] ?? '',
      isActive: json['isActive'] ?? false,
      lastLoginDate: json['lastLoginDate'] != null
          ? DateTime.tryParse(json['lastLoginDate'])
          : null,
      createdDate: DateTime.parse(json['createdDate']),
      profileImagePath: json['profileImagePath'],
      roleDisplay: json['roleDisplay'] ?? '',
      statusDisplay: json['statusDisplay'] ?? '',
      isLocked: json['isLocked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'username': username,
      'email': email,
      'phone': phone,
      'role': role,
      'isActive': isActive,
      'lastLoginDate': lastLoginDate?.toIso8601String(),
      'createdDate': createdDate.toIso8601String(),
      'profileImagePath': profileImagePath,
      'roleDisplay': roleDisplay,
      'statusDisplay': statusDisplay,
      'isLocked': isLocked,
    };
  }
}


class ChangePasswordDto {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  ChangePasswordDto({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };
  }
}

class ResetPasswordDto {
  final String email;
  final String token;
  final String newPassword;
  final String confirmPassword;

  ResetPasswordDto({
    required this.email,
    required this.token,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'token': token,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };
  }
}

class AccountSecurityInfoDto {
  final DateTime lastLoginAt;
  final String lastLoginIp;
  final int activeSessionsCount;
  final List<LoginAttemptDto> recentLoginAttempts;
  final bool twoFactorEnabled;

  AccountSecurityInfoDto({
    required this.lastLoginAt,
    required this.lastLoginIp,
    required this.activeSessionsCount,
    required this.recentLoginAttempts,
    required this.twoFactorEnabled,
  });

  factory AccountSecurityInfoDto.fromJson(Map<String, dynamic> json) {
    return AccountSecurityInfoDto(
      lastLoginAt: DateTime.parse(json['lastLoginAt']),
      lastLoginIp: json['lastLoginIp'],
      activeSessionsCount: json['activeSessionsCount'],
      recentLoginAttempts: (json['recentLoginAttempts'] as List)
          .map((e) => LoginAttemptDto.fromJson(e))
          .toList(),
      twoFactorEnabled: json['twoFactorEnabled'],
    );
  }
}

class LoginAttemptDto {
  final DateTime attemptedAt;
  final String ipAddress;
  final bool successful;
  final String userAgent;

  LoginAttemptDto({
    required this.attemptedAt,
    required this.ipAddress,
    required this.successful,
    required this.userAgent,
  });

  factory LoginAttemptDto.fromJson(Map<String, dynamic> json) {
    return LoginAttemptDto(
      attemptedAt: DateTime.parse(json['attemptedAt']),
      ipAddress: json['ipAddress'],
      successful: json['successful'],
      userAgent: json['userAgent'],
    );
  }
}