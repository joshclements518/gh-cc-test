import 'package:flutter/material.dart';
import 'app.dart';
import 'services/services.dart';
import 'state/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final services = HarborlineServices();
  await services.init(); // Initialize user identity from localStorage
  final state = AppState(services);
  runApp(HarborlineApp(state: state));
}
