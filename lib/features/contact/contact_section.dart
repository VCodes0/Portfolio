import 'package:get/get.dart';
import '../../services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/platform_utils.dart';
import '../../core/controllers/hover_controller.dart';

class ContactController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final _visible = false.obs;
  bool get visible => _visible.value;
  void setVisible() => _visible.value = true;

  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final subjectCtrl = TextEditingController();
  final messageCtrl = TextEditingController();

  final _sending = false.obs;
  bool get sending => _sending.value;

  final _sent = false.obs;
  bool get sent => _sent.value;

  Future<void> sendMessage() async {
    if (!formKey.currentState!.validate()) return;
    try {
      _sending.value = true;
      final success = await _apiService.sendContactMessage({
        'name': nameCtrl.text,
        'email': emailCtrl.text,
        'subject': subjectCtrl.text,
        'message': messageCtrl.text,
      });
      if (success) {
        _sent.value = true;
      } else {
        Get.snackbar(
          'Error',
          'Failed to send message. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          colorText: Colors.red,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    } finally {
      _sending.value = false;
    }
  }

  Future<void> open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    subjectCtrl.dispose();
    messageCtrl.dispose();
    super.onClose();
  }
}

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    final hPad = PlatformUtils.instance.horizontalPadding(context);
    final vPad = PlatformUtils.instance.verticalPadding(context);
    final isDesktop = PlatformUtils.instance.isDesktop(context);
    final controller = Get.put(ContactController());

    return VisibilityDetector(
      key: const Key('contact-section'),
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
              child: Obx(
                () => Column(
                  children: [
                    _SectionHeader(
                      title: AppStrings.sectionContact,
                      visible: controller.visible,
                    ),
                    const SizedBox(height: AppDimensions.xxxl),
                    if (controller.visible)
                      isDesktop
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: _ContactInfo(onOpen: controller.open),
                                ),
                                const SizedBox(width: AppDimensions.xxxl),
                                Expanded(
                                  flex: 6,
                                  child: _ContactForm(controller: controller),
                                ),
                              ],
                            )
                          : SingleChildScrollView(
                              child: Column(
                                children: [
                                  _ContactInfo(onOpen: controller.open),
                                  const SizedBox(height: AppDimensions.xl),
                                  _ContactForm(controller: controller),
                                ],
                              ),
                            ),
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

class _ContactInfo extends StatelessWidget {
  final Future<void> Function(String) onOpen;
  const _ContactInfo({required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      duration: const Duration(milliseconds: 700),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Let's work together",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppDimensions.md),
          Text(
            "I'm always open to new opportunities, collaborations, and exciting projects. "
            "Feel free to reach out — I'd love to hear from you!",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: AppDimensions.xl),
          _ContactItem(
            icon: Icons.email_outlined,
            title: 'Email',
            value: AppStrings.email,
            onTap: () => onOpen('mailto:${AppStrings.email}'),
          ),
          const SizedBox(height: AppDimensions.md),
          _ContactItem(
            icon: Icons.location_on_outlined,
            title: 'Location',
            value: AppStrings.location,
            onTap: null,
          ),
          const SizedBox(height: AppDimensions.xl),
          Text('Find me on', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: AppDimensions.md),
          Row(
            children: [
              _SocialBtn(
                icon: FontAwesomeIcons.github,
                label: 'GitHub',
                onTap: () => onOpen(AppStrings.githubUrl),
              ),
              const SizedBox(width: AppDimensions.md),
              _SocialBtn(
                icon: FontAwesomeIcons.linkedin,
                label: 'LinkedIn',
                onTap: () => onOpen(AppStrings.linkedinUrl),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  const _ContactItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.sm + 4),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Icon(icon, color: colors.primary, size: 20),
          ),
          const SizedBox(width: AppDimensions.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.labelSmall),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  decoration: onTap != null ? TextDecoration.underline : null,
                  decorationColor: colors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SocialBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SocialBtn({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    final controller = Get.put(HoverController(), tag: 'social_btn_$label');

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
              horizontal: AppDimensions.md,
              vertical: AppDimensions.sm,
            ),
            decoration: BoxDecoration(
              color: controller.isHovered
                  ? colors.primary.withValues(alpha: 0.15)
                  : colors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              border: Border.all(
                color: controller.isHovered ? colors.primary : colors.border,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  icon,
                  size: 14,
                  color: controller.isHovered
                      ? colors.primary
                      : colors.textSecondary,
                ),
                const SizedBox(width: AppDimensions.xs),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: controller.isHovered
                        ? colors.primary
                        : colors.textSecondary,
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

class _ContactForm extends StatelessWidget {
  final ContactController controller;

  const _ContactForm({required this.controller});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;

    return Obx(() {
      if (controller.sent) {
        return FadeIn(
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.xl),
            decoration: BoxDecoration(
              color: colors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              border: Border.all(color: colors.success.withValues(alpha: 0.4)),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  color: colors.success,
                  size: 64,
                ),
                const SizedBox(height: AppDimensions.md),
                Text(
                  'Message sent!',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppDimensions.sm),
                Text(
                  "Thanks for reaching out! I'll get back to you soon.",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }

      return FadeInRight(
        duration: const Duration(milliseconds: 700),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _Field(
                      ctrl: controller.nameCtrl,
                      hint: AppStrings.contactNameHint,
                      validator: (v) =>
                          (v?.isEmpty ?? true) ? 'Enter your name' : null,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.md),
                  Expanded(
                    child: _Field(
                      ctrl: controller.emailCtrl,
                      hint: AppStrings.contactEmailHint,
                      validator: (v) {
                        if (v?.isEmpty ?? true) return 'Enter your email';
                        if (!v!.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.md),
              _Field(
                ctrl: controller.subjectCtrl,
                hint: AppStrings.contactSubjectHint,
                validator: (v) =>
                    (v?.isEmpty ?? true) ? 'Enter a subject' : null,
              ),
              const SizedBox(height: AppDimensions.md),
              _Field(
                ctrl: controller.messageCtrl,
                hint: AppStrings.contactMessageHint,
                maxLines: 5,
                validator: (v) =>
                    (v?.isEmpty ?? true) ? 'Enter a message' : null,
              ),
              const SizedBox(height: AppDimensions.xl),
              SizedBox(
                width: double.infinity,
                child: _SendButton(
                  sending: controller.sending,
                  onTap: controller.sendMessage,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _Field extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  final int maxLines;
  final String? Function(String?)? validator;

  const _Field({
    required this.ctrl,
    required this.hint,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      validator: validator,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(hintText: hint),
    );
  }
}

class _SendButton extends StatelessWidget {
  final bool sending;
  final VoidCallback onTap;

  const _SendButton({required this.sending, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    final controller = Get.put(HoverController(), tag: 'send_button');

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => controller.isHovered = true,
      onExit: (_) => controller.isHovered = false,
      child: GestureDetector(
        onTap: sending ? null : onTap,
        child: Obx(
          () => AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: AppDimensions.md),
            decoration: BoxDecoration(
              gradient: AppColors.instance.primaryGradient,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              boxShadow: controller.isHovered && !sending
                  ? [
                      BoxShadow(
                        color: colors.primary.withValues(alpha: 0.4),
                        blurRadius: 20,
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: sending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppStrings.ctaSendMessage,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(width: AppDimensions.sm),
                        const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 16,
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
