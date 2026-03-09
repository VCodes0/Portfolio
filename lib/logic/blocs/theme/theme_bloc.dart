import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ── Events ───────────────────────────────────────────────────────────────────
abstract class ThemeEvent extends Equatable {
  const ThemeEvent();
  @override
  List<Object> get props => [];
}

class ToggleTheme extends ThemeEvent {}

// ── State ────────────────────────────────────────────────────────────────────
class ThemeState extends Equatable {
  final bool isDarkMode;
  const ThemeState({required this.isDarkMode});

  @override
  List<Object> get props => [isDarkMode];
}

// ── BLoC ─────────────────────────────────────────────────────────────────────
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(isDarkMode: true)) {
    on<ToggleTheme>((event, emit) {
      emit(ThemeState(isDarkMode: !state.isDarkMode));
    });
  }
}
