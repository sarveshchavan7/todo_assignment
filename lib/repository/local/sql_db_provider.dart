import 'package:sqflite/sqflite.dart';
import 'package:todo_assignment/models/todo_model.dart';
import 'package:todo_assignment/repository/repository.dart';
import 'dart:core';
import 'package:path/path.dart';

class SqlDbProvider implements Repository<TodoModel> {
  Database db;

  final String _tableName = 'todo';

  SqlDbProvider() {
    init();
  }

  void init() async {
    try {
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'todo.db');
      db = await openDatabase(path, version: 1,
          onCreate: (Database newDb, int version) {
        newDb.execute("""
            CREATE TABLE $_tableName  
            (
              id INTEGER PRIMARY KEY,
              category INTEGER,
              title TEXT,
              sub_title TEXT,
              end_date TEXT,
              urgent INTEGER,
              important INTEGER
            )
          """);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> add(TodoModel data) async {
    int result = await db.insert(_tableName, data.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
    print(result);
  }

  @override
  Future<void> delete(TodoModel data) {
    return null;
  }

  @override
  Future<void> update(TodoModel data) {
    return null;
  }

  @override
  Future<List<TodoModel>> viewAll() async {
    List<Map<String, dynamic>> todos =
        await db.rawQuery("SELECT * FROM $_tableName");
    return todos.map((map) {
      return TodoModel.fromDb(map);
    }).toList();
  }
}

SqlDbProvider sqlDbProvider = SqlDbProvider();
