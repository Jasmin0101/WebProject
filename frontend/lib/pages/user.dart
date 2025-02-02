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
            icon: const Icon(Icons.support_agent),
            onPressed: () {
              AppNavigator.openApplications();
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
              child: const UserWidget(),
            ),
          ),
        ],
      ),
    );
  }
}
