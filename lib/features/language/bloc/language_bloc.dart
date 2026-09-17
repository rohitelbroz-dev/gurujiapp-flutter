import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:guruji/core/services/language_service.dart';

// Events
abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object?> get props => [];
}

class LoadLanguageEvent extends LanguageEvent {
  const LoadLanguageEvent();
}

class ChangeLanguageEvent extends LanguageEvent {
  final String languageCode;

  const ChangeLanguageEvent(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}

// States
class LanguageState extends Equatable {
  final String languageCode;

  const LanguageState({this.languageCode = 'hi'});

  LanguageState copyWith({String? languageCode}) {
    return LanguageState(
      languageCode: languageCode ?? this.languageCode,
    );
  }

  @override
  List<Object?> get props => [languageCode];
}

// Bloc
class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(const LanguageState(languageCode: 'hi')) {
    on<LoadLanguageEvent>(_onLoadLanguage);
    on<ChangeLanguageEvent>(_onChangeLanguage);
  }

  Future<void> _onLoadLanguage(
    LoadLanguageEvent event,
    Emitter<LanguageState> emit,
  ) async {
    final code = await LanguageService.getLanguage();
    emit(state.copyWith(languageCode: code));
  }

  Future<void> _onChangeLanguage(
    ChangeLanguageEvent event,
    Emitter<LanguageState> emit,
  ) async {
    emit(state.copyWith(languageCode: event.languageCode));
    await LanguageService.setLanguage(event.languageCode);
  }
}
