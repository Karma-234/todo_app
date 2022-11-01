class TodoFields {
  static final String username = 'username';
  static final String title = 'title';
  static final String done = 'done';
  static final String created = 'created';
  static final List<String> allFields = [username, title, done, created];
}

class Todo {
  final String username;
  final String title;
  bool done;
  final DateTime created;

  Todo({
    required this.username,
    required this.title,
    this.done = false,
    required this.created,
  });
}
