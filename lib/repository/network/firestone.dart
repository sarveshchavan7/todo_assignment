import 'package:todo_assignment/models/todo_model.dart';
import 'package:todo_assignment/repository/repository.dart';

/// Fire Stone Storage (FireBase) local storage
/* 
  Current we are using Sqflite
  Note - If in futute if we switch to some other storage style (remote storage)
  we just have to provide method implementation and we are good to go
 */
class FireStoneStorage extends Repository<TodoModel> {
  @override
  Future<int> add(TodoModel data) {
    // TODO: implement add
    return null;
  }

  @override
  Future<int> delete(int data) {
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
