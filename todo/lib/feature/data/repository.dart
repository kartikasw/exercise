import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:todo/feature/data/local/db_helper.dart';
import 'package:todo/feature/data/remote/http_client.dart';
import 'package:todo/feature/data/response.dart';
import 'package:todo/feature/domain/todo_model.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class Repository {
  const Repository(this._remote, this._dbHelper);

  final CustomHttpClient _remote;

  final DbHelper _dbHelper;

  Future<Result<List<ToDoModel>>> getToDoList({int offset = 0}) async {
    try {
      final url = Uri.parse('https://jsonplaceholder.typicode.com/todos?_start=$offset&_limit=10');
      final result = await _remote.client.get(url);

      if (result.statusCode == HttpStatus.ok) {
        final response = json.decode(result.body);

        if (response is List<dynamic>) {
          final list = response.map((e) => ToDoModel.fromJson(e)).toList();
          await _dbHelper.deleteData();
          await _dbHelper.insertToDoList(list);
          return ResultSuccess(list);
        }
      }

      return ResultSuccess([]);
    } on TimeoutException catch (e) {
      return ResultError(e.toString());
    } catch (e) {
      return ResultError(e.toString());
    }
  }

  Future<void> updateToDo(ToDoModel todo) async {
    await _dbHelper.updateToDo(todo);
  }
}
