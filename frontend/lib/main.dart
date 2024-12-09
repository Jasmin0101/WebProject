import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/token.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'navigation/router.dart';

Future<void> main() async {
  await tokenService.init();
  runApp(const App());
}

//
class App extends StatelessWidget {
  const App({super.key});

  @override
  //
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Погода",
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      supportedLocales: const [
        Locale('ru'),
      ],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      // создание цветового шаблона для темной темы
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
      ),
      // создание темной темы, адоптируется под тему системы
      darkTheme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
    );
  }
}
