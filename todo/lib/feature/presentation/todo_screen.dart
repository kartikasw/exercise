import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/feature/bloc/todo_bloc.dart';
import 'package:todo/feature/domain/todo_model.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _scrollController.addListener(_loadMoreItems);
        context.read<ToDoBloc>().add(ToDoEventGetToDoList(refresh: true));
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  void _loadMoreItems() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      context.read<ToDoBloc>().add(ToDoEventGetToDoList(refresh: false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ToDo App')),
      body: BlocConsumer<ToDoBloc, ToDoState>(
        builder: (context, state) {
          if (state.status.isLoadAll && state.todos.isEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.todos.isNotEmpty) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: state.todos.length,
                    itemBuilder: (context, index) {
                      final todo = state.todos[index];
                      return _TodoItem(todo);
                    },
                  ),
                ),
                if (state.status.isLoadPage) CircularProgressIndicator(),
              ],
            );
          }

          return Center(child: Text('Empty'));
        },
        listener: (context, state) {},
      ),
    );
  }
}

class _TodoItem extends StatelessWidget {
  const _TodoItem(this.todo);

  final ToDoModel todo;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Checkbox(
          value: todo.completed,
          onChanged: (value) {
            context.read<ToDoBloc>().add(ToDoEventSelectItem(todo));
          },
        ),
        Expanded(child: Text(todo.title)),
      ],
    );
  }
}
