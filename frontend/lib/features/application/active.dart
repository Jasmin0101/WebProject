import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api/chopper.dart';
import 'package:flutter_application_1/core/api/services/application.dart';
import 'package:flutter_application_1/features/application/add_dialog.dart';
import 'package:flutter_application_1/features/application/edit_dialog.dart';

class ActiveApplicationWidget extends StatefulWidget {
  const ActiveApplicationWidget({super.key});

  @override
  State<ActiveApplicationWidget> createState() =>
      _ActiveApplicationWidgetState();
}

class _ActiveApplicationWidgetState extends State<ActiveApplicationWidget> {
  // ignore: avoid_init_to_null
  List<Map>? _myApplications = null;

  Future<void> _fetchMyApplication() async {
    try {
      _myApplications = null;
      setState(() {});
      final myApplication =
          await api.getService<ApplicationService>().myApplicationView();
      final data = Map<String, dynamic>.from(myApplication.body);
      _myApplications = List<Map>.from(data['applications']);
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

          return RefreshIndicator(
            onRefresh: _fetchMyApplication,
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(height: 24),
              itemCount: _myApplications!.length,
              itemBuilder: (context, index) {
                final application = _myApplications![index];
                return ListTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          application['title'] == null ||
                                  application['title'] == ""
                              ? 'Нет заголовка'
                              : application['title'],
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Chip(
                        label: Text(
                          switch (application["status"]) {
                            "SEND" => "Отправленно",
                            "RECEIVED" => "Получено",
                            "READ" => "Прочитано",
                            "REJECTED" => "Отклонено",
                            _ => "Без статуса",
                          },
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      application['text'] == null || application['text'] == ""
                          ? 'Нет описания'
                          : application['text'],
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  isThreeLine: true,
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
            ),
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
