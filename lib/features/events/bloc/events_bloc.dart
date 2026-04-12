import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:guruji/features/events/data/events_repository.dart';
import 'package:guruji/features/events/models/event_model.dart';

part 'events_event.dart';
part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final EventsRepository _eventsRepository;

  EventsBloc({required EventsRepository eventsRepository})
    : _eventsRepository = eventsRepository,
      super(EventsInitial()) {
    on<FetchEventsEvent>(_onFetchEvents);
  }

  Future<void> _onFetchEvents(
    FetchEventsEvent event,
    Emitter<EventsState> emit,
  ) async {
    emit(EventsLoading());
    try {
      final response = await _eventsRepository.fetchEvents(
        page: event.page,
        limit: event.limit,
      );
      emit(EventsLoadSuccess(eventsResponse: response));
    } catch (e) {
      emit(EventsFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }
}
