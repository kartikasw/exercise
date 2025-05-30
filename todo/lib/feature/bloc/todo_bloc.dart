import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/feature/data/repository.dart';
import 'package:todo/feature/domain/todo_model.dart';
import 'package:injectable/injectable.dart';

part 'todo_event.dart';

part 'todo_state.dart';

@injectable
class ToDoBloc extends Bloc<ToDoEvent, ToDoState> {
  ToDoBloc(this._repository) : super(ToDoState()) {
    on<ToDoEventGetToDoList>(_onGetToDoList);
    on<ToDoEventSelectItem>(_onSelectItem);
  }

  final Repository _repository;

  Future<void> _onGetToDoList(ToDoEventGetToDoList event, Emitter<ToDoState> emit) async {
    emit(
      state.copyWith(
        status: event.refresh ? ToDoStatus.loading : ToDoStatus.loadingPagination,
        error: null,
      ),
    );

    final offset = event.refresh ? 0 : state.todos.length;
    final result = await _repository.getToDoList(offset: offset);

    result.when(
      onSuccess: (data) {
        emit(
          state.copyWith(
            status: ToDoStatus.success,
            todos: event.refresh ? data : [...state.todos, ...data],
            error: null,
          ),
        );
      },
      onError: (error) {
        emit(state.copyWith(status: ToDoStatus.error, error: error));
      },
    );
  }

  Future<void> _onSelectItem(ToDoEventSelectItem event, Emitter<ToDoState> emit) async {
    final todo = event.item;
    todo.completed = !todo.completed;
    await _repository.updateToDo(todo);
    final index = state.todos.indexWhere((element) => element.id == todo.id);
    state.todos[index] = todo;
    debugPrint(state.todos[index].completed.toString());
    emit(state.copyWith(status: ToDoStatus.success, todos: state.todos));
    emit(state.copyWith(status: ToDoStatus.initial));
  }
}
