import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api/chopper.dart';
import 'package:flutter_application_1/core/api/services/admin.dart';
import 'package:flutter_application_1/core/api/services/application.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/navigation/navigator.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class AdminApplicationList extends StatefulWidget {
  final String? status;

  const AdminApplicationList({
    super.key,
    required this.status,
  });

  @override
  State<AdminApplicationList> createState() => _AdminApplicationListState();
}

class _AdminApplicationListState extends State<AdminApplicationList> {
  final PagingController<int, Map> _pagingController = PagingController(
    firstPageKey: 1,
  );

  StreamSubscription<Map>? _messagesSubscription;

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    final service = api.getService<AdminService>();

    try {
      final response = await service.viewApplications(
        pageKey,
        status: widget.status,
      );

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
    return PagedListView<int, Map>(
      pagingController: _pagingController,
      padding: const EdgeInsets.all(16),
      builderDelegate: PagedChildBuilderDelegate<Map>(
        animateTransitions: true,
        noItemsFoundIndicatorBuilder: (context) => Center(
          child: Text(
            'Нет заявок данного статуса',
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
          onTap: () {
            AppNavigator.openAdminApplication(
                item['id'].toString(), widget.status);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _messagesSubscription?.cancel();
    super.dispose();
  }
}
