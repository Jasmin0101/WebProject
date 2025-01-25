import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/application/active.dart';
import 'package:flutter_application_1/features/application/complite.dart';

class ApplicationPage extends StatefulWidget {
  const ApplicationPage({super.key});

  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
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
            ActiveApplicationWidget(),
            CompliteApplicationWidget(),
          ],
        ),
      ),
    );
  }
}
