part of 'naam_jaap_bloc.dart';

enum NaamJaapSaveStatus { idle, saving, success, failure }

final class NaamJaapState extends Equatable {
  final int totalJaap;
  final int savedJaap;
  final double volume;
  final NaamJaapSaveStatus saveStatus;
  final String errorMessage;

  const NaamJaapState({
    this.totalJaap = 0,
    this.savedJaap = 0,
    this.volume = 0.2,
    this.saveStatus = NaamJaapSaveStatus.idle,
    this.errorMessage = '',
  });

  int get maalaCount => totalJaap ~/ 108;
  bool get isSaving => saveStatus == NaamJaapSaveStatus.saving;

  NaamJaapState copyWith({
    int? totalJaap,
    int? savedJaap,
    double? volume,
    NaamJaapSaveStatus? saveStatus,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return NaamJaapState(
      totalJaap: totalJaap ?? this.totalJaap,
      savedJaap: savedJaap ?? this.savedJaap,
      volume: volume ?? this.volume,
      saveStatus: saveStatus ?? this.saveStatus,
      errorMessage: clearErrorMessage ? '' : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    totalJaap,
    savedJaap,
    volume,
    saveStatus,
    errorMessage,
  ];
}
