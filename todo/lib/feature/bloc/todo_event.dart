part of 'todo_bloc.dart';

abstract class ToDoEvent {}

class ToDoEventGetToDoList extends ToDoEvent {
  ToDoEventGetToDoList({this.refresh = true});

  final bool refresh;
}

class ToDoEventSelectItem extends ToDoEvent {
  ToDoEventSelectItem(this.item);

  final ToDoModel item;
}
