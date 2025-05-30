import 'dart:async';

import 'package:todo/feature/domain/todo_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  Database? _database;

  DbHelper._();

  static Future<DbHelper> create() async {
    var dbHelper = DbHelper._();
    dbHelper._database = await dbHelper.initializeDb();
    return dbHelper;
  }

  Future<Database> initializeDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'todo.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: onCreate,
    );
  }

  FutureOr<Database> get _db async => _database ??= await initializeDb();

  Future<void> onCreate(Database db, int version) async {
    await db.execute(ToDoModel.createTableQuery);
  }

  Future<void> insertToDoList(List<ToDoModel> list) async {
    final db = await _db;
    await db.transaction(
      (txn) async {
        for (final item in list) {
          await txn.insert(ToDoModel.tableName, item.toMap());
        }
      },
    );
  }

  Future<void> updateToDo(ToDoModel todo) async {
    final db = await _db;
    await db.update(
      ToDoModel.tableName,
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<void> deleteData() async {
    final db = await _db;
    await db.delete(ToDoModel.tableName);
  }
}
