import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:todo_assignment/models/todo_model.dart';
import 'package:todo_assignment/repository/repository.dart';
import 'package:meta/meta.dart';

class TodoBloc {
  final Repository repository;

  final _getTodoListController = BehaviorSubject<List<TodoModel>>();
  final _filterTodoController = BehaviorSubject<Map>();

  // Input
  Sink<Map> get applyFilter => _filterTodoController.sink;

  // Output
  Stream get filterStream => _filterTodoController.stream;
  Stream get getTodoListStream => _getTodoListController.stream;

  // Cleanup
  List<StreamSubscription<dynamic>> _subscriptions;

  TodoBloc({@required this.repository}) {
    _subscriptions = [
      _filterTodoController.listen(onFilterApplied),
    ];
  }

  addTodo(TodoModel todoModel) async {
    try {
      int resultCode = await repository.add(todoModel);
      if (resultCode != -1) {
        viewTodo();
      } else {
        //TODO: toast message
      }
    } catch (e) {
      print(e);
    }
  }

  deleteTodo(String id) async {
    int resultCode = await repository.delete(id);
    if (resultCode == 1) {
      viewTodo();
    } else {
      //TODO: toast message
    }
  }

  updateTodo(TodoModel todoModel) async {
    int resultCode = await repository.update(todoModel);
    if (resultCode == 1) {
      viewTodo();
    } else {
      //TODO: toast message
    }
  }

  viewTodo({Map filter}) async {
    List<TodoModel> todoList = await repository.view(filter);
    _getTodoListController.sink.add(todoList);
  }

  void onFilterApplied(Map filter) {
    viewTodo(filter: filter);
  }

  Stream<List<TodoModel>> get todos {
    return Stream.fromFuture(repository.view({}));
  }

  close() {
    _subscriptions.forEach((subscription) => subscription.cancel());
    _getTodoListController.close();
    _filterTodoController.close();
  }
}
