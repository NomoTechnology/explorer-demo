import 'package:flutter/material.dart';

import 'screens/phone_permission_screen.dart';
import 'screens/location_permission_screen.dart';

import 'screens/service_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Foreground Example Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Native permissions',
      routes: {
        '/': (context) => const LocationPermissionScreen(),
        ServiceScreen.routeName: (context) => const ServiceScreen(),
        PhonePermissionScreen.routeName: (context) =>
            const PhonePermissionScreen(),
      },
    );
  }
}
