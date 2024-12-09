import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/core/city.dart';
import 'package:flutter_application_1/core/token.dart';
import 'package:flutter_application_1/features/application/application.dart';
import 'package:flutter_application_1/navigation/queries_name.dart';
import 'package:flutter_application_1/pages/account.dart';
import 'package:flutter_application_1/pages/application.dart';
import 'package:flutter_application_1/pages/home.dart';
import 'package:flutter_application_1/pages/login.dart';
import 'package:flutter_application_1/pages/quiz.dart';
import 'package:flutter_application_1/pages/registration.dart';
import 'package:flutter_application_1/pages/weather.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'fade_transition.dart';
import 'routes_name.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  initialLocation: RoutesName.home,
  navigatorKey: rootNavigatorKey,
  redirect: (context, state) {
    if (!tokenService.haveValidToken()) {
      return RoutesName.login;
    }
    return null;
  },
  routes: [
    GoRoute(
      path: RoutesName.login,
      name: RoutesName.login,
      pageBuilder: (context, state) => FadeTransitionPage(
        key: state.pageKey,
        child: const LoginPage(),
      ),
    ),
    GoRoute(
      path: RoutesName.signUp,
      name: RoutesName.signUp,
      pageBuilder: (context, state) => FadeTransitionPage(
        key: state.pageKey,
        child: const RegistrationPage(), // Исправлено название класса
      ),
    ),
    GoRoute(
      path: RoutesName.home,
      name: RoutesName.home,
      pageBuilder: (context, state) {
        // Получаем параметры из состояния
        final dateStr = state.uri.queryParameters[QueriesName.date];
        final date = dateStr == null
            ? DateTime.now()
            : DateFormat('yyyy-MM-dd').parse(dateStr);

        return FadeTransitionPage(
          key: state.pageKey,
          child: HomePage(
            date: date, // Исправлено использование параметра
            city: City
                .khabarovsk, // Статичный пример, можно изменить на динамический
          ),
        );
      },
      routes: [
        GoRoute(
          path:
              "${RoutesName.weather}/:${QueriesName.city}/:${QueriesName.date}",
          name: RoutesName.weather,
          pageBuilder: (context, state) {
            // Получаем параметры маршрута
            final cityName = state.pathParameters[QueriesName.city];
            final dateStr = state.pathParameters[QueriesName.date];

            // Обработка параметров
            final city = City.values.firstWhere(
              (e) => e.queryName == cityName,
              orElse: () => City.vladivostok,
            );

            final date = dateStr == null
                ? DateTime.now()
                : DateFormat('yyyy-MM-dd').parse(dateStr);

            return FadeTransitionPage(
              key: state.pageKey,
              child: WeatherPage(
                city: city,
                date: date,
              ),
            );
          },
        ),
        GoRoute(
          path: RoutesName.quiz,
          name: RoutesName.quiz,
          pageBuilder: (context, state) => FadeTransitionPage(
            key: state.pageKey, // Добавлен ключ
            child: const QuizPage(),
          ),
        ),
        GoRoute(
          path: RoutesName.application,
          name: RoutesName.application,
          pageBuilder: (context, state) => FadeTransitionPage(
            key: state.pageKey, // Добавлен ключ
            child: const ApplicationPage(),
          ),
        ),
        GoRoute(
          path: RoutesName.account,
          name: RoutesName.account,
          pageBuilder: (context, state) => FadeTransitionPage(
            key: state.pageKey, // Добавлен ключ
            child: const Account(),
          ),
        )
      ],
    ),
  ],
);
