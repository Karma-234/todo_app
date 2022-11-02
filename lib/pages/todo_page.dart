// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/services/todo_service.dart';
import 'package:todo_app/services/user_service.dart';
import 'package:todo_app/widgets/dialogs.dart';

import '../models/todo.dart';
import '../models/user.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late TextEditingController todoController;

  @override
  void initState() {
    super.initState();
    todoController = TextEditingController();
  }

  @override
  void dispose() {
    todoController.dispose();
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
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: const Text('Create a new TODO'),
                              content: TextField(
                                decoration: const InputDecoration(
                                    hintText: 'Please enter TODO'),
                                controller: todoController,
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Save'),
                                  onPressed: () async {
                                    if (todoController.text.isEmpty) {
                                      showSnackBar(
                                          context, 'Enter a todo then save');
                                    } else {
                                      String username = await context
                                          .read<UserService>()
                                          .currentUser
                                          .username;

                                      Todo todo = Todo(
                                          username: username,
                                          title: todoController.text.trim(),
                                          created: DateTime.now());

                                      if (context
                                          .read<TodoService>()
                                          .todos
                                          .contains(todo)) {
                                        showSnackBar(context, 'Duplicate Todo');
                                      } else {
                                        String result = await context
                                            .read<TodoService>()
                                            .createTodo(todo);
                                        if (result == 'OK') {
                                          showSnackBar(
                                              context, 'New Todo added');
                                          todoController.text = '';
                                        } else {
                                          showSnackBar(context, result);
                                        }
                                        Get.back();
                                      }
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.exit_to_app,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Selector<UserService, User>(
                  selector: (context, value) => value.currentUser,
                  builder: (context, value, child) => Text(
                    '${value.name.toUpperCase()}\'s Todo list',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 46,
                      fontWeight: FontWeight.w200,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 20),
                    child: Consumer<TodoService>(
                      builder: (context, value, child) => ListView.builder(
                        itemCount: value.todos.length,
                        itemBuilder: (context, index) {
                          return TodoCard(
                            todo: value.todos[index],
                          );
                        },
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TodoCard extends StatelessWidget {
  const TodoCard({
    Key? key,
    required this.todo,
  }) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple.shade300,
      child: Slidable(
        endActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: 0.3,
            children: [
              SlidableAction(
                label: 'Delete',
                backgroundColor: Colors.purple,
                icon: Icons.delete,
                onPressed: (BuildContext context) async {
                  String result =
                      await context.read<TodoService>().deleteTodos(todo);
                },
              ),
            ]),
        child: CheckboxListTile(
          checkColor: Colors.purple,
          activeColor: Colors.purple[100],
          value: todo.done,
          onChanged: (value) async {
            String result =
                await context.read<TodoService>().toggleTodoDone(todo);
          },
          subtitle: Text(
            '${todo.created.day}/${todo.created.month}/${todo.created.year}',
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
          title: Text(
            todo.title,
            style: const TextStyle(
              color: Colors.white,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}
