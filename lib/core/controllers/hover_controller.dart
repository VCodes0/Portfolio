import 'package:get/get.dart';

class HoverController extends GetxController {
  final _isHovered = false.obs;
  bool get isHovered => _isHovered.value;
  set isHovered(bool value) => _isHovered.value = value;
}
