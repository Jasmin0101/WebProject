import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/user/user.dart';
import 'package:flutter_application_1/navigation/navigator.dart';

class AdmibProfilePage extends StatelessWidget {
  final String? status;

  const AdmibProfilePage({
    super.key,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        AppNavigator.openAdmin(status);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Профиль 🔆',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
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
      ),
    );
  }
}
