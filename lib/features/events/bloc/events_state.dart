part of 'events_bloc.dart';

abstract class EventsState extends Equatable {
  const EventsState();

  @override
  List<Object?> get props => [];
}

class EventsInitial extends EventsState {}

class EventsLoading extends EventsState {}

class EventsLoadSuccess extends EventsState {
  final EventsResponse eventsResponse;

  const EventsLoadSuccess({required this.eventsResponse});

  @override
  List<Object?> get props => [eventsResponse];
}

class EventsFailure extends EventsState {
  final String message;

  const EventsFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
