import 'portfolio_models.dart';

class PortfolioData {
  PortfolioData._();
  static final PortfolioData instance = PortfolioData._();

  List<ProjectModel> get projects => const [
    ProjectModel(
      id: 'proj_1',
      title: 'Flutter Perplexity Clone',
      description:
          'A full-stack AI-powered search app built with Flutter frontend '
          'and FastAPI backend, integrating Google Gemini API for intelligent '
          'responses with real-time streaming.',
      tags: ['Flutter', 'FastAPI', 'Gemini AI', 'GetX', 'Python'],
      githubUrl: 'https://github.com/VCodes0/Perplexity-Clone',
      isFeatured: true,
    ),
    ProjectModel(
      id: 'proj_2',
      title: 'Habit Tracker',
      description:
          'A complete habit-tracking application designed to help users build '
          'and maintain positive routines with a clean, intuitive UI and '
          'motivational progress tracking.',
      tags: ['Flutter', 'GetX', 'Local Storage', 'Animations'],
      githubUrl: 'https://github.com/VCodes0/Habit-Tracker',
      isFeatured: true,
    ),
    ProjectModel(
      id: 'proj_3',
      title: 'Modern Timer App',
      description:
          'A feature-rich timer application with countdown, stopwatch, '
          'and interval modes. Built with smooth animations and professional-grade '
          'microinteractions.',
      tags: ['Flutter', 'Animation', 'Timer', 'Clean UI'],
      githubUrl: 'https://github.com/VCodes0/Morden-Timer-App',
      isFeatured: true,
    ),
    ProjectModel(
      id: 'proj_4',
      title: 'Cross-Platform Weather App',
      description:
          'A beautifully designed weather application with live forecasts, '
          'animated weather conditions, and location-based data. Runs natively '
          'on Android, iOS, and Web.',
      tags: ['Flutter', 'REST API', 'Bloc', 'OpenWeather'],
      githubUrl: 'https://github.com/VCodes0/WeatherApp',
      isFeatured: true,
    ),
    ProjectModel(
      id: 'proj_5',
      title: 'SmartCard Scanner',
      description:
          'A business card scanner application using QR codes and OCR '
          'technology, built with Flutter and BLoC for efficient networking.',
      tags: ['Flutter', 'BLoC', 'QR Scanner', 'OCR'],
      githubUrl:
          'https://github.com/VCodes0/SmartCard-Scanner-QR-Business-Card-Scanner-Flutter-BLoC-',
    ),
    ProjectModel(
      id: 'proj_6',
      title: 'RazorPay Integration',
      description:
          'A complete implementation of RazorPay payment gateway in Flutter, '
          'featuring secure transactions and professional checkout flow.',
      tags: ['Flutter', 'Payments', 'RazorPay', 'Checkout'],
      githubUrl: 'https://github.com/VCodes0/RazorPay-Payment-Gatway-Flutter-',
    ),
  ];

  List<SkillModel> get skills => const [
    SkillModel(name: 'Flutter', proficiency: 0.95, category: 'Mobile'),
    SkillModel(name: 'Dart', proficiency: 0.95, category: 'Mobile'),
    SkillModel(name: 'GetX', proficiency: 0.90, category: 'Mobile'),
    SkillModel(name: 'Bloc / Cubit', proficiency: 0.85, category: 'Mobile'),
    SkillModel(name: 'Riverpod', proficiency: 0.75, category: 'Mobile'),
    SkillModel(name: 'Firebase', proficiency: 0.85, category: 'Backend'),
    SkillModel(name: 'Git & GitHub', proficiency: 0.90, category: 'Tools'),
    SkillModel(
      name: 'CI/CD (GitHub Actions)',
      proficiency: 0.70,
      category: 'Tools',
    ),
    SkillModel(name: 'Android Studio', proficiency: 0.88, category: 'Tools'),
    SkillModel(name: 'VS Code', proficiency: 0.95, category: 'Tools'),
    SkillModel(name: 'Linux', proficiency: 0.60, category: 'Tools'),
  ];

  List<String> get skillCategories =>
      skills.map((s) => s.category).toSet().toList();

  List<ExperienceModel> get experiences => [
    ExperienceModel(
      company: 'Vishleshan AI Softwares Solutions Pvt. Ltd.',
      role: 'Junior Flutter Developer',
      duration: '5 mo',
      period: 'Jul 2024 – Present',
      startDate: DateTime(2025, 7, 1),
      description:
          'Leading the mobile development team in building cross-platform '
          'applications serving 100K+ users. Architected a shared design system '
          'used across 4 products.',
      achievements: [
        'Reduced app launch time by 40% through lazy loading.',
        'Introduced GetX-based architecture, halving boilerplate.',
        'Delivered Flutter Web version with responsive_framework.',
        'Mentored 3 junior developers on clean architecture.',
      ],
      isCurrent: true,
    ),
    ExperienceModel(
      company: 'Try-Catch Classes',
      role: 'Flutter Developer',
      duration: '8 mo',
      period: 'Feb 2025 – Sept 2024',
      description:
          'Developed and maintained multiple client-facing applications, '
          'collaborating closely with designers and backend engineers to '
          'deliver high-quality products on tight schedules.',
      achievements: [
        'Built 5 apps from scratch to production deployment.',
        'Integrated Firebase Auth, Firestore, and FCM across all projects.',
        'Improved test coverage from 20% to 75% using flutter_test.',
        'Implemented custom animations increasing user retention by 25%.',
      ],
    ),
  ];

  List<String> get techChips => const [
    'Flutter',
    'Dart',
    'Firebase',
    'Python',
    'GetX',
    'Provider',
    'Bloc / Cubit',
    'REST APIs',
    'Git',
    'RiverPod',
    'Java',
  ];
}
