import 'package:sqflite/sqflite.dart';
import 'package:todo_assignment/models/todo_model.dart';
import 'package:todo_assignment/repository/repository.dart';
import 'dart:core';
import 'package:path/path.dart';

class SqlDbProvider implements Repository<TodoModel> {
  Database _db;

  final String _tableName = 'todo';

  init() async {
    try {
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'todo.db');
      _db = await openDatabase(path, version: 1,
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
  Future<int> add(TodoModel data) async {
    try {
      int result = await _db.insert(_tableName, data.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
      return result;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<int> delete(TodoModel data) {
    return null;
  }

  @override
  Future<int> update(TodoModel data) {
    return null;
  }

  @override
  Future<List<TodoModel>> view(Map filter) async {
    List<Map<String, dynamic>> todos =
        await _db.rawQuery("""SELECT * FROM $_tableName 
        ORDER BY urgent DESC""");
    return todos.map((map) {
      return TodoModel.fromDb(map);
    }).toList();
  }
}

SqlDbProvider sqlDbProvider = SqlDbProvider();
