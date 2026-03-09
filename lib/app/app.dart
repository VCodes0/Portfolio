import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_dimensions.dart';
import '../features/shell/portfolio_shell.dart';

import '../logic/blocs/header/header_bloc.dart';
import '../logic/blocs/navigation/navigation_bloc.dart';
import '../logic/blocs/theme/theme_bloc.dart';
import 'app_bindings.dart';

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => Get.find<ThemeBloc>()),
        BlocProvider(create: (_) => Get.find<NavigationBloc>()),
        BlocProvider(create: (_) => Get.find<HeaderBloc>()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return GetMaterialApp(
            title: 'Vishnu Prajapati — Flutter Developer',
            debugShowCheckedModeBanner: false,
            initialBinding: AppBindings(),
            theme: AppTheme.instance.darkTheme,
            home: const PortfolioShell(),
            builder: (context, child) => ResponsiveBreakpoints.builder(
              child: child!,
              breakpoints: const [
                Breakpoint(
                  start: 0,
                  end: AppDimensions.mobileBreakpoint - 1,
                  name: MOBILE,
                ),
                Breakpoint(
                  start: AppDimensions.mobileBreakpoint,
                  end: AppDimensions.tabletBreakpoint - 1,
                  name: TABLET,
                ),
                Breakpoint(
                  start: AppDimensions.tabletBreakpoint,
                  end: AppDimensions.desktopBreakpoint - 1,
                  name: DESKTOP,
                ),
                Breakpoint(
                  start: AppDimensions.desktopBreakpoint,
                  end: double.infinity,
                  name: '4K',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
