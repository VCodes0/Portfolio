import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'package:animate_do/animate_do.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/platform_utils.dart';
import '../../data/models/portfolio_data.dart';
import '../../data/models/portfolio_models.dart';

class ExperienceController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final _visible = false.obs;
  bool get visible => _visible.value;
  void setVisible() => _visible.value = true;

  final experiences = <ExperienceModel>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchExperience();
  }

  Future<void> fetchExperience() async {
    try {
      isLoading.value = true;
      final fetchedExp = await _apiService.getExperience();
      experiences.assignAll(fetchedExp);
    } catch (e) {
      experiences.assignAll(PortfolioData.instance.experiences);
    } finally {
      isLoading.value = false;
    }
  }
}

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    final hPad = PlatformUtils.instance.horizontalPadding(context);
    final vPad = PlatformUtils.instance.verticalPadding(context);
    final controller = Get.put(ExperienceController());

    return VisibilityDetector(
      key: const Key('experience-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !controller.visible) {
          controller.setVisible();
        }
      },
      child: Container(
        color: colors.background,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppDimensions.maxContentWidthNarrow,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
              child: Obx(() {
                if (controller.isLoading.value &&
                    controller.experiences.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                final experiences = controller.experiences;
                return Column(
                  children: [
                    _SectionHeader(
                      title: AppStrings.sectionExperience,
                      visible: controller.visible,
                    ),
                    const SizedBox(height: AppDimensions.xxxl),
                    ...experiences.asMap().entries.map(
                      (entry) => _TimelineItem(
                        experience: entry.value,
                        index: entry.key,
                        isLast: entry.key == experiences.length - 1,
                        visible: controller.visible,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class TimelineItemController extends GetxController {
  final _expanded = false.obs;
  bool get expanded => _expanded.value;
  void toggle() => _expanded.value = !_expanded.value;
}

class _TimelineItem extends StatelessWidget {
  final ExperienceModel experience;
  final int index;
  final bool isLast;
  final bool visible;

  const _TimelineItem({
    required this.experience,
    required this.index,
    required this.isLast,
    required this.visible,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    final controller = Get.put(
      TimelineItemController(),
      tag: experience.company,
    );

    if (!visible) return const SizedBox();

    return FadeInUp(
      delay: Duration(milliseconds: index * 200),
      duration: const Duration(milliseconds: 700),
      child: Stack(
        children: [
          // ── Timeline spine ───────────────────────────────────────────────
          if (!isLast)
            Positioned(
              left: 23, // (48 / 2) - 1
              top: 40,
              bottom: 0,
              child: Container(width: 2, color: colors.border),
            ),

          // Dot
          Positioned(
            left: 14, // (48 / 2) - 10
            top: 18,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: experience.isCurrent ? colors.primaryGradient : null,
                color: !experience.isCurrent ? colors.surface : null,
                border: Border.all(
                  color: experience.isCurrent
                      ? colors.primary.withValues(alpha: 0.5)
                      : colors.border,
                  width: 2,
                ),
                boxShadow: experience.isCurrent
                    ? [
                        BoxShadow(
                          color: colors.primary.withValues(alpha: 0.3),
                          blurRadius: 10,
                        ),
                      ]
                    : [],
              ),
              child: experience.isCurrent
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ),

          // ── Content card ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(left: 48, bottom: AppDimensions.xl),
            child: GestureDetector(
              onTap: () => controller.toggle(),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Obx(
                  () => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(AppDimensions.lg),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusLg,
                      ),
                      border: Border.all(
                        color: experience.isCurrent
                            ? colors.primary.withValues(alpha: 0.5)
                            : colors.border,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (experience.isCurrent)
                                    Container(
                                      margin: const EdgeInsets.only(
                                        bottom: AppDimensions.xs,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppDimensions.sm,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colors.success.withValues(
                                          alpha: 0.15,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          AppDimensions.radiusFull,
                                        ),
                                        border: Border.all(
                                          color: colors.success.withValues(
                                            alpha: 0.4,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        '● Current',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(color: colors.success),
                                      ),
                                    ),
                                  Text(
                                    experience.role,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 2),
                                  ShaderMask(
                                    shaderCallback: (b) =>
                                        colors.primaryGradient.createShader(b),
                                    child: Text(
                                      experience.company,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  experience.period,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelMedium,
                                ),
                                Text(
                                  experience.calculatedDuration,
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.md),
                        Text(
                          experience.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        // Achievements (expandable)
                        AnimatedCrossFade(
                          firstChild: const SizedBox.shrink(),
                          secondChild: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: AppDimensions.md),
                              Divider(color: colors.border),
                              const SizedBox(height: AppDimensions.sm),
                              Text(
                                'Key Achievements',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: AppDimensions.sm),
                              ...experience.achievements.map(
                                (a) => Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: AppDimensions.sm,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                          top: 6,
                                          right: 8,
                                        ),
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: colors.primary,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          a,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          crossFadeState: controller.expanded
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 300),
                        ),
                        const SizedBox(height: AppDimensions.sm),
                        // Expand toggle
                        Align(
                          alignment: Alignment.centerRight,
                          child: AnimatedRotation(
                            turns: controller.expanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 300),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: colors.textMuted,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
