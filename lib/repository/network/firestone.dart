import 'package:todo_assignment/models/todo_model.dart';
import 'package:todo_assignment/repository/repository.dart';

class FireStoneStorage extends Repository<TodoModel> {
  @override
  Future<int> add(TodoModel data) {
    // TODO: implement add
    return null;
  }

  @override
  Future<int> delete(TodoModel data) {
    // TODO: implement delete
    return null;
  }

  @override
  Future<int> update(TodoModel data) {
    // TODO: implement update
    return null;
  }

  @override
  Future<List<TodoModel>> view(Map filter) {
    // TODO: implement viewAll
    return null;
  }
}
