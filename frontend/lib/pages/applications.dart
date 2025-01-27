import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/applications/active.dart';
import 'package:flutter_application_1/features/applications/complite.dart';

class ApplicationsPage extends StatefulWidget {
  const ApplicationsPage({super.key});

  @override
  State<ApplicationsPage> createState() => _ApplicationsPageState();
}

class _ApplicationsPageState extends State<ApplicationsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Тех.поддержка '),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                text: "Активные",
              ),
              Tab(
                text: "Решенные",
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            ActiveApplicationsWidget(),
            CompliteApplicationsWidget(),
          ],
        ),
      ),
    );
  }
}
