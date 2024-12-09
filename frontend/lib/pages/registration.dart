import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/forms/registration.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent, // Прозрачный фон
          elevation: 0, // Убираем тень
          toolbarHeight: 120,
          centerTitle: true,
          title: Container(
            child: Column(
              children: [
                Image.asset(
                  'img/logo.png',
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                ),
                const Text(
                  'Регистрация ',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ), // переим,
        body: Column(
          children: [
            // Отступ между AppBar и изображением
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
        ));
  }
}
