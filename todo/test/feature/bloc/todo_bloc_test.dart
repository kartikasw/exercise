import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/feature/bloc/todo_bloc.dart';
import 'package:todo/feature/data/repository.dart';
import 'package:todo/feature/data/response.dart';
import 'package:todo/feature/domain/todo_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'todo_bloc_test.mocks.dart';

@GenerateMocks([Repository])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ToDoBloc', () {
    late final Repository repository;
    late ToDoBloc toDoBloc;

    setUpAll(() {
      repository = MockRepository();
    });

    setUp(() {
      toDoBloc = ToDoBloc(repository);
    });

    blocTest(
      'GIVEN get todo list even WHEN refresh THEN emits success',
      build: () {
        final list = ResultSuccess([ToDoModel(), ToDoModel()]);
        provideDummy<Result<List<ToDoModel>>>(ResultSuccess([]));
        when(repository.getToDoList()).thenAnswer((_) async => list);
        return toDoBloc;
      },
      act: (bloc) => bloc.add(ToDoEventGetToDoList()),
      expect: () => [
        ToDoState(status: ToDoStatus.loading),
        isA<ToDoState>().having((data) => data.status, '', ToDoStatus.success).having(
              (data) => data.todos.length,
              '',
              2,
            ),
      ],
    );
  });
}
