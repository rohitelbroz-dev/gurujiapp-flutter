part of 'auth_bloc.dart';



abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SendOtpEvent extends AuthEvent {
  final String phone;

  const SendOtpEvent({required this.phone});

  @override
  List<Object> get props => [phone];
}

class VerifyOtpEvent extends AuthEvent {
  final String phone;
  final String otp;
  const VerifyOtpEvent({required this.phone, required this.otp});

  @override
  List<Object> get props => [phone, otp];
}

class RegisterEvent extends AuthEvent {
  final String name;
  final String phone;
  final String email;
  final String city;
  final String state;
  final String dateOfBirth;
  final String gotra;

  const RegisterEvent({
    required this.name,
    required this.phone,
    required this.email,
    required this.city,
    required this.state,
    required this.dateOfBirth,
    required this.gotra,
  });

  @override
  List<Object> get props => [name, phone, email, city, state, dateOfBirth, gotra];
}

class GetProfileEvent extends AuthEvent {
  const GetProfileEvent();

  @override
  List<Object> get props => [];
}

class UpdateProfileEvent extends AuthEvent {
  final String name;
  final String phone;
  final String email;
  final String city;
  final String state;
  final String dateOfBirth;
  final String gotra;
  final File? profileImageFile;

  UpdateProfileEvent({
    required this.name,
    required this.phone,
    required this.email,
    required this.city,
    required this.state,
    required this.dateOfBirth,
    required this.gotra,
    this.profileImageFile,
  });

  @override
  List<Object?> get props => [name, phone, email, city, state, dateOfBirth, gotra, profileImageFile];
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();

  @override
  List<Object?> get props => [];
}


class DeleteAccountEvent extends AuthEvent {
  const DeleteAccountEvent();

  @override
  List<Object?> get props => [];
}
