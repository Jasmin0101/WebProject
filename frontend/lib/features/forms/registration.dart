import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api/services/user.dart';
import 'package:flutter_application_1/core/token.dart';
import 'package:flutter_application_1/navigation/navigator.dart';
import 'package:intl/intl.dart';

import '../../core/api/chopper.dart';

final _formKey = GlobalKey<FormState>();

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  // Контроллеры для полей
  final _dateController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _loginController = TextEditingController();
  final _emailController = TextEditingController();
  final _surnameController = TextEditingController();
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();

  int? _selectedCityId;
  List<Map> _cities = [];

  DateTime? _selectedDate;
  Future<void> _fetchCities() async {
    try {
      final cities = await api.getService<UserService>().citiesView();
      _cities = List<Map>.from(cities.body);
      setState(() {});
    } catch (_) {}
  }

  bool _showPassWorld = false;
  @override
  void initState() {
    super.initState();
    _fetchCities();
  }

  @override
  void dispose() {
    // Освобождаем контроллеры
    _dateController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Имя
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: "Введите имя",
                  border: OutlineInputBorder(),
                  labelText: 'Имя',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите имя';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Фамилия
              TextFormField(
                controller: _surnameController,
                decoration: const InputDecoration(
                  hintText: "Введите фамилию",
                  border: OutlineInputBorder(),
                  labelText: 'Фамилия',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите фамилию';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: "Введите адрес электронной почты",
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите адрес электронной почты';
                  }
                  if (!RegExp(
                          r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                      .hasMatch(value)) {
                    return 'Введите корректный email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownMenu<int>(
                width: 360 - 16 * 2,
                requestFocusOnTap: true,
                enableFilter: true,
                label: const Text('Город'),
                onSelected: (citiesId) {
                  _selectedCityId = citiesId;
                  setState(() {});
                },
                dropdownMenuEntries: List.generate(
                  _cities.length,
                  (index) => DropdownMenuEntry(
                    value: _cities[index]['id'],
                    label: _cities[index]['city'],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Логин
              TextFormField(
                controller: _loginController,
                decoration: const InputDecoration(
                  hintText: "Введите логин",
                  border: OutlineInputBorder(),
                  labelText: 'Логин',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите логин';
                  }
                  if (value.length < 4) {
                    return 'Логин должен быть не менее 4 символов';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Пароль
              TextFormField(
                controller: _passwordController,
                obscureText: _showPassWorld,
                decoration: const InputDecoration(
                  hintText: "Введите пароль",
                  border: OutlineInputBorder(),
                  labelText: 'Пароль',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите пароль';
                  }
                  if (value.length < 6) {
                    return 'Пароль должен быть не менее 6 символов';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Подтверждение пароля
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Подтвердите пароль",
                  border: OutlineInputBorder(),
                  labelText: 'Подтверждение пароля',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Подтвердите пароль';
                  }
                  if (value != _passwordController.text) {
                    return 'Пароли не совпадают';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Дата рождения
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  hintText: "Дата рождения",
                  border: OutlineInputBorder(),
                  labelText: 'Дата рождения',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1920),
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                      _dateController.text =
                          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Выберите дату рождения';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Кнопка регистрации
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const ElevatedButton(
                    onPressed: AppNavigator.openLogin,
                    child: Text('Назад'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      try {
                        final login = _loginController.text;
                        final name = _nameController.text;
                        final surname = _surnameController.text;
                        final email = _emailController.text;
                        final city = _selectedCityId!;
                        final password = _passwordController.text;
                        final dob = _selectedDate!;

                        final response =
                            await api.getService<UserService>().registration(
                                  name,
                                  surname,
                                  email,
                                  city,
                                  login,
                                  password,
                                  DateFormat("yyyy-MM-dd").format(dob),
                                );
                        if (!response.isSuccessful) {
                          return;
                        }
                        final token = response.body['access_token'];
                        tokenService.saveToken(token);
                        AppNavigator.openHome();
                      } catch (_) {}
                    },
                    child: const Text("Зарегистрироваться"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
