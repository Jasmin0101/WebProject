import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/application/actions.dart';
import 'package:flutter_application_1/features/application/input.dart';
import 'package:flutter_application_1/features/application/messages.dart';
import 'package:flutter_application_1/navigation/navigator.dart';

class ApplicationPage extends StatelessWidget {
  final String? applicationId;

  const ApplicationPage({
    super.key,
    required this.applicationId,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        AppNavigator.openApplications();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Заяка номер $applicationId'),
          actions: [
            ApplicationAction(
              applicationId: applicationId ?? "",
            ),
          ],
        ),
        body: AplicationMessagesList(
          applicationId: applicationId ?? "",
        ),
        bottomNavigationBar: ApplicationInputField(
          applicationId: applicationId ?? "",
        ),
      ),
    );
  }
}
