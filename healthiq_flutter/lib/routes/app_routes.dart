import 'package:flutter/material.dart';
import '../presentation/pages/auth/signin_page.dart';
import '../presentation/pages/auth/signup_page.dart';
import '../presentation/pages/home_page.dart';
import '../presentation/pages/chatbot_page.dart';
import '../presentation/pages/landing_page.dart';
import '../presentation/pages/history_page.dart';
import '../presentation/pages/medication_page.dart';
import '../presentation/pages/notification_page.dart';


class AppRoutes {
  static Map<String, WidgetBuilder> get routes => {
    '/signin': (context) => const SignInPage(),
    '/signup': (context) => const SignUpPage(),
    '/home': (context) => HomePage(),
    '/chatbot': (context) => const ChatbotPage(),
    '/landing': (context) => const LandingPage(),
    '/history': (context) =>  HistoryPage(),
    '/medication': (context) => const MedicationPage(),
    '/notifications': (context) => NotificationsPage(),
  };
}