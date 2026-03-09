import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/platform_utils.dart';
import '../../core/controllers/hover_controller.dart';
import '../../services/navigation_service.dart';
import 'widgets/animated_tagline.dart';
import 'widgets/social_links_row.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  Future<void> _openResume() async {
    final uri = Uri.parse(AppStrings.resumeUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = PlatformUtils.instance.isDesktop(context);
    final size = MediaQuery.of(context).size;
    final colors = AppColors.instance;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: size.height),
      decoration: BoxDecoration(gradient: colors.heroGradient),
      child: Stack(
        children: [
          // ── Decorative blobs ─────────────────────────────────────────────
          const Positioned.fill(child: _DecorativeBlobs()),
          // ── Content ─────────────────────────────────────────────────────
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppDimensions.maxContentWidth,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: PlatformUtils.instance.horizontalPadding(
                      context,
                    ),
                    vertical: AppDimensions.navBarHeight + AppDimensions.xxl,
                  ),
                  child: isDesktop
                      ? _DesktopLayout(onDownloadCv: _openResume)
                      : _MobileLayout(onDownloadCv: _openResume),
                ),
              ),
            ),
          ),
          // ── Scroll indicator (web only) ──────────────────────────────────
          Positioned(bottom: 32, left: 0, right: 0, child: _ScrollIndicator()),
        ],
      ),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  final VoidCallback onDownloadCv;
  const _DesktopLayout({required this.onDownloadCv});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left — text content
        Expanded(flex: 6, child: _HeroText(onDownloadCv: onDownloadCv)),
        const SizedBox(width: AppDimensions.xxxl),
        // Right — avatar
        Expanded(flex: 4, child: _AvatarCard()),
      ],
    );
  }
}

// ── Mobile Layout ─────────────────────────────────────────────────────────────

class _MobileLayout extends StatelessWidget {
  final VoidCallback onDownloadCv;
  const _MobileLayout({required this.onDownloadCv});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AvatarCard(size: 200),
        const SizedBox(height: AppDimensions.xl),
        _HeroText(onDownloadCv: onDownloadCv, centered: true),
      ],
    );
  }
}

// ── Hero Text ─────────────────────────────────────────────────────────────────

class _HeroText extends StatelessWidget {
  final VoidCallback onDownloadCv;
  final bool centered;

  const _HeroText({required this.onDownloadCv, this.centered = false});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    final align = centered ? TextAlign.center : TextAlign.left;
    final axisAlign = centered
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: axisAlign,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Greeting ───────────────────────────────────────────────────────
        FadeInDown(
          duration: const Duration(milliseconds: 600),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.md,
              vertical: AppDimensions.xs,
            ),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              border: Border.all(color: colors.primary.withValues(alpha: 0.3)),
            ),
            child: Text(
              '👋 Hi, I\'m',
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: colors.primary),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.md),

        // ── Name ───────────────────────────────────────────────────────────
        FadeInDown(
          delay: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 600),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final fontSize = constraints.maxWidth > 600 ? 60.0 : 38.0;
              return ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [colors.textPrimary, colors.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(
                  AppStrings.name,
                  textAlign: align,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontSize: fontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppDimensions.md),

        // ── Animated tagline ───────────────────────────────────────────────
        FadeInDown(
          delay: const Duration(milliseconds: 400),
          duration: const Duration(milliseconds: 600),
          child: const AnimatedTagline(),
        ),
        const SizedBox(height: AppDimensions.lg),

        // ── Bio ────────────────────────────────────────────────────────────
        FadeInDown(
          delay: const Duration(milliseconds: 600),
          duration: const Duration(milliseconds: 600),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text(
              AppStrings.bio,
              textAlign: align,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.xl),

        // ── CTA Buttons ────────────────────────────────────────────────────
        FadeInUp(
          delay: const Duration(milliseconds: 800),
          duration: const Duration(milliseconds: 600),
          child: Wrap(
            spacing: AppDimensions.md,
            runSpacing: AppDimensions.md,
            alignment: centered ? WrapAlignment.center : WrapAlignment.start,
            children: [
              _GradientCTAButton(
                label: AppStrings.ctaHireMe,
                onTap: () =>
                    NavigationService.instance.scrollToSection('contact'),
              ),
              _OutlineCTAButton(
                label: AppStrings.ctaDownloadCV,
                onTap: onDownloadCv,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.xl),

        // ── Social links ───────────────────────────────────────────────────
        FadeInUp(
          delay: const Duration(milliseconds: 1000),
          duration: const Duration(milliseconds: 600),
          child: const SocialLinksRow(),
        ),
      ],
    );
  }
}

// ── Avatar Card ───────────────────────────────────────────────────────────────

class AvatarController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> floatAnimation;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    floatAnimation = Tween<double>(begin: 0, end: -18).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}

class _AvatarCard extends StatelessWidget {
  final double size;
  const _AvatarCard({this.size = 340});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    final controller = Get.put(AvatarController());

    return FadeInRight(
      duration: const Duration(milliseconds: 800),
      delay: const Duration(milliseconds: 300),
      child: AnimatedBuilder(
        animation: controller.floatAnimation,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, controller.floatAnimation.value),
          child: child,
        ),
        child: Center(
          child: SizedBox(
            width: size,
            height: size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer glow ring
                Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        colors.primary.withValues(alpha: 0.6),
                        colors.accent.withValues(alpha: 0.3),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                // Inner avatar container
                Container(
                  width: size - 12,
                  height: size - 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.surface,
                    border: Border.all(color: colors.border, width: 2),
                  ),
                  child: ClipOval(child: _AvatarContent(size: size - 12)),
                ),
                // Floating badge
                Positioned(
                  bottom: size * 0.1,
                  right: size * 0.05,
                  child: _StatusBadge(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shows initials avatar (replace with actual image when available).
class _AvatarContent extends StatelessWidget {
  final double size;
  const _AvatarContent({required this.size});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(gradient: colors.cardGradient),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Remove VP text as requested
          const SizedBox(height: 8),
          Text(
            AppStrings.profession,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: colors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.sm,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: colors.success,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppDimensions.xs),
          Text(
            'Available for hire',
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: colors.textPrimary),
          ),
        ],
      ),
    );
  }
}

// ── Decorative Blobs ──────────────────────────────────────────────────────────

class _DecorativeBlobs extends StatelessWidget {
  const _DecorativeBlobs();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colors = AppColors.instance;
    return Stack(
      children: [
        // Top-left blob
        Positioned(
          top: -100,
          left: -100,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  colors.primary.withValues(alpha: 0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Bottom-right blob
        Positioned(
          bottom: -80,
          right: -80,
          child: Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  colors.accent.withValues(alpha: 0.12),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Center subtle glow
        Positioned(
          top: size.height * 0.3,
          left: size.width * 0.4,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  colors.primary.withValues(alpha: 0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Scroll Indicator ──────────────────────────────────────────────────────────

class ScrollIndicatorController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController ctrl;
  late Animation<double> bounce;

  @override
  void onInit() {
    super.onInit();
    ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    bounce = Tween<double>(
      begin: 0,
      end: 10,
    ).animate(CurvedAnimation(parent: ctrl, curve: Curves.easeInOut));
  }

  @override
  void onClose() {
    ctrl.dispose();
    super.onClose();
  }
}

class _ScrollIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    final controller = Get.put(ScrollIndicatorController());

    return AnimatedBuilder(
      animation: controller.bounce,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, controller.bounce.value),
        child: Column(
          children: [
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: colors.textMuted,
              size: 28,
            ),
            Text(
              'Scroll to explore',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}

// ── CTA Buttons ───────────────────────────────────────────────────────────────

// ── CTA Buttons ───────────────────────────────────────────────────────────────

class _GradientCTAButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _GradientCTAButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    final controller = Get.put(
      HoverController(),
      tag: 'gradient_cta_${label.hashCode}',
    );

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
              horizontal: AppDimensions.xl,
              vertical: AppDimensions.md,
            ),
            decoration: BoxDecoration(
              gradient: colors.primaryGradient,
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              boxShadow: controller.isHovered
                  ? [
                      BoxShadow(
                        color: colors.primary.withValues(alpha: 0.5),
                        blurRadius: 25,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: colors.primary.withValues(alpha: 0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: AppDimensions.sm),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OutlineCTAButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _OutlineCTAButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    final controller = Get.put(
      HoverController(),
      tag: 'outline_cta_${label.hashCode}',
    );

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
              horizontal: AppDimensions.xl,
              vertical: AppDimensions.md,
            ),
            decoration: BoxDecoration(
              color: controller.isHovered
                  ? colors.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              border: Border.all(
                color: controller.isHovered ? colors.primary : colors.border,
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.download_rounded,
                  color: controller.isHovered
                      ? colors.primary
                      : colors.textSecondary,
                  size: 16,
                ),
                const SizedBox(width: AppDimensions.sm),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: controller.isHovered
                        ? colors.primary
                        : colors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
