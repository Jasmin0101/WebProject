import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/token.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'navigation/router.dart';

const double maxAppWidth = 800;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
          seedColor: const Color.fromARGB(255, 164, 203, 221),
          brightness: Brightness.light,
        ),
      ),
      // создание темной темы, адоптируется под тему системы
      darkTheme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 164, 203, 221),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      builder: (context, child) => Material(
        color: Theme.of(context).colorScheme.surfaceContainer,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(
                MediaQuery.sizeOf(context).width > maxAppWidth ? 8 : 0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  MediaQuery.sizeOf(context).width > maxAppWidth ? 10 : 0,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: maxAppWidth,
                ),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
