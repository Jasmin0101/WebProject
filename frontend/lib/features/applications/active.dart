import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter_application_1/core/api/chopper.dart';
import 'package:flutter_application_1/core/api/services/applications.dart';
import 'package:flutter_application_1/features/applications/add_dialog.dart';
import 'package:flutter_application_1/navigation/navigator.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ActiveApplicationsWidget extends StatefulWidget {
  const ActiveApplicationsWidget({
    super.key,
  });

  @override
  State<ActiveApplicationsWidget> createState() =>
      _ActiveApplicationsWidgetState();
}

class _ActiveApplicationsWidgetState extends State<ActiveApplicationsWidget> {
  final PagingController<int, Map> _pagingController = PagingController(
    firstPageKey: 1,
  );

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    final service = api.getService<ApplicationsService>();

    try {
      final response = await service.myApplicationView(true, pageKey);

      final data = Map<String, dynamic>.from(response.body);

      if (data["is_last_page"]) {
        _pagingController.appendLastPage(List<Map>.from(data["applications"]));
        return;
      }

      _pagingController.appendPage(
          List<Map>.from(data["applications"]), pageKey + 1);
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PagedListView<int, Map>(
        pagingController: _pagingController,
        padding: const EdgeInsets.all(16),
        builderDelegate: PagedChildBuilderDelegate<Map>(
          animateTransitions: true,
          noItemsFoundIndicatorBuilder: (context) => Center(
            child: Text(
              'У вас нету активных заявок',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          itemBuilder: (context, item, index) => ListTile(
            title: Text(
              item['title'] == null || item['title'] == ""
                  ? 'Нет заголовка'
                  : item['title'],
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Align(
              alignment: Alignment.centerLeft,
              child: Chip(
                label: Text(
                  switch (item["status"]) {
                    "WA" => "На рассмотрении",
                    "WO" => "В работе",
                    "IR" => "Требуется информация",
                    "CO" => "Завершено",
                    _ => "Без статуса",
                  },
                ),
              ),
            ),
            onTap: () => AppNavigator.openApplication(
              item['id'].toString(),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final wasAdded =
              await ApplicationAddDialog.showApplicationDialog(context);

          if (wasAdded == true && context.mounted) {
            _pagingController.refresh();
          }
        },
        label: const Text('Создать заявку'),
        icon: const Icon(Icons.edit),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
