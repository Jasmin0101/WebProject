import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/admin/applications/list.dart';
import 'package:flutter_application_1/navigation/navigator.dart';

class AdminPage extends StatelessWidget {
  final String? status;

  const AdminPage({
    super.key,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Список заявок"),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              AppNavigator.openAdminProfile();
            },
          ),
          PopupMenuButton<int>(
            initialValue: switch (status) {
              "WA" => 1,
              "WO" => 2,
              "IR" => 3,
              "CO" => 4,
              _ => 0,
            },
            onSelected: (int item) {
              final newStatus = switch (item) {
                0 => null,
                1 => "WA",
                2 => "WO",
                3 => "IR",
                4 => "CO",
                _ => null,
              };
              AppNavigator.openAdmin(
                newStatus,
              );
            },
            itemBuilder: (context) => [
              const PopupMenuItem<int>(
                value: 0,
                child: Text("Все заявки"),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text("Ожидают рассмотрения"),
              ),
              const PopupMenuItem<int>(
                value: 2,
                child: Text("В роботе"),
              ),
              const PopupMenuItem<int>(
                value: 3,
                child: Text("Требуют информации"),
              ),
              const PopupMenuItem<int>(
                value: 4,
                child: Text("Завершенные"),
              ),
            ],
          ),
        ],
      ),
      body: AdminApplicationList(
        key: Key(status ?? "all"),
        status: status,
      ),
    );
  }
}
