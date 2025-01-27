import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api/chopper.dart';
import 'package:flutter_application_1/core/api/services/applications.dart';

class ApplicationAddDialog extends StatefulWidget {
  const ApplicationAddDialog({super.key});

  static Future<bool?> showApplicationDialog(BuildContext context) async {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true, // Для адаптации под клавиатуру
      isDismissible: false,
      builder: (_) => const ApplicationAddDialog(),
    );
  }

  @override
  State<ApplicationAddDialog> createState() => _ApplicationAddDialogState();
}

class _ApplicationAddDialogState extends State<ApplicationAddDialog> {
  final _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // Учет клавиатуры
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Создание обращения',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Тема',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Отмена'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    // Логика отправки заявки
                    try {
                      final title = _titleController.text;

                      final response = await api
                          .getService<ApplicationsService>()
                          .applicationCreate(title);
                    } catch (e) {}
                    if (context.mounted) Navigator.of(context).pop(true);
                  },
                  child: const Text('Отправить'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  //Очистка после использования
  void dispose() {
    _titleController.dispose();

    super.dispose();
  }
}
