import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/account/account.dart';
import 'package:flutter_application_1/features/forms/registration.dart';

class Account extends StatelessWidget {
  const Account({super.key});

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
                Icon(
                  Icons.sunny, 
                  size: 60,
                  color: Colors.amber[200],
                ),
             
              ],
            ),
          ),
        ), // переим,
        body: Column(
          children: [
               const Text(
                   'User',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    letterSpacing: 1.5,
                  ),
                ),
            // Отступ между AppBar и изображением
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 360,
                  ),
                  child: const AccountWidget(),
                ),
              ),
            ),
          ],
        ));
  }
}
