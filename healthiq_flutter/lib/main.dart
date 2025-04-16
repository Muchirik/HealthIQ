import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(HealthIQApp());
}

class HealthIQApp extends StatelessWidget {
  const HealthIQApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HealthIQ',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
