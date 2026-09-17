part of 'family_bloc.dart';

abstract class FamilyEvent extends Equatable {
  const FamilyEvent();

  @override
  List<Object?> get props => [];
}

class FetchFamilyTreeEvent extends FamilyEvent {
  const FetchFamilyTreeEvent();
}
