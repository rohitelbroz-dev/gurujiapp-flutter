part of 'naam_jaap_bloc.dart';

sealed class NaamJaapEvent extends Equatable {
  const NaamJaapEvent();

  @override
  List<Object?> get props => [];
}

final class NaamJaapIncremented extends NaamJaapEvent {
  const NaamJaapIncremented();
}

final class NaamJaapDraftRestored extends NaamJaapEvent {
  const NaamJaapDraftRestored();
}

final class NaamJaapSessionSaved extends NaamJaapEvent {
  const NaamJaapSessionSaved();
}

final class NaamJaapSaveStatusCleared extends NaamJaapEvent {
  const NaamJaapSaveStatusCleared();
}

final class NaamJaapVolumeChanged extends NaamJaapEvent {
  final double volume;

  const NaamJaapVolumeChanged(this.volume);

  @override
  List<Object?> get props => [volume];
}
