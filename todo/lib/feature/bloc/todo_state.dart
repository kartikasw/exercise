part of 'todo_bloc.dart';

enum ToDoStatus {
  initial,
  loading,
  loadingPagination,
  success,
  error;

  bool get isLoadAll => this == loading;

  bool get isLoadPage => this == loadingPagination;
}

class ToDoState {
  ToDoState({
    this.status = ToDoStatus.initial,
    this.todos = const [],
    this.selected,
    this.error,
  });

  final ToDoStatus status;
  List<ToDoModel> todos;
  final ToDoModel? selected;
  final String? error;

  ToDoState copyWith({
    ToDoStatus? status,
    List<ToDoModel>? todos,
    ToDoModel? selected,
    String? error,
  }) {
    return ToDoState(
      status: status ?? this.status,
      todos: todos ?? this.todos,
      selected: selected,
      error: error,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ToDoState &&
        other.status == status &&
        _listEquals(other.todos, todos) &&
        other.selected == selected &&
        other.error == error;
  }

  @override
  int get hashCode {
    return status.hashCode ^ _listHashCode(todos) ^ (selected?.hashCode ?? 0) ^ (error?.hashCode ?? 0);
  }

  bool _listEquals(List a, List b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  int _listHashCode(List list) {
    int hash = 0;
    for (var item in list) {
      hash = hash ^ item.hashCode;
    }
    return hash;
  }
}
