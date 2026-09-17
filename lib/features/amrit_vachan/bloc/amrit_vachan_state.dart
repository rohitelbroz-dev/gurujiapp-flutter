part of 'amrit_vachan_bloc.dart';

abstract class AmritVachanState extends Equatable {
  const AmritVachanState();

  @override
  List<Object?> get props => [];
}

class AmritVachanInitial extends AmritVachanState {}

class AmritVachanLoading extends AmritVachanState {}

class AmritVachanLoadSuccess extends AmritVachanState {
  final List<AmritVachan> todayPosts;
  final List<AmritVachan> allPosts;

  const AmritVachanLoadSuccess({
    required this.todayPosts,
    required this.allPosts,
  });

  @override
  List<Object?> get props => [todayPosts, allPosts];
}

class AmritVachanFailure extends AmritVachanState {
  final String message;

  const AmritVachanFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
