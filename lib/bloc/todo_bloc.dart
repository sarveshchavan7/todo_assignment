import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:todo_assignment/models/todo_model.dart';
import 'package:todo_assignment/repository/repository.dart';
import 'package:meta/meta.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
    view();
    _subscriptions = [
      _filterTodoController.listen(onFilterApplied),
    ];
  }

  add(TodoModel todoModel) async {
    try {
      int resultCode = await repository.add(todoModel);
      if (resultCode != -1) {
        view(filter: getFilterValues);
      } else {
        Fluttertoast.showToast(msg: "Failed to add todo");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  delete(int id) async {
    try {
      int resultCode = await repository.delete(id);
      if (resultCode == 1) {
        view();
      } else {
        Fluttertoast.showToast(msg: "Failed to delete todo");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  update(TodoModel todoModel) async {
    try {
      int resultCode = await repository.update(todoModel);
      if (resultCode == 1) {
        view(filter: getFilterValues);
      } else {
        Fluttertoast.showToast(msg: "Failed to update todo");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  view({Map filter}) async {
    try {
      List<TodoModel> todoList = await repository.view(filter: filter);
      (filter != null && filter.containsKey("is_complete"))
          ? _getCompletedTodoListController.sink.add(todoList)
          : _getTodoListController.sink.add(todoList);
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  void onFilterApplied(Map value) {
    view(filter: value);
  }

  close() {
    _subscriptions.forEach((subscription) => subscription.cancel());
    _getTodoListController.close();
    _filterTodoController.close();
    _getCompletedTodoListController.close();
  }
}
