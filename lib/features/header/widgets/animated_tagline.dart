import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

/// Cycles through the [AppStrings.taglines] list with a typing / fade effect.
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/blocs/header/header_bloc.dart';

/// Cycles through the [AppStrings.taglines] list with a typing / fade effect.
class AnimatedTagline extends StatelessWidget {
  const AnimatedTagline({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return BlocBuilder<HeaderBloc, HeaderState>(
      builder: (context, state) {
        return AnimatedOpacity(
          opacity: state.taglineVisible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          child: AnimatedSlide(
            offset: state.taglineVisible ? Offset.zero : const Offset(0, 0.15),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            child: ShaderMask(
              shaderCallback: (bounds) =>
                  colors.primaryGradient.createShader(bounds),
              child: Text(
                AppStrings.taglines[state.taglineIndex],
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
