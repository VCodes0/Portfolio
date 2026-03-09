import 'package:flutter/material.dart';
import 'app/app_bindings.dart';
import 'app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppBindings().dependencies();
  runApp(const PortfolioApp());
}
