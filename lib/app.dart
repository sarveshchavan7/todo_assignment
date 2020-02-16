import 'package:flutter/material.dart';
import 'package:todo_assignment/bloc/todo_bloc_provider.dart';
import 'package:todo_assignment/repository/repository.dart';
import 'package:todo_assignment/routes_keys.dart';
import 'package:todo_assignment/screens/completed_todo.dart';
import 'package:todo_assignment/screens/todo_list.dart';
import 'package:meta/meta.dart';

class App extends StatelessWidget {
  final Repository repository;
  final TodoBloc todoBloc;
  App({Key key, @required this.repository})
      : todoBloc = TodoBloc(repository: repository),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TodoBlocProvider(
      bloc: TodoBloc(repository: this.repository),
      child: MaterialApp(
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.dark,
          primaryColor: Colors.indigo[200],
          accentColor: Colors.indigo[400],
        ),
        routes: {
          RoutesKey.todoList: (context) {
            return TodoList();
          },
          RoutesKey.completedTodo: (context) {
            final todoBloc = TodoBlocProvider.of(context);
            todoBloc.viewTodo(
              filter: {
                "is_complete": 1,
              },
            );
            return CompletedTodo(
              todoBloc: todoBloc,
            );
          },
        },
      ),
    );
  }
}
