import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/controllers/hover_controller.dart';

class NavBarWeb extends StatelessWidget {
  final String activeSection;
  final void Function(String sectionId) onNavTap;

  const NavBarWeb({
    super.key,
    required this.activeSection,
    required this.onNavTap,
  });

  static const List<_NavItem> _items = [
    _NavItem(id: 'home', label: AppStrings.navHome),
    _NavItem(id: 'about', label: AppStrings.navAbout),
    _NavItem(id: 'skills', label: AppStrings.navSkills),
    _NavItem(id: 'projects', label: AppStrings.navProjects),
    _NavItem(id: 'experience', label: AppStrings.navExperience),
    _NavItem(id: 'contact', label: AppStrings.navContact),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;

    return ClipRect(
      child: Container(
        height: AppDimensions.navBarHeight,
        decoration: BoxDecoration(
          color: colors.background.withValues(alpha: 0.92),
          border: Border(bottom: BorderSide(color: colors.border, width: 1)),
        ),
        child: Row(
          children: [
            // Removed branding logo
            const SizedBox(width: AppDimensions.xl),
            const Spacer(),
            // ── Nav items ─────────────────────────────────────────────────────
            ..._items.map(
              (item) => _NavLink(
                item: item,
                isActive: activeSection == item.id,
                onTap: () => onNavTap(item.id),
              ),
            ),
            const SizedBox(width: AppDimensions.md),
            // ── Hire Me CTA ───────────────────────────────────────────────────
            _HireMeButton(onTap: () => onNavTap('contact')),
            const SizedBox(width: AppDimensions.xl),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final String id;
  final String label;
  const _NavItem({required this.id, required this.label});
}

class _NavLink extends StatelessWidget {
  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavLink({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    final controller = Get.put(HoverController(), tag: 'nav_link_${item.id}');

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => controller.isHovered = true,
      onExit: (_) => controller.isHovered = false,
      child: GestureDetector(
        onTap: onTap,
        child: Obx(() {
          final isHovered = controller.isHovered; // Unconditional access
          final isHighlighted = isActive || isHovered;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.md,
              vertical: AppDimensions.sm,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: isHighlighted
                        ? colors.primary
                        : colors.textSecondary,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  ),
                  child: Text(item.label),
                ),
                const SizedBox(height: 2),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 2,
                  width: isHighlighted ? 20 : 0,
                  decoration: BoxDecoration(
                    gradient: colors.primaryGradient,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusFull,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _HireMeButton extends StatelessWidget {
  final VoidCallback onTap;
  const _HireMeButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    final controller = Get.put(HoverController(), tag: 'nav_hire_me');

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => controller.isHovered = true,
      onExit: (_) => controller.isHovered = false,
      child: GestureDetector(
        onTap: onTap,
        child: Obx(
          () => AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.lg,
              vertical: AppDimensions.sm + 4,
            ),
            decoration: BoxDecoration(
              gradient: controller.isHovered ? null : colors.primaryGradient,
              color: controller.isHovered ? colors.primaryLight : null,
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              boxShadow: controller.isHovered
                  ? [
                      BoxShadow(
                        color: colors.primary.withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Text(
              AppStrings.ctaHireMe,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
