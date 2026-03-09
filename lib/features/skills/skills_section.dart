import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:get/get.dart';
import '../../services/api_service.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/controllers/hover_controller.dart';
import '../../core/utils/platform_utils.dart';
import '../../data/models/portfolio_data.dart';
import '../../data/models/portfolio_models.dart';

class SkillsController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final _visible = false.obs;
  bool get visible => _visible.value;
  void setVisible() => _visible.value = true;

  final skills = <SkillModel>[].obs;
  final isLoading = true.obs;
  final _selectedCategory = ''.obs;
  String get selectedCategory => _selectedCategory.value;
  set selectedCategory(String val) => _selectedCategory.value = val;

  List<String> get skillCategories =>
      skills.map((s) => s.category).toSet().toList();

  @override
  void onInit() {
    super.onInit();
    fetchSkills();
  }

  Future<void> fetchSkills() async {
    try {
      isLoading.value = true;
      final fetchedSkills = await _apiService.getSkills();
      skills.assignAll(fetchedSkills);
      if (skillCategories.isNotEmpty && selectedCategory.isEmpty) {
        selectedCategory = skillCategories.first;
      }
    } catch (e) {
      skills.assignAll(PortfolioData.instance.skills);
      if (selectedCategory.isEmpty) {
        selectedCategory = skillCategories.first;
      }
    } finally {
      isLoading.value = false;
    }
  }
}

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    final hPad = PlatformUtils.instance.horizontalPadding(context);
    final vPad = PlatformUtils.instance.verticalPadding(context);
    final controller = Get.put(SkillsController());

    return VisibilityDetector(
      key: const Key('skills-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.15 && !controller.visible) {
          controller.setVisible();
        }
      },
      child: Container(
        color: colors.background,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppDimensions.maxContentWidth,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
              child: Obx(() {
                if (controller.isLoading.value && controller.skills.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                final categories = controller.skillCategories;
                final filteredSkills = controller.skills
                    .where((s) => s.category == controller.selectedCategory)
                    .toList();

                return Column(
                  children: [
                    _SectionHeader(
                      title: AppStrings.sectionSkills,
                      visible: controller.visible,
                    ),
                    const SizedBox(height: AppDimensions.xl),
                    if (controller.visible)
                      FadeInDown(
                        duration: const Duration(milliseconds: 600),
                        child: Wrap(
                          spacing: AppDimensions.sm,
                          runSpacing: AppDimensions.sm,
                          alignment: WrapAlignment.center,
                          children: categories
                              .map(
                                (cat) => _CategoryTab(
                                  label: cat,
                                  isActive: controller.selectedCategory == cat,
                                  onTap: () =>
                                      controller.selectedCategory = cat,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    const SizedBox(height: AppDimensions.xxxl),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final cols = constraints.maxWidth > 600 ? 2 : 1;
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: cols,
                                crossAxisSpacing: AppDimensions.lg,
                                mainAxisSpacing: AppDimensions.lg,
                                childAspectRatio: cols == 2 ? 3.2 : 3.8,
                              ),
                          itemCount: filteredSkills.length,
                          itemBuilder: (context, index) => SkillCard(
                            skill: filteredSkills[index],
                            animationDelay: Duration(milliseconds: index * 100),
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

class _CategoryTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _CategoryTab({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    final controller = Get.put(HoverController(), tag: 'category_tab_$label');

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => controller.isHovered = true,
      onExit: (_) => controller.isHovered = false,
      child: GestureDetector(
        onTap: onTap,
        child: Obx(() {
          controller.isHovered; // Access to ensure subscription
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.lg,
              vertical: AppDimensions.sm + 4,
            ),
            decoration: BoxDecoration(
              gradient: isActive ? colors.primaryGradient : null,
              color: !isActive
                  ? (controller.isHovered
                        ? colors.primary.withValues(alpha: 0.1)
                        : colors.surface)
                  : null,
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              border: Border.all(
                color: isActive || controller.isHovered
                    ? colors.primary
                    : colors.border,
              ),
            ),
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: isActive
                    ? Colors.white
                    : (controller.isHovered
                          ? colors.primary
                          : colors.textSecondary),
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ── Reusable skill card (also used in skills/widgets/) ──────────────────────

class SkillCardController extends GetxController {
  final isHovered = false.obs;
}

class SkillCard extends StatelessWidget {
  final SkillModel skill;
  final Duration animationDelay;
  final bool visible;

  const SkillCard({
    super.key,
    required this.skill,
    required this.animationDelay,
    required this.visible,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    final percentage = (skill.proficiency * 100).toInt();
    final controller = Get.put(
      SkillCardController(),
      tag: 'skill_${skill.name}',
    );

    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) => controller.isHovered.value = true,
      onExit: (_) => controller.isHovered.value = false,
      child: Obx(
        () => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(AppDimensions.lg),
          decoration: BoxDecoration(
            color: controller.isHovered.value
                ? colors.surfaceHover
                : colors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(
              color: controller.isHovered.value
                  ? colors.primary.withValues(alpha: 0.5)
                  : colors.border,
            ),
            boxShadow: controller.isHovered.value
                ? [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: 0.1),
                      blurRadius: 20,
                    ),
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    skill.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '$percentage%',
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge?.copyWith(color: colors.primary),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.md),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        Container(
                          height: 8,
                          width: double.infinity,
                          color: colors.border,
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.easeOutCubic,
                          width: visible
                              ? constraints.maxWidth * skill.proficiency
                              : 0,
                          height: 8,
                          decoration: BoxDecoration(
                            gradient: colors.primaryGradient,
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusFull,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
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
