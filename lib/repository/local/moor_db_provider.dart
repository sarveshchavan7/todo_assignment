import 'package:todo_assignment/models/todo_model.dart';
import 'package:todo_assignment/repository/repository.dart';

/// Moor local storage
/* 
  Current we are using Sqflite
  Note - If in futute if we switch to some other storage style 
  we just have to provide method implementation and we are good to go
 */
class MoorDbProvider implements Repository<TodoModel> {
  @override
  Future<int> add(TodoModel data) {
    // TODO: implement add
    return null;
  }

  @override
  Future<int> delete(int id) {
    // TODO: implement delete
    return null;
  }

  @override
  Future<int> update(TodoModel data) {
    // TODO: implement update
    return null;
  }

  @override
  Future<List<TodoModel>> view({Map filter}) {
    // TODO: implement viewAll
    return null;
  }
}
