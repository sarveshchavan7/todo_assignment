import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:todo_assignment/models/todo_model.dart';
import 'package:todo_assignment/repository/repository.dart';
import 'package:meta/meta.dart';

class TodoBloc {
  final Repository repository;

  final _getTodoListController = BehaviorSubject<List<TodoModel>>();
  final _getCompletedTodoListController = BehaviorSubject<List<TodoModel>>();
  final _filterTodoController = BehaviorSubject<Map>.seeded({});

  // Input
  Sink<Map> get applyFilter => _filterTodoController.sink;

  // Output
  Stream get filterStream => _filterTodoController.stream;
  Stream get getTodoListStream => _getTodoListController.stream;
  Stream get getCompletedTodoListStream =>
      _getCompletedTodoListController.stream;
  Map get getFilterValues => _filterTodoController.value;

  // Cleanup
  List<StreamSubscription<dynamic>> _subscriptions;

  TodoBloc({@required this.repository}) {
    viewTodo();
    _subscriptions = [
      _filterTodoController.listen(onFilterApplied),
    ];
  }

  addTodo(TodoModel todoModel) async {
    try {
      int resultCode = await repository.add(todoModel);
      if (resultCode != -1) {
        viewTodo(filter: getFilterValues);
      } else {
        //TODO: toast message
      }
    } catch (e) {
      print(e);
    }
  }

  deleteTodo(int id) async {
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
      viewTodo(filter: getFilterValues);
    } else {
      //TODO: toast message
    }
  }

  void viewTodo({Map filter}) async {
    List<TodoModel> todoList = await repository.view(filter: filter);
    if (filter != null && filter.containsKey("is_complete")) {
      _getCompletedTodoListController.sink.add(todoList);
    } else {
      _getTodoListController.sink.add(todoList);
    }
  }

  void onFilterApplied(Map value) {
    viewTodo(filter: value);
  }

  close() {
    _subscriptions.forEach((subscription) => subscription.cancel());
    _getTodoListController.close();
    _filterTodoController.close();
    _getCompletedTodoListController.close();
  }
}
