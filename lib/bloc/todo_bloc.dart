import 'package:rxdart/rxdart.dart';
import 'package:todo_assignment/models/todo_model.dart';
import 'package:todo_assignment/repository/repository.dart';
import 'package:meta/meta.dart';

class TodoBloc {
  final Repository repository;

  TodoBloc({@required this.repository});

  final _addTodoController = BehaviorSubject<TodoModel>();

  // Inputs

  // Outputs

  void close() {
    _addTodoController.close();
  }
}
