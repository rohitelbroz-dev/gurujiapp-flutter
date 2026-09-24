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
  List<Object?> get props => [phone];
}

class VerifyOtpEvent extends AuthEvent {
  final String phone;
  final String otp;

  const VerifyOtpEvent({
    required this.phone,
    required this.otp,
  });

  @override
  List<Object?> get props => [phone, otp];
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
  List<Object?> get props => [name, phone, email, city, state, dateOfBirth, gotra];
}

class GetProfileEvent extends AuthEvent {
  const GetProfileEvent();
}

class UpdateProfileEvent extends AuthEvent {
  final String? name;
  final String? phone;
  final String? email;
  final String? city;
  final String? state;
  final String? dateOfBirth;
  final String? gotra;
  final bool? muhuratAlerts;
  final bool? prayerReminders;
  final File? profileImageFile;

  const UpdateProfileEvent({
    this.name,
    this.phone,
    this.email,
    this.city,
    this.state,
    this.dateOfBirth,
    this.gotra,
    this.muhuratAlerts,
    this.prayerReminders,
    this.profileImageFile,
  });

  @override
  List<Object?> get props => [
        name,
        phone,
        email,
        city,
        state,
        dateOfBirth,
        gotra,
        muhuratAlerts,
        prayerReminders,
        profileImageFile,
      ];
}

class UpdatePreferencesEvent extends AuthEvent {
  final bool? muhuratAlerts;
  final bool? prayerReminders;

  const UpdatePreferencesEvent({
    this.muhuratAlerts,
    this.prayerReminders,
  });

  @override
  List<Object?> get props => [muhuratAlerts, prayerReminders];
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

class DeleteAccountEvent extends AuthEvent {
  const DeleteAccountEvent();
}
