import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  // Must run before anything touches SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NatureGalleryApp());
}
