import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_routes.dart';
import 'firebase_options.dart';
// import 'dart.io' show Platform;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // check if user is logged in
  final User? user = FirebaseAuth.instance.currentUser;
  final String initialRoute = user != null ? '/home' : '/landing';

  runApp(HealthIQApp(initialRoute: initialRoute));
}

class HealthIQApp extends StatelessWidget {
  final String initialRoute;
  const HealthIQApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HealthIQ',
      //theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      // don't return to landing is user is already logged in
      initialRoute: initialRoute,
      routes: AppRoutes.routes,
    );
  }
}
