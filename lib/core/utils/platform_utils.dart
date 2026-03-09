import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PlatformUtils {
  PlatformUtils._();
  static final PlatformUtils instance = PlatformUtils._();

  bool get isWeb => kIsWeb;

  bool isMobile(BuildContext context) =>
      ResponsiveBreakpoints.of(context).isMobile;

  bool isTablet(BuildContext context) =>
      ResponsiveBreakpoints.of(context).isTablet;

  bool isDesktop(BuildContext context) =>
      ResponsiveBreakpoints.of(context).isDesktop;

  bool isLargeDesktop(BuildContext context) =>
      ResponsiveBreakpoints.of(context).largerThan(DESKTOP);

  T adaptive<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    required T desktop,
  }) {
    if (isDesktop(context)) return desktop;
    if (isTablet(context)) return tablet ?? desktop;
    return mobile;
  }

  double horizontalPadding(BuildContext context) =>
      adaptive(context, mobile: 20.0, tablet: 48.0, desktop: 80.0);

  double verticalPadding(BuildContext context) =>
      adaptive(context, mobile: 60.0, tablet: 80.0, desktop: 100.0);
}
