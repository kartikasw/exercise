class ToDoModel {
  ToDoModel({
    this.id = 0,
    this.title = '',
    this.completed = false,
  });

  final int id;
  final String title;
  bool completed;

  factory ToDoModel.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'id': int id, 'title': String title, 'completed': bool completed} => ToDoModel(
          id: id,
          title: title,
          completed: completed,
        ),
      _ => throw const FormatException('Failed to load todo.'),
    };
  }

  factory ToDoModel.fromDb(Map<String, dynamic> json) {
    return switch (json) {
      {'id': int id, 'title': String title, 'completed': int completed} => ToDoModel(
          id: id,
          title: title,
          completed: completed == 1,
        ),
      _ => throw const FormatException('Failed to load todo.'),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'completed': completed ? 1 : 0,
    };
  }

  static const String createTableQuery = '''
  CREATE TABLE $tableName (
  id INTEGER PRIMARY KEY, 
  title TEXT, 
  completed INTEGER
  );
  ''';

  static const tableName = 'ToDo';
}
