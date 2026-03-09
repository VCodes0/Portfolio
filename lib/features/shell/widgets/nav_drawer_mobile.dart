import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';

/// Side drawer for mobile navigation.
class NavDrawerMobile extends StatelessWidget {
  final String activeSection;
  final void Function(String sectionId) onNavTap;

  const NavDrawerMobile({
    super.key,
    required this.activeSection,
    required this.onNavTap,
  });

  static const List<_NavItem> _items = [
    _NavItem(id: 'home', label: 'Home', icon: Icons.home_rounded),
    _NavItem(id: 'about', label: 'About', icon: Icons.person_rounded),
    _NavItem(id: 'skills', label: 'Skills', icon: Icons.star_rounded),
    _NavItem(id: 'projects', label: 'Projects', icon: Icons.work_rounded),
    _NavItem(
      id: 'experience',
      label: 'Experience',
      icon: Icons.timeline_rounded,
    ),
    _NavItem(id: 'contact', label: 'Contact', icon: Icons.mail_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return Drawer(
      backgroundColor: colors.surfaceVariant,
      width: 280,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.md,
            vertical: AppDimensions.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Logo ────────────────────────────────────────────────────────
              // Removed branding logo
              const SizedBox(height: AppDimensions.md),
              Padding(
                padding: const EdgeInsets.only(
                  left: AppDimensions.sm,
                  top: AppDimensions.xs,
                ),
                child: Text(
                  AppStrings.profession,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              const SizedBox(height: AppDimensions.xl),
              Divider(color: colors.border),
              const SizedBox(height: AppDimensions.md),
              // ── Nav items ───────────────────────────────────────────────────
              ..._items.map(
                (item) => _DrawerNavItem(
                  item: item,
                  isActive: activeSection == item.id,
                  onTap: () => onNavTap(item.id),
                ),
              ),
              const Spacer(),
              Divider(color: colors.border),
              const SizedBox(height: AppDimensions.md),
              // ── Social links ────────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SocialIcon(
                    icon: FontAwesomeIcons.github,
                    url: AppStrings.githubUrl,
                  ),
                  const SizedBox(width: AppDimensions.lg),
                  _SocialIcon(
                    icon: FontAwesomeIcons.linkedin,
                    url: AppStrings.linkedinUrl,
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.sm),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String id;
  final String label;
  final IconData icon;
  const _NavItem({required this.id, required this.label, required this.icon});
}

class _DrawerNavItem extends StatelessWidget {
  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _DrawerNavItem({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: AppDimensions.xs),
      decoration: BoxDecoration(
        color: isActive
            ? colors.primary.withValues(alpha: 0.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: isActive
            ? Border.all(color: colors.primary.withValues(alpha: 0.3))
            : null,
      ),
      child: ListTile(
        leading: Icon(
          item.icon,
          color: isActive ? colors.primary : colors.textSecondary,
          size: 20,
        ),
        title: Text(
          item.label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: isActive ? colors.primary : colors.textPrimary,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final String url;

  const _SocialIcon({required this.icon, required this.url});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return IconButton(
      icon: FaIcon(icon, size: 18, color: colors.textSecondary),
      onPressed: () {}, // url_launcher handled in social_links_row
    );
  }
}
