import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api/chopper.dart';
import 'package:flutter_application_1/core/api/services/application.dart';

class ApplicationEditDialog extends StatefulWidget {
  final Map<dynamic, dynamic> application;
  const ApplicationEditDialog({super.key, required this.application});

  static Future<bool?> showApplicationDialog(
    BuildContext context,
    Map<dynamic, dynamic> application,
  ) async {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true, // Для адаптации под клавиатуру
      isDismissible: false,
      builder: (_) => ApplicationEditDialog(
        application: application,
      ),
    );
  }

  @override
  State<ApplicationEditDialog> createState() => _ApplicationEditDialogState();
}

class _ApplicationEditDialogState extends State<ApplicationEditDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _textController;

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.application['title']);
    _textController = TextEditingController(text: widget.application['text']);

    super.initState();
  }

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
            'Редактирование заявки',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Заголовок',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _textController,
            decoration: const InputDecoration(
              labelText: 'Содержание',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
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
                      final text = _textController.text;
                      final id = widget.application['id'];

                      final response = await api
                          .getService<ApplicationService>()
                          .myApplicationEdit(title, text, id);
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
    _textController.dispose();
    super.dispose();
  }
}
