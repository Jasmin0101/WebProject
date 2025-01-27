import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/admin/application/actions.dart';
import 'package:flutter_application_1/features/application/actions.dart';
import 'package:flutter_application_1/features/application/input.dart';
import 'package:flutter_application_1/features/application/messages.dart';
import 'package:flutter_application_1/navigation/navigator.dart';

class AdminApplicationPage extends StatelessWidget {
  final String? applicationId;
  final String? status;

  const AdminApplicationPage({
    super.key,
    required this.applicationId,
    required this.status,
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
          title: Text('Заяка номер $applicationId'),
          actions: [
            AdminApplicationAction(
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
