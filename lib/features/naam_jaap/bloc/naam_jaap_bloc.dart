import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:guruji/features/naam_jaap/data/naam_jaap_repository.dart';

part 'naam_jaap_event.dart';
part 'naam_jaap_state.dart';

class NaamJaapBloc extends Bloc<NaamJaapEvent, NaamJaapState> {
  NaamJaapBloc({required NaamJaapRepository naamJaapRepository})
    : _naamJaapRepository = naamJaapRepository,
      super(const NaamJaapState()) {
    on<NaamJaapDraftRestored>(_onDraftRestored);
    on<NaamJaapIncremented>(_onIncremented);
    on<NaamJaapSessionSaved>(_onSessionSaved);
    on<NaamJaapVolumeChanged>(_onVolumeChanged);
    on<NaamJaapSaveStatusCleared>(_onSaveStatusCleared);

    add(const NaamJaapDraftRestored());
  }

  final NaamJaapRepository _naamJaapRepository;

  Future<void> _onDraftRestored(
    NaamJaapDraftRestored event,
    Emitter<NaamJaapState> emit,
  ) async {
    final draftCount = await _naamJaapRepository.getDraftSessionCount();
    if (draftCount <= 0) {
      return;
    }

    emit(state.copyWith(totalJaap: draftCount));
  }

  Future<void> _onIncremented(
    NaamJaapIncremented event,
    Emitter<NaamJaapState> emit,
  ) async {
    final updatedCount = state.totalJaap + 1;
    emit(state.copyWith(totalJaap: updatedCount));
    await _naamJaapRepository.saveDraftSessionCount(updatedCount);
  }

  Future<void> _onSessionSaved(
    NaamJaapSessionSaved event,
    Emitter<NaamJaapState> emit,
  ) async {
    if (state.totalJaap == 0 || state.isSaving) {
      return;
    }

    emit(
      state.copyWith(
        saveStatus: NaamJaapSaveStatus.saving,
        errorMessage: '',
      ),
    );

    try {
      final currentCount = state.totalJaap;
      await _naamJaapRepository.saveMantraCount(currentCount);
      await _naamJaapRepository.clearDraftSessionCount();
      emit(
        state.copyWith(
          totalJaap: 0,
          savedJaap: 0,
          saveStatus: NaamJaapSaveStatus.success,
          errorMessage: '',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          saveStatus: NaamJaapSaveStatus.failure,
          errorMessage: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }

  void _onVolumeChanged(
    NaamJaapVolumeChanged event,
    Emitter<NaamJaapState> emit,
  ) {
    emit(state.copyWith(volume: event.volume.clamp(0.0, 1.0)));
  }

  void _onSaveStatusCleared(
    NaamJaapSaveStatusCleared event,
    Emitter<NaamJaapState> emit,
  ) {
    emit(
      state.copyWith(
        saveStatus: NaamJaapSaveStatus.idle,
        clearErrorMessage: true,
      ),
    );
  }
}
