part of 'family_bloc.dart';

abstract class FamilyState extends Equatable {
  const FamilyState();

  @override
  List<Object?> get props => [];
}

class FamilyInitial extends FamilyState {}

class FamilyLoading extends FamilyState {}

class FamilyLoadSuccess extends FamilyState {
  final FamilyMember familyTree;

  const FamilyLoadSuccess({required this.familyTree});

  @override
  List<Object?> get props => [familyTree];
}

class FamilyFailure extends FamilyState {
  final String message;

  const FamilyFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
