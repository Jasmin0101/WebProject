import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/user/user.dart';
import 'package:flutter_application_1/navigation/navigator.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Профиль 🔆',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.mail),
            onPressed: () {
              AppNavigator.openApplication();
            },
          ),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Отступ между AppBar и изображением
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 360,
                ),
                child: const UserWidget(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
