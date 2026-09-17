import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:guruji/features/amrit_vachan/data/amrit_vachan_repository.dart';
import 'package:guruji/features/amrit_vachan/models/amrit_vachan_model.dart';

part 'amrit_vachan_event.dart';
part 'amrit_vachan_state.dart';

class AmritVachanBloc extends Bloc<AmritVachanEvent, AmritVachanState> {
  final AmritVachanRepository _amritVachanRepository;

  AmritVachanBloc({required AmritVachanRepository amritVachanRepository})
    : _amritVachanRepository = amritVachanRepository,
      super(AmritVachanInitial()) {
    on<FetchAmritVachanEvent>(_onFetchAmritVachan);
  }

  Future<void> _onFetchAmritVachan(
    FetchAmritVachanEvent event,
    Emitter<AmritVachanState> emit,
  ) async {
    emit(AmritVachanLoading());
    try {
      final results = await Future.wait([
        _amritVachanRepository.fetchTodayPosts(),
        _amritVachanRepository.fetchAllPosts(),
      ]);

      emit(
        AmritVachanLoadSuccess(
          todayPosts: results[0],
          allPosts: results[1],
        ),
      );
    } catch (e) {
      emit(
        AmritVachanFailure(
          message: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }
}
