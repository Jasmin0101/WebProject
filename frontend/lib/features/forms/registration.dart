import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/core/api/services/user.dart';
import 'package:flutter_application_1/core/token.dart';
import 'package:flutter_application_1/navigation/navigator.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
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
  final MaskedTextController _dateController =
      MaskedTextController(mask: '00.00.0000');
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Регистрация ',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Image.asset(
                    'img/logo.png',
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Имя
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 72,
                ),
                child: TextFormField(
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
              ),
              // Фамилия
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 72,
                ),
                child: TextFormField(
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
              ),

              // Email
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 72,
                ),
                child: TextFormField(
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
              ),

              ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 72,
                ),
                child: DropdownMenu<int>(
                  expandedInsets: const EdgeInsets.only(top: 8, bottom: 8),
                  menuHeight: 150,
                  width: 360 - 16 * 2,
                  requestFocusOnTap: true,
                  enableFilter: false,
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
              ),
              // Логин
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 72,
                ),
                child: TextFormField(
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
              ),

              // Пароль
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 72,
                ),
                child: TextFormField(
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
              ),

              // Подтверждение пароля
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 72,
                ),
                child: TextFormField(
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
              ),

              // Дата рождения
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 72,
                ),
                child: TextFormField(
                  controller: _dateController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: "Дата рождения",
                    border: const OutlineInputBorder(),
                    labelText: 'Дата рождения',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate ?? DateTime.now(),
                          firstDate: DateTime(1920),
                          lastDate: DateTime.now(),
                        );

                        if (pickedDate != null) {
                          setState(() {
                            _selectedDate = pickedDate;
                            _dateController.text =
                                "${pickedDate.day.toString().padLeft(2, '0')}.${pickedDate.month.toString().padLeft(2, '0')}.${pickedDate.year}";
                          });
                        }
                      },
                    ),
                  ),
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите или выберите дату рождения';
                    }
                    final parts = value.split('.');
                    final day = int.tryParse(parts[0]);
                    final month = int.tryParse(parts[1]);
                    final year = int.tryParse(parts[2]);
                    if (day == null ||
                        day < 1 ||
                        day > 31 ||
                        month == null ||
                        month < 1 ||
                        month > 12 ||
                        year == null ||
                        year < 1900 ||
                        year > DateTime.now().year) {
                      return ' Некорректная дата';
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),

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
