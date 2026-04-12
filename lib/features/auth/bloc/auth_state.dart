part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class OtpSentSuccess extends AuthState {
  final String phone;
  final String otpCode;
  final int expiresIn;

  const OtpSentSuccess({
    required this.phone,
    required this.otpCode,
    required this.expiresIn,
  });

  @override
  List<Object?> get props => [phone, otpCode, expiresIn];
}

class OtpVerifiedSuccess extends AuthState {
  final String token;
  final Map<String, dynamic> user;
  final String message;

  const OtpVerifiedSuccess({
    required this.token,
    required this.user,
    required this.message,
  });

  @override
  List<Object?> get props => [token, user, message];
}

class ProfileLoading extends AuthState {}

class ProfileLoadSuccess extends AuthState {
  final Profile profile;

  const ProfileLoadSuccess({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class ProfileUpdateSuccess extends AuthState {
  final Profile profile;

  const ProfileUpdateSuccess({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class AuthFailure extends AuthState {
  final String message;
  const AuthFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class LogoutSuccess extends AuthState {
  const LogoutSuccess();

  @override
  List<Object?> get props => [];
}