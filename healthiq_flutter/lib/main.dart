import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const HealthIQApp());
}

class HealthIQApp extends StatelessWidget {
  const HealthIQApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HealthIQ',
      //theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      initialRoute: '/landing',
      routes: AppRoutes.routes,
    );
  }
}