import 'package:flutter/material.dart';

import '../pages/login.dart';
import '../pages/register.dart';
import '../pages/todo_page.dart';

class RouteManager {
  static const String loginPage = '/';
  static const String registerPage = '/registerPage';
  static const String todoPage = '/todoPage';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginPage:
        return MaterialPageRoute(
          builder: (context) => Login(),
        );

      case registerPage:
        return MaterialPageRoute(
          builder: (context) => Register(),
        );

      case todoPage:
        return MaterialPageRoute(
          builder: (context) => TodoPage(),
        );

      default:
        throw const FormatException('Route not found! Check routes again!');
    }
  }
}
