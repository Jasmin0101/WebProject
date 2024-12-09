import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/application/widget.dart';

class ApplicationPage extends StatefulWidget {
  const ApplicationPage({super.key});

  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Тех.поддержка '),
      ),
      body: ApplicationWidget(),
    );
  }
}
