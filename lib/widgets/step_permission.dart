import 'package:flutter/material.dart';

import '../widgets/primary_button.dart';

class StepPermission extends StatelessWidget {
  final bool isPermanent;
  final VoidCallback onPressed;
  final Image image;
  final String title;
  final String message;

  const StepPermission({
    Key? key,
    required this.isPermanent,
    required this.onPressed,
    required this.image,
    required this.title,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 60.0),
          child: image,
        ),
        Container(
          padding: const EdgeInsets.only(top: 24.0),
          width: double.infinity,
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 24.0,
                color: Color(0xFF373D47),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 16.0, left: 24.0, right: 24.0),
          width: double.infinity,
          child: Center(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 18.0,
                color: Color(0xFF373D47),
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const Spacer(),
        if (isPermanent)
          Container(
            padding: const EdgeInsets.all(24.0),
            child: const Text(
              'Você precisa dar essa permissão nas configurações do sistema.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17.0,
                color: Color(0xFF373D47),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        if (!isPermanent)
          PrimaryButton(
            text: isPermanent ? 'Abrir configurações' : 'Habilitar permissão',
            color: const Color(0xFF373D47),
            onPressed: onPressed,
          ),
      ],
    );
  }
}
