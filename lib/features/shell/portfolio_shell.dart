import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/platform_utils.dart';
import '../../services/navigation_service.dart';
import 'widgets/nav_bar_web.dart';
import 'widgets/nav_drawer_mobile.dart';
import '../header/header_section.dart';
import '../about/about_section.dart';
import '../skills/skills_section.dart';
import '../projects/projects_section.dart';
import '../experience/experience_section.dart';
import '../contact/contact_section.dart';
import '../footer/footer_section.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/blocs/navigation/navigation_bloc.dart';

class PortfolioShell extends StatelessWidget {
  const PortfolioShell({super.key});

  static final List<String> _sectionOrder = [
    'home',
    'about',
    'skills',
    'projects',
    'experience',
    'contact',
  ];

  void _onScroll(BuildContext context, ScrollController controller) {
    for (final id in _sectionOrder.reversed) {
      final key = NavigationService.instance.sectionKeys[id];
      if (key?.currentContext != null) {
        final box = key!.currentContext!.findRenderObject() as RenderBox?;
        if (box == null) continue;
        final offset = box.localToGlobal(Offset.zero);
        if (offset.dy <= 160) {
          final bloc = context.read<NavigationBloc>();
          if (bloc.state.activeSection != id) {
            bloc.add(SectionChanged(id));
          }
          break;
        }
      }
    }
  }

  void _onNavTap(
    BuildContext context,
    GlobalKey<ScaffoldState> scaffoldKey,
    String sectionId,
  ) {
    if (!kIsWeb) {
      scaffoldKey.currentState?.closeDrawer();
    }
    NavigationService.instance.scrollToSection(sectionId);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    final isWebDesktop =
        PlatformUtils.instance.isDesktop(context) ||
        PlatformUtils.instance.isTablet(context);

    final ScrollController scrollController = ScrollController();
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>(
      debugLabel: 'portfolio_scaffold',
    );

    scrollController.addListener(() => _onScroll(context, scrollController));

    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          key: scaffoldKey,
          backgroundColor: colors.background,
          extendBodyBehindAppBar: true,
          appBar: isWebDesktop
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(
                    AppDimensions.navBarHeight,
                  ),
                  child: NavBarWeb(
                    activeSection: state.activeSection,
                    onNavTap: (id) => _onNavTap(context, scaffoldKey, id),
                  ),
                )
              : PreferredSize(
                  preferredSize: const Size.fromHeight(
                    AppDimensions.navBarHeightMobile,
                  ),
                  child: _MobileAppBar(
                    onMenuTap: () => scaffoldKey.currentState?.openDrawer(),
                  ),
                ),
          drawer: isWebDesktop
              ? null
              : NavDrawerMobile(
                  activeSection: state.activeSection,
                  onNavTap: (id) => _onNavTap(context, scaffoldKey, id),
                ),
          body: SingleChildScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const _SectionWrapper(
                  sectionId: 'home',
                  child: HeaderSection(),
                ),
                const _SectionWrapper(
                  sectionId: 'about',
                  child: AboutSection(),
                ),
                const _SectionWrapper(
                  sectionId: 'skills',
                  child: SkillsSection(),
                ),
                const _SectionWrapper(
                  sectionId: 'projects',
                  child: ProjectsSection(),
                ),
                const _SectionWrapper(
                  sectionId: 'experience',
                  child: ExperienceSection(),
                ),
                const _SectionWrapper(
                  sectionId: 'contact',
                  child: ContactSection(),
                ),
                const FooterSection(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SectionWrapper extends StatelessWidget {
  final String sectionId;
  final Widget child;

  const _SectionWrapper({required this.sectionId, required this.child});

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: NavigationService.instance.sectionKeys[sectionId],
      child: child,
    );
  }
}

/// Compact mobile AppBar with logo and hamburger icon.
class _MobileAppBar extends StatelessWidget {
  final VoidCallback onMenuTap;
  const _MobileAppBar({required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return AppBar(
      backgroundColor: colors.background.withValues(alpha: 0.95),
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: AppDimensions.navBarHeightMobile,
      // Removed leading branding logo
      actions: [
        IconButton(
          onPressed: onMenuTap,
          icon: Icon(Icons.menu_rounded, color: colors.textPrimary, size: 28),
        ),
        const SizedBox(width: AppDimensions.sm),
      ],
    );
  }
}
