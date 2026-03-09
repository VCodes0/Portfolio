import 'package:get/get.dart';
import '../logic/blocs/theme/theme_bloc.dart';
import '../logic/blocs/header/header_bloc.dart';
import '../logic/blocs/navigation/navigation_bloc.dart';
import '../services/api_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ThemeBloc(), permanent: true);
    Get.put(NavigationBloc(), permanent: true);
    Get.put(HeaderBloc(), permanent: true);
    Get.put(ApiService(), permanent: true);
  }
}
