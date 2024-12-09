import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

// создание страницы с пользовательскими анимациями перехода
class FadeTransitionPage extends CustomTransitionPage {
  FadeTransitionPage({
    required super.child,
    super.name,
    super.arguments,
    super.restorationId,
    super.key,
  }) : super(
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
