import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import '../../services/api_service.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/platform_utils.dart';
import '../../core/controllers/hover_controller.dart';
import '../../data/models/portfolio_data.dart';
import '../../data/models/portfolio_models.dart';

class ProjectsController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final _visible = false.obs;
  bool get visible => _visible.value;
  void setVisible() => _visible.value = true;

  final projects = <ProjectModel>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProjects();
  }

  Future<void> fetchProjects() async {
    try {
      isLoading.value = true;
      final fetchedProjects = await _apiService.getProjects();
      projects.assignAll(fetchedProjects);
    } catch (e) {
      projects.assignAll(PortfolioData.instance.projects);
    } finally {
      isLoading.value = false;
    }
  }
}

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    final hPad = PlatformUtils.instance.horizontalPadding(context);
    final vPad = PlatformUtils.instance.verticalPadding(context);
    final controller = Get.put(ProjectsController());

    return VisibilityDetector(
      key: const Key('projects-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !controller.visible) {
          controller.setVisible();
        }
      },
      child: Container(
        color: colors.surfaceVariant,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppDimensions.maxContentWidth,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
              child: Obx(() {
                if (controller.isLoading.value && controller.projects.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                final projects = controller.projects;
                return Column(
                  children: [
                    _SectionHeader(
                      title: AppStrings.sectionProjects,
                      visible: controller.visible,
                    ),
                    const SizedBox(height: AppDimensions.xxxl),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final cols = constraints.maxWidth > 900
                            ? 3
                            : constraints.maxWidth > 600
                            ? 2
                            : 1;
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: cols,
                                crossAxisSpacing: AppDimensions.lg,
                                mainAxisSpacing: AppDimensions.lg,
                                childAspectRatio: cols == 1 ? 1.4 : 1.1,
                              ),
                          itemCount: projects.length,
                          itemBuilder: (context, index) => ProjectCard(
                            project: projects[index],
                            animationDelay: Duration(milliseconds: index * 120),
                            visible: controller.visible,
                          ),
                        );
                      },
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

class ProjectCardController extends GetxController {
  final _hovered = false.obs;
  bool get hovered => _hovered.value;
  set hovered(bool val) => _hovered.value = val;

  Future<void> open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final Duration animationDelay;
  final bool visible;

  const ProjectCard({
    super.key,
    required this.project,
    required this.animationDelay,
    required this.visible,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    final controller = Get.put(ProjectCardController(), tag: project.title);

    if (!visible) return const SizedBox();

    return FadeInUp(
      delay: animationDelay,
      duration: const Duration(milliseconds: 600),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => controller.hovered = true,
        onExit: (_) => controller.hovered = false,
        child: Obx(
          () => AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            transform: controller.hovered
                ? Matrix4.translationValues(0.0, -6.0, 0.0)
                : Matrix4.identity(),
            decoration: BoxDecoration(
              gradient: colors.cardGradient,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              border: Border.all(
                color: controller.hovered
                    ? colors.primary.withValues(alpha: 0.6)
                    : colors.border,
              ),
              boxShadow: controller.hovered
                  ? [
                      BoxShadow(
                        color: colors.primary.withValues(alpha: 0.2),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ]
                  : [],
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header row ──────────────────────────────────────────────
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppDimensions.sm),
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusMd,
                          ),
                        ),
                        child: FaIcon(
                          FontAwesomeIcons.code,
                          size: 16,
                          color: colors.primary,
                        ),
                      ),
                      if (project.isFeatured) ...[
                        const SizedBox(width: AppDimensions.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.sm,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colors.accent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusFull,
                            ),
                            border: Border.all(
                              color: colors.accent.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Text(
                            '⭐ Featured',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(color: colors.accent),
                          ),
                        ),
                      ],
                      const Spacer(),
                      // Links
                      if (project.githubUrl != null)
                        _LinkIconBtn(
                          icon: FontAwesomeIcons.github,
                          onTap: () => controller.open(project.githubUrl!),
                          tooltip: 'GitHub',
                        ),
                      if (project.liveUrl != null) ...[
                        const SizedBox(width: AppDimensions.xs),
                        _LinkIconBtn(
                          icon: FontAwesomeIcons.arrowUpRightFromSquare,
                          onTap: () => controller.open(project.liveUrl!),
                          tooltip: 'Live Demo',
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppDimensions.md),

                  // ── Title ────────────────────────────────────────────────────
                  Text(
                    project.title,
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimensions.sm),

                  // ── Description ──────────────────────────────────────────────
                  Expanded(
                    child: Text(
                      project.description,
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.md),

                  // ── Tags ─────────────────────────────────────────────────────
                  Wrap(
                    spacing: AppDimensions.xs,
                    runSpacing: AppDimensions.xs,
                    children: project.tags
                        .map(
                          (tag) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.sm,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusFull,
                              ),
                              border: Border.all(
                                color: colors.primary.withValues(alpha: 0.25),
                              ),
                            ),
                            child: Text(
                              tag,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(color: colors.primaryLight),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LinkIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  const _LinkIconBtn({
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    final controller = Get.put(
      HoverController(),
      tag: 'link_btn_${icon.codePoint}_${tooltip.hashCode}',
    );

    return Tooltip(
      message: tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => controller.isHovered = true,
        onExit: (_) => controller.isHovered = false,
        child: GestureDetector(
          onTap: onTap,
          child: Obx(
            () => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(AppDimensions.sm),
              decoration: BoxDecoration(
                color: controller.isHovered
                    ? colors.primary.withValues(alpha: 0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: FaIcon(
                icon,
                size: 14,
                color: controller.isHovered ? colors.primary : colors.textMuted,
              ),
            ),
          ),
        ),
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
