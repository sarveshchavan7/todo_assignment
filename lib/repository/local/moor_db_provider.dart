import 'package:todo_assignment/models/todo_model.dart';
import 'package:todo_assignment/repository/repository.dart';

class MoorDbProvider implements Repository<TodoModel> {
  @override
  Future<void> add(TodoModel data) {
    // TODO: implement add
    return null;
  }

  @override
  Future<void> delete(TodoModel data) {
    // TODO: implement delete
    return null;
  }

  @override
  Future<void> update(TodoModel data) {
    // TODO: implement update
    return null;
  }

  @override
  Future<List<TodoModel>> viewAll() {
    // TODO: implement viewAll
    return null;
  }
}
