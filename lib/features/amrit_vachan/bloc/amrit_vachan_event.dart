part of 'amrit_vachan_bloc.dart';

abstract class AmritVachanEvent extends Equatable {
  const AmritVachanEvent();

  @override
  List<Object?> get props => [];
}

class FetchAmritVachanEvent extends AmritVachanEvent {
  const FetchAmritVachanEvent();
}
