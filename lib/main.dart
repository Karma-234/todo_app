import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/pages/login.dart';
import 'package:todo_app/routes/routes.dart';
import 'package:todo_app/services/todo_service.dart';
import 'package:todo_app/services/user_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserService(),
        ),
        ChangeNotifierProvider(
          create: (context) => TodoService(),
        ),
      ],
      child: GetMaterialApp(
        initialRoute: RouteManager.loginPage,
        onGenerateRoute: (settings) => RouteManager.generateRoute(settings),
        home: Login(),
      ),
    );
  }
}
