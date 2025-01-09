import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api/chopper.dart';
import 'package:flutter_application_1/core/api/services/application.dart';
import 'package:flutter_application_1/core/api/services/user.dart';
import 'package:flutter_application_1/core/token.dart';
import 'package:flutter_application_1/navigation/navigator.dart';
import 'package:intl/intl.dart';

class UserEdit extends StatefulWidget {
  final Map<dynamic, dynamic> user;
  final ScrollController controller;

  const UserEdit({
    super.key,
    required this.user,
    required this.controller,
  });

  static Future<bool?> showUserDialog(
    BuildContext context,
    Map<dynamic, dynamic> user,
  ) async {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: true,
      showDragHandle: true,
      useSafeArea: false,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        minChildSize: 0.5,
        initialChildSize: 0.8,
        maxChildSize: 0.9,
        builder: (context, controller) => UserEdit(
          controller: controller,
          user: user,
        ),
      ),
    );
  }

  @override
  State<UserEdit> createState() => _UserEditState();
}

class _UserEditState extends State<UserEdit> {
  late final TextEditingController _dateController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final TextEditingController _loginController;
  late final TextEditingController _emailController;
  late final TextEditingController _surnameController;
  late final TextEditingController _nameController;

  int? _selectedCityId;
  List<Map> _cities = [];

  DateTime? _selectedDate;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.user['name']);
    _surnameController = TextEditingController(text: widget.user['surname']);
    _emailController = TextEditingController(text: widget.user['email']);
    _loginController = TextEditingController(text: widget.user['login']);
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _dateController = TextEditingController(text: widget.user['dob']);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        controller: widget.controller,
        child: Form(
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
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Назад'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // if (!_formKey.currentState!.validate()) {
                      //   return;
                      // }
                      try {
                        final login = _loginController.text;
                        final name = _nameController.text;
                        final surname = _surnameController.text;
                        final email = _emailController.text;
                        final city = _selectedCityId!;
                        final password = _passwordController.text;
                        final dob = _selectedDate!;

                        final response =
                            await api.getService<UserService>().edit(
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
                      } catch (_) {}
                      if (context.mounted) Navigator.of(context).pop(true);
                    },
                    child: const Text("Сохранить"),
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
