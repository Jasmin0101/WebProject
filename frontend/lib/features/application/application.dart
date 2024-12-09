import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api/chopper.dart';
import 'package:flutter_application_1/core/api/services/application.dart';
import 'package:flutter_application_1/features/application/dialog.dart';

class ApplicationWidget extends StatefulWidget {
  const ApplicationWidget({super.key});

  @override
  State<ApplicationWidget> createState() => _ApplicationWidgetState();
}

class _ApplicationWidgetState extends State<ApplicationWidget> {
  List<Map>? _myapplications = null;

  Future<void> _fetchMyApplication() async {
    try {
      _myapplications = null;
      setState(() {});
      final myapplication =
          await api.getService<ApplicationService>().myApplicationView();
      _myapplications = List<Map>.from(myapplication.body);
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
          if (_myapplications == null) {
            return const Center(child: const CircularProgressIndicator());
          }

          if (_myapplications!.isEmpty) {
            return const Center(
              child: Text("У вас пока не было заявок"),
            );
          }

          return ListView.builder(
            itemCount: _myapplications!.length,
            itemBuilder: (context, index) {
              final application = _myapplications![index];
              return ListTile(
                title: Text(application['title'] ?? 'Нет заголовка'),
                subtitle: Text(application['text'] ?? 'Нет описания'),
                onTap: () {
                  // Действие при нажатии на элемент списка
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final wasAdded =
              await ApplicationDialog.showApplicationDialog(context);

          if (wasAdded == true && context.mounted) {
            _fetchMyApplication();
          }
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
