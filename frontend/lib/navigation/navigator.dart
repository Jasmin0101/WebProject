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
  static void openHome({
    int? cityId,
    DateTime? date,
  }) =>
      _context.goNamed(
        RoutesName.home,
        queryParameters: {
          if (cityId != null) QueriesName.cityId: cityId.toString(),
          if (date != null)
            QueriesName.date: DateFormat("yyyy-MM-dd").format(date),
        },
      );
  static void openQuiz() => _context.goNamed(
        RoutesName.quiz,
      );

  static void openApplications() => _context.goNamed(
        RoutesName.applications,
      );

  static void openApplication(
    String applicationId,
  ) =>
      _context.goNamed(
        RoutesName.application,
        queryParameters: {
          QueriesName.applicationId: applicationId,
        },
      );

  static void openWeather(
    City city,
    DateTime date,
  ) =>
      _context.goNamed(RoutesName.weather, pathParameters: {
        QueriesName.cityId: city.queryName,
        QueriesName.date: DateFormat('yyyy-MM-dd').format(date),
      });

  static void openUser() => _context.goNamed(
        RoutesName.user,
      );

  static void openAdmin([String? status]) => _context.goNamed(
        RoutesName.admin,
        queryParameters: {
          if (status != null) QueriesName.applicationsStatus: status,
        },
      );

  static void openAdminProfile() => _context.goNamed(
        RoutesName.adminProfile,
      );

  static void openAdminApplication(String applicationId, [String? status]) {
    _context.goNamed(
      RoutesName.adminApplication,
      queryParameters: {
        QueriesName.applicationId: applicationId,
        if (status != null) QueriesName.applicationsStatus: status,
      },
    );
  }
}
