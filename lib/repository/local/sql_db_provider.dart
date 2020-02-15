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
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              category INTEGER,
              title TEXT,
              sub_title TEXT,
              end_date TEXT,
              urgent INTEGER,
              important INTEGER,
              compeleted INTEGER NULLABLE
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
  Future<int> delete(TodoModel data) async {
    try {
      int result = await _db
          .rawDelete("DELETE FROM $_tableName WHERE id = ?", [data.id]);
      return result;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<int> update(TodoModel data) async {
    try {
      int result = await _db.update(_tableName, data.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
      return result;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<List<TodoModel>> view(Map filter) async {
    List args = [];
    String sql = """SELECT * FROM $_tableName """;
    // Is compeleted
    if (filter.containsKey('is_compeleted')) {
      sql += "WHERE compeleted IS NULL";
      args.add(filter['is_compeleted']);
    }
    // End Date filter
    if (filter.containsKey('end_date')) {
      sql += "WHERE end_date = ?";
      args.add(filter['end_date']);
    }
    // Category filyer
    if (filter.containsKey('category')) {
      sql += "WHERE category = ?";
      args.add(filter['category']);
    }
    // Order by urgent
    sql += "ORDER BY urgent DESC";
    List<Map<String, dynamic>> todos = await _db.rawQuery(sql, args);
    return todos.map((map) {
      return TodoModel.fromDb(map);
    }).toList();
  }
}

SqlDbProvider sqlDbProvider = SqlDbProvider();
