import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:todo/feature/data/local/db_helper.dart';
import 'package:todo/feature/data/remote/http_client.dart';
import 'package:todo/feature/data/repository.dart';
import 'package:todo/feature/data/response.dart';
import 'package:todo/feature/domain/todo_model.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'repository_test.mocks.dart';

@GenerateMocks([CustomHttpClient, Client, DbHelper])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Repository', () {
    late final Client client;
    late final CustomHttpClient remote;
    late final DbHelper dbHelper;
    late final Repository repository;

    setUpAll(() {
      remote = MockCustomHttpClient();
      client = MockClient();
      dbHelper = MockDbHelper();
      when(remote.client).thenReturn(client);
      repository = Repository(remote, dbHelper);
    });

    test('GIVEN get todo list WHEN refresh THEN return list', () async {
      final url = Uri.parse('https://jsonplaceholder.typicode.com/todos?_start=0&_limit=10');
      when(client.get(url)).thenAnswer((_) async => Response(json.encode({}), 200));

      final result = await repository.getToDoList();
      result as ResultSuccess<List<ToDoModel>>;
      expect(result.data.length, 0);
    });
  });
}
