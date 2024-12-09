import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api/chopper.dart';
import 'package:flutter_application_1/core/api/services/application.dart';
import 'package:flutter_application_1/features/application/add_dialog.dart';
import 'package:flutter_application_1/features/application/edit_dialog.dart';

class ApplicationWidget extends StatefulWidget {
  const ApplicationWidget({super.key});

  @override
  State<ApplicationWidget> createState() => _ApplicationWidgetState();
}

class _ApplicationWidgetState extends State<ApplicationWidget> {
  // ignore: avoid_init_to_null
  List<Map>? _myApplications = null;

  Future<void> _fetchMyApplication() async {
    try {
      _myApplications = null;
      setState(() {});
      final myApplication =
          await api.getService<ApplicationService>().myApplicationView();
      _myApplications = List<Map>.from(myApplication.body);
      setState(() {});
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    _fetchMyApplication();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          if (_myApplications == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_myApplications!.isEmpty) {
            return const Center(
              child: Text("У вас пока не было заявок"),
            );
          }

          return ListView.builder(
            itemCount: _myApplications!.length,
            itemBuilder: (context, index) {
              final application = _myApplications![index];
              return ListTile(
                trailing: Chip(
                    label: Text(switch (application["status"]) {
                  "SEND" => "Отправленно",
                  "RECEIVED" => "Получено",
                  "READ" => "Прочитано",
                  "REJECTED" => "Отклонено",
                  _ => "Без статуса",
                })),
                title: Text(application['title'] ?? 'Нет заголовка'),
                subtitle: Text(application['text'] ?? 'Нет описания'),
                onTap: application['status'] != "SEND"
                    ? null
                    : () async {
                        final wasEdited =
                            await ApplicationEditDialog.showApplicationDialog(
                          context,
                          application,
                        );

                        if (wasEdited == true && context.mounted) {
                          _fetchMyApplication();
                        }
                      },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final wasAdded =
              await ApplicationAddDialog.showApplicationDialog(context);

          if (wasAdded == true && context.mounted) {
            _fetchMyApplication();
          }
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
