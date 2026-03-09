import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '../../../core/constants/app_strings.dart';

// ── Events ───────────────────────────────────────────────────────────────────
abstract class HeaderEvent extends Equatable {
  const HeaderEvent();
  @override
  List<Object> get props => [];
}

class NextTagline extends HeaderEvent {}

// ── State ────────────────────────────────────────────────────────────────────
class HeaderState extends Equatable {
  final int taglineIndex;
  final bool taglineVisible;
  const HeaderState({required this.taglineIndex, required this.taglineVisible});

  HeaderState copyWith({int? taglineIndex, bool? taglineVisible}) {
    return HeaderState(
      taglineIndex: taglineIndex ?? this.taglineIndex,
      taglineVisible: taglineVisible ?? this.taglineVisible,
    );
  }

  @override
  List<Object> get props => [taglineIndex, taglineVisible];
}

// ── BLoC ─────────────────────────────────────────────────────────────────────
class HeaderBloc extends Bloc<HeaderEvent, HeaderState> {
  Timer? _timer;

  HeaderBloc()
    : super(const HeaderState(taglineIndex: 0, taglineVisible: true)) {
    on<NextTagline>((event, emit) async {
      emit(state.copyWith(taglineVisible: false));
      await Future.delayed(const Duration(milliseconds: 400));
      final nextIndex = (state.taglineIndex + 1) % AppStrings.taglines.length;
      emit(state.copyWith(taglineIndex: nextIndex, taglineVisible: true));
    });

    _startCycling();
  }

  void _startCycling() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      add(NextTagline());
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
