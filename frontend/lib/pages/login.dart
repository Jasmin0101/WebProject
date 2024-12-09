import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/forms/login.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 60,
          ),
          AppBar(
            centerTitle: true,
            title: const Text(
              'SunCloud',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 32,
                letterSpacing: 1.5,
              ),
            ), // переименовать
          ),
          const SizedBox(height: 20), // Отступ между AppBar и изображением
          Image.asset(
            'img/logo.png',
            height: 120,
            width: 120,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 60),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 360,
                ),
                child: LoginForm(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
