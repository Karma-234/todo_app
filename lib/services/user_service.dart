import 'package:flutter/material.dart';
import 'package:todo_app/models/user.dart';

import '../database/todo_database.dart';

class UserService with ChangeNotifier {
  late User _currentUser;
  bool _busyCreate = false;
  bool _userexists = false;

  User get currenUser => _currentUser;
  bool get userExists => _userexists;
  bool get busycreate => _busyCreate;

  set userExists(bool value) {
    _userexists = value;
    notifyListeners();
  }

  Future<String> getUser(String username) async {
    try {
      _currentUser = await TodoDatabase.instance.getUser(username);
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
    return "OK";
  }

  Future<String> checkIfUserExists(String username) async {
    try {
      await TodoDatabase.instance.getUser(username);
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
    return "OK";
  }

  Future<String> updateCurrentUser(String name) async {
    _currentUser.name = name;
    notifyListeners();
    try {
      await TodoDatabase.instance.updateUser(_currentUser);
    } catch (e) {
      return e.toString();
    }
    return 'OK';
  }

  Future<String> createUser(User user) async {
    _busyCreate = true;
    notifyListeners();
    try {
      await TodoDatabase.instance.createUser(user);
    } catch (e) {
      return e.toString();
    }
    _busyCreate = false;
    notifyListeners();
    return 'OK';
  }
}

String getHumanReadableError(String message) {
  if (message.contains('UNIQUE constraint failed')) {
    return 'This user already exists in the database. Please choose a new one.';
  }
  if (message.contains('not found in the database')) {
    return 'The user does not exist in the database. Please register first.';
  }
  return message;
}
