import 'package:final_proj/core/base/base_model.dart';

/// Auth request model
class LoginRequest extends BaseModel {
  final String email;
  final String password;

  const LoginRequest({
    required this.email,
    required this.password,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  @override
  List<Object?> get props => [email, password];
}

/// Register request model
class RegisterRequest extends BaseModel {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;

  const RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }

  @override
  List<Object?> get props => [name, email, password, confirmPassword];
}

/// Forgot password request model
class ForgotPasswordRequest extends BaseModel {
  final String email;

  const ForgotPasswordRequest({required this.email});

  @override
  Map<String, dynamic> toJson() {
    return {'email': email};
  }

  @override
  List<Object?> get props => [email];
}

/// User model for auth response
class UserModel extends BaseModel {
  final String uid;
  final String name;
  final String email;
  final String? profileImage;
  final bool emailVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.profileImage,
    required this.emailVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'],
      emailVerified: json['emailVerified'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'emailVerified': emailVerified,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy with modifications
  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? profileImage,
    bool? emailVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      emailVerified: emailVerified ?? this.emailVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    uid,
    name,
    email,
    profileImage,
    emailVerified,
    createdAt,
    updatedAt,
  ];
}

/// Auth response model
class AuthResponse extends BaseModel {
  final UserModel user;
  final String accessToken;
  final String? refreshToken;

  const AuthResponse({
    required this.user,
    required this.accessToken,
    this.refreshToken,
  });

  /// Create from JSON
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: UserModel.fromJson(json['user'] ?? {}),
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  @override
  List<Object?> get props => [user, accessToken, refreshToken];
}
