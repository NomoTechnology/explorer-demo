import 'package:flutter/material.dart';

import './location_permission_screen.dart';
import '../widgets/primary_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 40.0, left: 24.0, right: 24.0),
            width: double.infinity,
            child: const Center(
              child: Text(
                "Explorer Demo",
                style: TextStyle(
                  fontSize: 32.0,
                  color: Color(0xFF373D47),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.cover,
            ),
          ),
          const Spacer(),
          PrimaryButton(
            text: "Começar",
            color: const Color(0xFF373D47),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(LocationPermissionScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
