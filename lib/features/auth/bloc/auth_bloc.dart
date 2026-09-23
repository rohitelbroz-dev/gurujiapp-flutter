import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:guruji/core/services/user_persistence_service.dart';
import 'package:guruji/features/auth/data/auth_repositiory.dart';
import 'package:guruji/features/auth/models/profile_model.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(AuthInitial()) {
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<RegisterEvent>(_onRegister);
    on<GetProfileEvent>(_onGetProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<LogoutEvent>(_onLogout);
    on<DeleteAccountEvent>(_onDeleteAccount);
  }

  Future<void> _onSendOtp(SendOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await _authRepository.sendOtp(event.phone);
      emit(
        OtpSentSuccess(
          phone: response['phone'] as String,
          otpCode: response['otpCode'] as String,
          expiresIn: response['expiresIn'] as int,
        ),
      );
    } catch (e) {
      emit(AuthFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await _authRepository.verifyOtp(event.phone, event.otp);
      // Save token and user data for persistence
      await UserPersistenceService.saveUserSession(
        response['token'],
        response['user'],
      );
      emit(
        OtpVerifiedSuccess(
          token: response['token'] as String,
          user: response['user'] as Map<String, dynamic>,
          message: response['message'] as String,
        ),
      );
    } catch (e) {
      emit(AuthFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    print(
      'AuthBloc: _onRegister called with phone: ${event.phone}',
    ); // Debug print
    emit(AuthLoading());
    try {
      final response = await _authRepository.register(
        name: event.name,
        phone: event.phone,
        email: event.email,
        city: event.city,
        state: event.state,
        dateOfBirth: event.dateOfBirth,
        gotra: event.gotra,
      );
      print('AuthBloc: Register response: $response'); // Debug print
      emit(
        OtpSentSuccess(
          phone: response['phone'] as String,
          otpCode: response['otpCode'] as String,
          expiresIn: response['expiresIn'] as int,
        ),
      );
      print(
        'AuthBloc: OtpSentSuccess emitted for phone: ${response['phone']}',
      ); // Debug print
    } catch (e) {
      print('AuthBloc: Register error: $e'); // Debug print
      emit(AuthFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onGetProfile(
    GetProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final profile = await _authRepository.getProfile();
      emit(ProfileLoadSuccess(profile: profile));
    } catch (e) {
      emit(AuthFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final profile = await _authRepository.updateProfile(
        name: event.name,
        phone: event.phone,
        email: event.email,
        city: event.city,
        state: event.state,
        dateOfBirth: event.dateOfBirth,
        gotra: event.gotra,
        profileImageFile: event.profileImageFile,
      );
      emit(ProfileUpdateSuccess(profile: profile));
    } catch (e) {
      emit(AuthFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    try {
      await _authRepository.logout();
      await UserPersistenceService.logout();
      emit(const LogoutSuccess());
    } catch (e) {
      emit(AuthFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.deleteAccount();
      await UserPersistenceService.logout();
      emit(const AccountDeletedSuccess());
    } catch (e) {
      emit(AuthFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }
}
