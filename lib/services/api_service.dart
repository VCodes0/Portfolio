import 'package:get/get.dart';
import '../data/models/portfolio_models.dart';

class ApiService extends GetConnect {
  @override
  void onInit() {
    // Current local port for FastAPI
    baseUrl = 'http://localhost:8000';

    // Add default headers if needed
    httpClient.timeout = const Duration(seconds: 10);

    super.onInit();
  }

  Future<List<ProjectModel>> getProjects() async {
    final response = await get('/projects');
    if (response.status.hasError) {
      return Future.error(response.statusText ?? 'Error fetching projects');
    }
    final List<dynamic> data = response.body;
    return data.map((json) => ProjectModel.fromJson(json)).toList();
  }

  Future<List<SkillModel>> getSkills() async {
    final response = await get('/skills');
    if (response.status.hasError) {
      return Future.error(response.statusText ?? 'Error fetching skills');
    }
    final List<dynamic> data = response.body;
    return data.map((json) => SkillModel.fromJson(json)).toList();
  }

  Future<List<ExperienceModel>> getExperience() async {
    final response = await get('/experience');
    if (response.status.hasError) {
      return Future.error(response.statusText ?? 'Error fetching experience');
    }
    final List<dynamic> data = response.body;
    return data.map((json) => ExperienceModel.fromJson(json)).toList();
  }

  Future<List<String>> getTechChips() async {
    final response = await get('/tech-chips');
    if (response.status.hasError) {
      return Future.error(response.statusText ?? 'Error fetching tech chips');
    }
    return List<String>.from(response.body);
  }

  Future<bool> sendContactMessage(Map<String, dynamic> data) async {
    final response = await post('/contact', data);
    return response.status.isOk;
  }
}
