import 'package:flutter/material.dart';
import '../presentation/pages/auth/signin_page.dart';
import '../presentation/pages/auth/signup_page.dart';
import '../presentation/pages/home_page.dart';
import '../presentation/pages/chatbot_page.dart';
import '../presentation/pages/result_page.dart';
import '../presentation/pages/medication_page.dart';


class AppRoutes {
  static Map<String, WidgetBuilder> get routes => {
    '/signin': (context) => const SignInPage(),
    '/signup': (context) => const SignUpPage(),
    '/home': (context) => HomePage(),
    '/chatbot': (context) => const ChatbotPage(),
    // '/result': (context) => const ResultPage(),
    // '/medication': (context) => const MedicationPage(),
  };
}