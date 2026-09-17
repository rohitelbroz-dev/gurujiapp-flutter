import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:guruji/features/family/data/family_repository.dart';
import 'package:guruji/features/family/models/family_member.dart';

part 'family_event.dart';
part 'family_state.dart';

class FamilyBloc extends Bloc<FamilyEvent, FamilyState> {
  final FamilyRepository _familyRepository;

  FamilyBloc({required FamilyRepository familyRepository})
    : _familyRepository = familyRepository,
      super(FamilyInitial()) {
    on<FetchFamilyTreeEvent>(_onFetchFamilyTree);
  }

  Future<void> _onFetchFamilyTree(
    FetchFamilyTreeEvent event,
    Emitter<FamilyState> emit,
  ) async {
    emit(FamilyLoading());
    try {
      final familyTree = await _familyRepository.fetchFamilyTree();
      emit(FamilyLoadSuccess(familyTree: familyTree));
    } catch (e) {
      emit(FamilyFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }
}
