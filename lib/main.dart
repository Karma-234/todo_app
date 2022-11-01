import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/pages/login.dart';
import 'package:todo_app/routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: RouteManager.loginPage,
      onGenerateRoute: (settings) => RouteManager.generateRoute(settings),
      home: Login(),
    );
  }
}
