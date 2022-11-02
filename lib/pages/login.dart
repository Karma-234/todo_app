import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/pages/register.dart';
import 'package:todo_app/pages/todo_page.dart';
import 'package:todo_app/services/user_service.dart';
import 'package:todo_app/widgets/dialogs.dart';

import '../routes/routes.dart';
import '../services/todo_service.dart';
import '../widgets/app_textfield.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController usernameController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple, Colors.blue],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 40.0),
                  child: Text(
                    'Welcome',
                    style: TextStyle(
                        fontSize: 46,
                        fontWeight: FontWeight.w200,
                        color: Colors.white),
                  ),
                ),
                AppTextField(
                  controller: usernameController,
                  labelText: 'Please enter username',
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (usernameController.text.isEmpty) {
                        showSnackBar(context, 'Please enter username');
                      } else {
                        String result = await context
                            .read<UserService>()
                            .getUser(usernameController.text.trim());
                        if (result != 'OK') {
                          showSnackBar(context, result);
                        } else {
                          String username =
                              context.read<UserService>().currentUser.username;
                          context.read<TodoService>().getTodos(username);
                          Get.toNamed(RouteManager.todoPage);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.purple,
                    ),
                    child: const Text('Continue'),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Get.toNamed(RouteManager.registerPage);
                  },
                  child: const Text('Register a new User'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
