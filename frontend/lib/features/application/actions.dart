import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api/chopper.dart';
import 'package:flutter_application_1/core/api/services/application.dart';
import 'package:flutter_application_1/navigation/navigator.dart';

class ApplicationAction extends StatefulWidget {
  final String applicationId;
  const ApplicationAction({super.key, required this.applicationId});

  @override
  State<ApplicationAction> createState() => _ApplicationActionState();
}

class _ApplicationActionState extends State<ApplicationAction> {
  bool _isLoading = true;
  bool _isComplited = false;

  Future<void> _fetchApplicationInfo() async {
    final service = api.getService<ApplicationService>();

    try {
      final response = await service.view(
        int.tryParse(widget.applicationId) ?? -1,
      );

      final data = Map<String, dynamic>.from(response.body);
      _isComplited = data["status"] == "CO";

      _isLoading = false;
      setState(() {});
    } catch (error) {}
  }

  @override
  void initState() {
    _fetchApplicationInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _isComplited) {
      return SizedBox.shrink();
    }

    return PopupMenuButton<int>(
      onSelected: (int item) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Закрыть заявку"),
              content: const Text("Вы уверены что хотите закрыть заявку?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Отмена"),
                ),
                TextButton(
                  onPressed: () async {
                    final service = api.getService<ApplicationService>();
                    try {
                      await service.close(
                        int.tryParse(widget.applicationId) ?? -1,
                      );
                    } catch (error) {}
                    if (context.mounted) AppNavigator.openApplications();
                  },
                  child: const Text("Закрыть"),
                ),
              ],
            );
          },
        );
      },
      itemBuilder: (context) => [
        PopupMenuItem<int>(
          value: 0,
          child: Text("Закрыть заявку"),
        ),
      ],
    );
  }
}
