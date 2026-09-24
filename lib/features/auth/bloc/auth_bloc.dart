import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:guruji/core/services/user_persistence_service.dart';
import '../data/auth_repositiory.dart';
import '../models/profile_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<SendOtpEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await authRepository.sendOtp(event.phone);
        emit(
          OtpSentSuccess(
            phone: event.phone,
            otpCode: response['otpCode']?.toString() ?? '',
            expiresIn: response['expiresIn'] ?? 300,
          ),
        );
      } catch (e) {
        emit(AuthFailure(message: e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<VerifyOtpEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await authRepository.verifyOtp(event.phone, event.otp);
        emit(
          OtpVerifiedSuccess(
            token: response['token'] ?? '',
            user: response['user'] ?? {},
            message: response['message'] ?? 'OTP Verified successfully',
          ),
        );
      } catch (e) {
        emit(AuthFailure(message: e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<GetProfileEvent>((event, emit) async {
      emit(ProfileLoading());
      try {
        final profile = await authRepository.getProfile();
        emit(ProfileLoadSuccess(profile: profile));
      } catch (e) {
        emit(AuthFailure(message: e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<UpdateProfileEvent>((event, emit) async {
      emit(ProfileLoading());
      try {
        final profile = await authRepository.updateProfile(
          name: event.name,
          phone: event.phone,
          email: event.email,
          city: event.city,
          state: event.state,
          dateOfBirth: event.dateOfBirth,
          gotra: event.gotra,
          muhuratAlerts: event.muhuratAlerts,
          prayerReminders: event.prayerReminders,
          profileImageFile: event.profileImageFile,
        );
        if (event.muhuratAlerts != null) {
          await UserPersistenceService.saveMuhuratAlerts(event.muhuratAlerts!);
        }
        if (event.prayerReminders != null) {
          await UserPersistenceService.savePrayerReminders(event.prayerReminders!);
        }
        emit(ProfileUpdateSuccess(profile: profile));
      } catch (e) {
        emit(AuthFailure(message: e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<UpdatePreferencesEvent>((event, emit) async {
      try {
        final profile = await authRepository.updateProfile(
          muhuratAlerts: event.muhuratAlerts,
          prayerReminders: event.prayerReminders,
        );
        if (event.muhuratAlerts != null) {
          await UserPersistenceService.saveMuhuratAlerts(event.muhuratAlerts!);
        }
        if (event.prayerReminders != null) {
          await UserPersistenceService.savePrayerReminders(event.prayerReminders!);
        }
        emit(ProfileLoadSuccess(profile: profile));
      } catch (_) {
        // Silently handled: Local state is already updated
      }
    });

    on<LogoutEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.logout();
        await UserPersistenceService.clearAll();
        emit(const LogoutSuccess());
      } catch (e) {
        await UserPersistenceService.clearAll();
        emit(const LogoutSuccess());
      }
    });

    on<DeleteAccountEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.deleteAccount();
        await UserPersistenceService.clearAll();
        emit(const AccountDeletedSuccess());
      } catch (e) {
        emit(AuthFailure(message: e.toString().replaceAll('Exception: ', '')));
      }
    });
  }
}
