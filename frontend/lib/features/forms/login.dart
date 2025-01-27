import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/core/api/chopper.dart';
import 'package:flutter_application_1/core/api/services/user.dart';
import 'package:flutter_application_1/core/token.dart';
import 'package:flutter_application_1/navigation/navigator.dart';

final _formKey = GlobalKey<FormState>(); // создание ключа для формы

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _passwordController = TextEditingController();
  final _loginController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      constraints: const BoxConstraints.expand(),
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _loginController,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  ],
                  decoration: const InputDecoration(
                    hintText: "Логин",
                    border: OutlineInputBorder(),
                    labelText: 'Введите логин',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите свой логин';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  ],
                  decoration: const InputDecoration(
                    hintText: 'Пароль',
                    border: OutlineInputBorder(),
                    labelText: 'Введите пароль',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите пароль';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const ElevatedButton(
                    onPressed: AppNavigator.openSignUp,
                    child: Text("Зарегистрироваться"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      try {
                        final login = _loginController.text;
                        final password = _passwordController.text;
                        final response = await api
                            .getService<UserService>()
                            .login(login, password);

                        if (!response.isSuccessful) {
                          if (response.error == 'User not found.') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Пользователь не найден')),
                            );
                          }
                          if (response.error == 'Invalid password.') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Неверный логин или пароль')),
                            );
                          }
                          return;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Вход выполнен успешно')),
                        );
                        final token = response.body['access_token'];
                        tokenService.saveToken(token);

                        final status = response.body['status'];

                        if (status == "US") {
                          AppNavigator.openHome();
                        }

                        if (status == "AD") {
                          AppNavigator.openAdmin();
                        }
                      } catch (e) {}
                    },
                    child: const Text('Войти'),
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
