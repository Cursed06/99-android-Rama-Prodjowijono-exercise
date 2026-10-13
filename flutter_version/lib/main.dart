import 'package:flutter/material.dart';
import 'app.dart';
import 'di/service_locator.dart';

/// Entry point of the Flutter application.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(const NinetyNineApp());
}
