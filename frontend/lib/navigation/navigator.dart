import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/city.dart';
import 'package:flutter_application_1/navigation/queries_name.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'router.dart';
import 'routes_name.dart';

// навигация сайта
final class AppNavigator {
  static BuildContext get _context => rootNavigatorKey.currentContext!;

  AppNavigator._();

  static void openLogin() => _context.goNamed(
        RoutesName.login,
      );

  static void openSignUp() => _context.goNamed(
        RoutesName.signUp,
      );
  static void openHome() => _context.goNamed(
        RoutesName.home,
      );
  static void openQuiz() => _context.goNamed(
        RoutesName.quiz,
      );
  static void openApplication() => _context.goNamed(
        RoutesName.application,
      );
  static void openWeather(
    City city,
    DateTime date,
  ) =>
      _context.goNamed(RoutesName.weather, pathParameters: {
        QueriesName.city: city.queryName,
        QueriesName.date: DateFormat('yyyy-MM-dd').format(date),
      });

  static void openUser() => _context.goNamed(
        RoutesName.user,
      );
}
