import 'package:flutter/material.dart';

import 'screens/onboarding_screen.dart';
import 'screens/phone_permission_screen.dart';
import 'screens/location_permission_screen.dart';

import 'screens/service_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Explorer Demo',
      routes: {
        '/': (context) => const OnboardingScreen(),
        LocationPermissionScreen.routeName: (context) =>
            const LocationPermissionScreen(),
        ServiceScreen.routeName: (context) => const ServiceScreen(),
        PhonePermissionScreen.routeName: (context) =>
            const PhonePermissionScreen(),
      },
    );
  }
}
