import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ── Events ───────────────────────────────────────────────────────────────────
abstract class NavigationEvent extends Equatable {
  const NavigationEvent();
  @override
  List<Object> get props => [];
}

class SectionChanged extends NavigationEvent {
  final String activeSection;
  const SectionChanged(this.activeSection);
  @override
  List<Object> get props => [activeSection];
}

// ── State ────────────────────────────────────────────────────────────────────
class NavigationState extends Equatable {
  final String activeSection;
  const NavigationState({required this.activeSection});

  @override
  List<Object> get props => [activeSection];
}

// ── BLoC ─────────────────────────────────────────────────────────────────────
class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationState(activeSection: 'home')) {
    on<SectionChanged>((event, emit) {
      emit(NavigationState(activeSection: event.activeSection));
    });
  }
}
