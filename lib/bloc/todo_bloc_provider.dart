import 'package:flutter/material.dart';
import 'package:todo_assignment/bloc/todo_bloc.dart';
export 'package:todo_assignment/bloc/todo_bloc.dart';

class TodoBlocProvider extends StatefulWidget {
  final Widget child;
  final TodoBloc bloc;

  TodoBlocProvider({Key key, @required this.child, @required this.bloc})
      : super(key: key);

  @override
  _TodoBlocProviderState createState() => _TodoBlocProviderState();

  static TodoBloc of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_TodosBlocProvider>()
        .bloc;
  }
}

class _TodoBlocProviderState extends State<TodoBlocProvider> {
  @override
  Widget build(BuildContext context) {
    return _TodosBlocProvider(bloc: widget.bloc, child: widget.child);
  }

  @override
  void dispose() {
    widget.bloc.close();
    super.dispose();
  }
}

class _TodosBlocProvider extends InheritedWidget {
  final TodoBloc bloc;

  _TodosBlocProvider({
    Key key,
    @required this.bloc,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_TodosBlocProvider old) => bloc != old.bloc;
}
