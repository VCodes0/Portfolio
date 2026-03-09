import 'package:flutter/material.dart';
import '../features/shell/portfolio_shell.dart';

class NavigationService {
  NavigationService._();
  static final NavigationService instance = NavigationService._();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'portfolio_nav',
  );

  final Map<String, GlobalKey> sectionKeys = {
    'home': GlobalKey(debugLabel: 'home'),
    'about': GlobalKey(debugLabel: 'about'),
    'skills': GlobalKey(debugLabel: 'skills'),
    'projects': GlobalKey(debugLabel: 'projects'),
    'experience': GlobalKey(debugLabel: 'experience'),
    'contact': GlobalKey(debugLabel: 'contact'),
  };

  Future<void> scrollToSection(String sectionId) async {
    final key = sectionKeys[sectionId];
    if (key == null || key.currentContext == null) return;

    await Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      default:
        return MaterialPageRoute(builder: (_) => const PortfolioShell());
    }
  }
}
