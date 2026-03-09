class ProjectModel {
  final String id;
  final String title;
  final String description;
  final List<String> tags;
  final String? githubUrl;
  final String? liveUrl;
  final String? imageAsset;
  final bool isFeatured;

  const ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.tags,
    this.githubUrl,
    this.liveUrl,
    this.imageAsset,
    this.isFeatured = false,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      tags: List<String>.from(json['tags']),
      githubUrl: json['githubUrl'],
      liveUrl: json['liveUrl'],
      imageAsset: json['imageAsset'],
      isFeatured: json['isFeatured'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'tags': tags,
    'githubUrl': githubUrl,
    'liveUrl': liveUrl,
    'imageAsset': imageAsset,
    'isFeatured': isFeatured,
  };
}

class SkillModel {
  final String name;
  final double proficiency;
  final String category;
  final String? iconAsset;

  const SkillModel({
    required this.name,
    required this.proficiency,
    required this.category,
    this.iconAsset,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      name: json['name'],
      proficiency: json['proficiency'].toDouble(),
      category: json['category'],
      iconAsset: json['iconAsset'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'proficiency': proficiency,
    'category': category,
    'iconAsset': iconAsset,
  };
}

class ExperienceModel {
  final String company;
  final String role;
  final String duration;
  final String period;
  final String description;
  final List<String> achievements;
  final bool isCurrent;
  final DateTime? startDate;

  const ExperienceModel({
    required this.company,
    required this.role,
    required this.duration,
    required this.period,
    required this.description,
    required this.achievements,
    this.isCurrent = false,
    this.startDate,
  });

  String get calculatedDuration {
    if (isCurrent && startDate != null) {
      final now = DateTime.now();
      int months =
          (now.year - startDate!.year) * 12 + now.month - startDate!.month;
      if (now.day < startDate!.day) months--;

      if (months <= 0) return '1 mo';

      if (months < 12) {
        return '$months mo';
      } else {
        int years = months ~/ 12;
        int remainingMonths = months % 12;
        if (remainingMonths == 0) return '$years yr';
        return '$years yr $remainingMonths mo';
      }
    }
    return duration;
  }

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      company: json['company'],
      role: json['role'],
      duration: json['duration'],
      period: json['period'],
      description: json['description'],
      achievements: List<String>.from(json['achievements']),
      isCurrent: json['isCurrent'] ?? false,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'company': company,
    'role': role,
    'duration': duration,
    'period': period,
    'description': description,
    'achievements': achievements,
    'isCurrent': isCurrent,
    'startDate': startDate?.toIso8601String(),
  };
}
