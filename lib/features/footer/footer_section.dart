import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/platform_utils.dart';

class FooterController extends GetxController {
  Future<void> open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    final hPad = PlatformUtils.instance.horizontalPadding(context);
    final isDesktop = PlatformUtils.instance.isDesktop(context);
    final controller = Get.put(FooterController());

    return Container(
      decoration: BoxDecoration(
        color: colors.background,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppDimensions.maxContentWidth,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: hPad,
              vertical: AppDimensions.xl,
            ),
            child: isDesktop
                ? _DesktopFooter(onOpen: controller.open)
                : _MobileFooter(onOpen: controller.open),
          ),
        ),
      ),
    );
  }
}

class _DesktopFooter extends StatelessWidget {
  final Future<void> Function(String) onOpen;
  const _DesktopFooter({required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _LogoBlock(),
        const Spacer(),
        _SocialRow(onOpen: onOpen),
        const SizedBox(width: AppDimensions.xxxl),
        _CopyrightBlock(),
      ],
    );
  }
}

class _MobileFooter extends StatelessWidget {
  final Future<void> Function(String) onOpen;
  const _MobileFooter({required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _LogoBlock(),
        const SizedBox(height: AppDimensions.lg),
        _SocialRow(onOpen: onOpen),
        const SizedBox(height: AppDimensions.lg),
        _CopyrightBlock(),
      ],
    );
  }
}

class _LogoBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppStrings.footerMadeWith,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _SocialRow extends StatelessWidget {
  final Future<void> Function(String) onOpen;
  const _SocialRow({required this.onOpen});

  @override
  Widget build(BuildContext context) {
    final items = [
      (FontAwesomeIcons.github, AppStrings.githubUrl),
      (FontAwesomeIcons.linkedin, AppStrings.linkedinUrl),
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.sm),
          child: _FooterIconBtn(
            icon: item.$1,
            onTap: () => onOpen(item.$2),
            tag: item.$2,
          ),
        );
      }).toList(),
    );
  }
}

class FooterIconController extends GetxController {
  final _hovered = false.obs;
  bool get hovered => _hovered.value;
  set hovered(bool val) => _hovered.value = val;
}

class _FooterIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tag;
  const _FooterIconBtn({
    required this.icon,
    required this.onTap,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    final controller = Get.put(FooterIconController(), tag: tag);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => controller.hovered = true,
      onExit: (_) => controller.hovered = false,
      child: GestureDetector(
        onTap: onTap,
        child: Obx(
          () => AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(AppDimensions.sm + 4),
            decoration: BoxDecoration(
              color: controller.hovered
                  ? colors.primary.withValues(alpha: 0.15)
                  : colors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              border: Border.all(
                color: controller.hovered ? colors.primary : colors.border,
              ),
            ),
            child: FaIcon(
              icon,
              size: 16,
              color: controller.hovered ? colors.primary : colors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}

class _CopyrightBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      AppStrings.footerCopyright,
      style: Theme.of(context).textTheme.bodySmall,
      textAlign: TextAlign.center,
    );
  }
}
