import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api/chopper.dart';
import 'package:flutter_application_1/core/api/services/user.dart';
import 'package:flutter_application_1/features/user/edit_user.dart';

class UserWidget extends StatefulWidget {
  const UserWidget({super.key});

  @override
  State<UserWidget> createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  // Метод для получения данных пользователя с бэкенда
  Future<void> _fetchUser() async {
    try {
      final response = await api.getService<UserService>().userMeView();
      if (response.isSuccessful && response.body != null) {
        setState(() {
          _userData = Map<String, dynamic>.from(response.body);
          _isLoading = false;
        });
      } else {
        // Обработка ошибки
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      // Обработка исключений
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Widget _buildFieldGroup(String title, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(width: 2.0, color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userData == null
              ? const Center(child: Text('Не удалось загрузить данные'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildFieldGroup(
                          'Имя пользователя:',
                          _userData!['name'] + ' ' + _userData!['surname'] ??
                              'Не указано'),
                      _buildFieldGroup(
                          'Email:', _userData!['email'] ?? 'Не указано'),
                      _buildFieldGroup(
                          'Дата рождения:', _userData!['dob'] ?? 'Не указано'),
                      _buildFieldGroup(
                          'Город:', _userData!['city'] ?? 'Не указано'),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(16.0),
        child: OverflowBar(
          children: [
            ElevatedButton(
              onPressed: () {
                const UserEdit();
              },
              child: Text(
                'Редактировать',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            ElevatedButton(
              onPressed: () {
                // Логика выхода
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text(
                'Выйти',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}