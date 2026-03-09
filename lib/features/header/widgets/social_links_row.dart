import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/controllers/hover_controller.dart';

/// Row of social-link icon buttons (GitHub, LinkedIn, Twitter/X, Email).
class SocialLinksRow extends StatelessWidget {
  /// If true, icons are displayed in a column instead of a row.
  final bool vertical;
  final double iconSize;

  const SocialLinksRow({super.key, this.vertical = false, this.iconSize = 18});

  static final List<_SocialLink> _links = [
    _SocialLink(
      icon: FontAwesomeIcons.github,
      url: AppStrings.githubUrl,
      tooltip: 'GitHub',
    ),
    _SocialLink(
      icon: FontAwesomeIcons.linkedin,
      url: AppStrings.linkedinUrl,
      tooltip: 'LinkedIn',
    ),
    _SocialLink(
      icon: FontAwesomeIcons.envelope,
      url: 'mailto:${AppStrings.email}',
      tooltip: 'Email',
    ),
  ];

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final icons = _links
        .map(
          (link) => _SocialIconButton(
            link: link,
            iconSize: iconSize,
            onTap: () => _open(link.url),
          ),
        )
        .toList();

    if (vertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: icons
            .map(
              (w) => Padding(
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.xs),
                child: w,
              ),
            )
            .toList(),
      );
    }

    return Wrap(
      spacing: AppDimensions.sm,
      runSpacing: AppDimensions.sm,
      children: icons,
    );
  }
}

class _SocialLink {
  final IconData icon;
  final String url;
  final String tooltip;
  const _SocialLink({
    required this.icon,
    required this.url,
    required this.tooltip,
  });
}

class _SocialIconButton extends StatelessWidget {
  final _SocialLink link;
  final double iconSize;
  final VoidCallback onTap;

  const _SocialIconButton({
    required this.link,
    required this.iconSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    final controller = Get.put(
      HoverController(),
      tag: 'social_icon_${link.tooltip}_${link.icon.codePoint}',
    );

    return Tooltip(
      message: link.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => controller.isHovered = true,
        onExit: (_) => controller.isHovered = false,
        child: GestureDetector(
          onTap: onTap,
          child: Obx(
            () => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(AppDimensions.sm + 4),
              decoration: BoxDecoration(
                color: controller.isHovered
                    ? colors.primary.withValues(alpha: 0.2)
                    : colors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                border: Border.all(
                  color: controller.isHovered ? colors.primary : colors.border,
                ),
              ),
              child: FaIcon(
                link.icon,
                size: iconSize,
                color: controller.isHovered
                    ? colors.primary
                    : colors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
