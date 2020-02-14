import 'package:flutter/material.dart';
import 'package:todo_assignment/bloc/todo_bloc_provider.dart';
import 'package:todo_assignment/repository/repository.dart';
import 'package:meta/meta.dart';
import 'package:todo_assignment/routes_keys.dart';
import 'package:todo_assignment/screens/todo_list.dart';

class App extends StatelessWidget {
  final Repository repository;

  const App({Key key, @required this.repository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TodoBlocProvider(
      bloc: TodoBloc(repository: this.repository),
      child: MaterialApp(
        routes: {
          RoutesKey.todoList: (context) {
            return TodoList();
          },
        },
      ),
    );
  }
}
