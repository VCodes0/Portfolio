import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/controllers/hover_controller.dart';
import '../../core/utils/platform_utils.dart';
import '../../data/models/portfolio_data.dart';

import 'package:get/get.dart';
import '../../services/api_service.dart';

class AboutController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final _visible = false.obs;
  bool get visible => _visible.value;
  void setVisible() => _visible.value = true;

  final techChips = <String>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTechChips();
  }

  Future<void> fetchTechChips() async {
    try {
      isLoading.value = true;
      final chips = await _apiService.getTechChips();
      techChips.assignAll(chips);
    } catch (e) {
      techChips.assignAll(PortfolioData.instance.techChips);
    } finally {
      isLoading.value = false;
    }
  }
}

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    final isDesktop = PlatformUtils.instance.isDesktop(context);
    final hPad = PlatformUtils.instance.horizontalPadding(context);
    final vPad = PlatformUtils.instance.verticalPadding(context);
    final controller = Get.put(AboutController());

    return VisibilityDetector(
      key: const Key('about-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.15 && !controller.visible) {
          controller.setVisible();
        }
      },
      child: Container(
        decoration: BoxDecoration(color: colors.surfaceVariant),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppDimensions.maxContentWidth,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
              child: Obx(
                () => Column(
                  children: [
                    _SectionHeader(
                      title: AppStrings.sectionAbout,
                      visible: controller.visible,
                    ),
                    const SizedBox(height: AppDimensions.xxxl),
                    isDesktop
                        ? _DesktopAbout(visible: controller.visible)
                        : _MobileAbout(visible: controller.visible),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DesktopAbout extends StatelessWidget {
  final bool visible;
  const _DesktopAbout({required this.visible});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 4, child: _AboutAvatar(visible: visible)),
        const SizedBox(width: AppDimensions.xxxl),
        Expanded(flex: 6, child: _AboutText(visible: visible)),
      ],
    );
  }
}

class _MobileAbout extends StatelessWidget {
  final bool visible;
  const _MobileAbout({required this.visible});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AboutAvatar(visible: visible, size: 180),
        const SizedBox(height: AppDimensions.xl),
        _AboutText(visible: visible),
      ],
    );
  }
}

class _AboutAvatar extends StatelessWidget {
  final bool visible;
  final double size;
  const _AboutAvatar({required this.visible, this.size = 280});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    if (!visible) return const SizedBox();
    return FadeInLeft(
      duration: const Duration(milliseconds: 700),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Decorative border
            Container(
              width: size + 20,
              height: size + 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimensions.radiusXl + 8),
                gradient: LinearGradient(
                  colors: [colors.primary, colors.accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                gradient: colors.cardGradient,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Removed VP text
                ],
              ),
            ),
            // Stats badge
            Positioned(
              bottom: 0,
              right: 0,
              child: _StatBadge(years: '3+', label: 'Years Exp.'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String years;
  final String label;
  const _StatBadge({required this.years, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.2),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ShaderMask(
            shaderCallback: (b) => colors.primaryGradient.createShader(b),
            child: Text(
              years,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _AboutText extends StatelessWidget {
  final bool visible;
  const _AboutText({required this.visible});

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox();

    final controller = Get.find<AboutController>();

    return Obx(() {
      if (controller.isLoading.value && controller.techChips.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      final chips = controller.techChips;
      return FadeInRight(
        duration: const Duration(milliseconds: 700),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Passionate about building exceptional digital experiences',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppDimensions.lg),
            Text(AppStrings.bio, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: AppDimensions.md),
            Text(
              AppStrings.bioExtended,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppDimensions.xl),
            // ── Info grid ────────────────────────────────────────────────────
            Wrap(
              spacing: AppDimensions.lg,
              runSpacing: AppDimensions.md,
              children: [
                _InfoRow(
                  icon: Icons.location_on_outlined,
                  text: AppStrings.location,
                ),
                _InfoRow(icon: Icons.email_outlined, text: AppStrings.email),
                _InfoRow(
                  icon: Icons.work_outline_rounded,
                  text: AppStrings.profession,
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.xl),
            // ── Tech chips ────────────────────────────────────────────────────
            Text('Tech Stack', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppDimensions.md),
            Wrap(
              spacing: AppDimensions.sm,
              runSpacing: AppDimensions.sm,
              children: chips.map((chip) => _TechChip(label: chip)).toList(),
            ),
          ],
        ),
      );
    });
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: colors.primary),
        const SizedBox(width: AppDimensions.sm),
        Text(text, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class _TechChip extends StatelessWidget {
  final String label;
  const _TechChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    final controller = Get.put(HoverController(), tag: 'tech_chip_$label');

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => controller.isHovered = true,
      onExit: (_) => controller.isHovered = false,
      child: Obx(
        () => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.md,
            vertical: AppDimensions.sm,
          ),
          decoration: BoxDecoration(
            color: controller.isHovered
                ? colors.primary.withValues(alpha: 0.15)
                : colors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            border: Border.all(
              color: controller.isHovered ? colors.primary : colors.border,
            ),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: controller.isHovered
                  ? colors.primary
                  : colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

/// Reusable section header with title + gradient underline
class _SectionHeader extends StatelessWidget {
  final String title;
  final bool visible;
  const _SectionHeader({required this.title, required this.visible});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    if (!visible) return const SizedBox(height: 60);
    return FadeInDown(
      duration: const Duration(milliseconds: 600),
      child: Column(
        children: [
          Text(title, style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: AppDimensions.md),
          Container(
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              gradient: colors.primaryGradient,
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            ),
          ),
        ],
      ),
    );
  }
}
