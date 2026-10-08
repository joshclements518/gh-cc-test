import 'package:flutter/material.dart';
import 'app.dart';
import 'services/services.dart';
import 'state/app_state.dart';

/// Main entry point for the Harborline application.
/// Initializes services and application state before running the app.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final services = HarborlineServices();
  final state = AppState(services);
  runApp(HarborlineApp(state: state));
}
