import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/forms/registration.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Отступ между AppBar и изображением
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 360,
                ),
                child: const RegistrationForm(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
