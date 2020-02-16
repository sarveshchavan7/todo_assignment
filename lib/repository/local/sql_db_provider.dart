import 'package:sqflite/sqflite.dart';
import 'package:todo_assignment/models/todo_model.dart';
import 'package:todo_assignment/repository/repository.dart';
import 'dart:core';
import 'package:path/path.dart';

/// SQFlite implementation
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
  Future<int> delete(int id) async {
    try {
      int result =
          await _db.rawDelete("DELETE FROM $_tableName WHERE id = ?", [id]);
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
  Future<List<TodoModel>> view({Map filter}) async {
    filter ??= {};
    List args = [];
    String sql = """SELECT * FROM $_tableName """;

    String where = "WHERE";
    // Complete
    if (filter.containsKey("is_complete")) {
      where += " compeleted = ? ";
      args.add(filter["is_complete"]);
    } else {
      where += " compeleted IS NULL ";
    }
    // End date filter
    if (filter.containsKey("end_date")) {
      if (where != "WHERE") where += "AND";
      where += " end_date = ? ";
      args.add(filter["end_date"]);
    }
    // Category filter
    if (filter.containsKey("category")) {
      if (where != "WHERE") where += "AND";
      where += " category = ? ";
      args.add(filter["category"]);
    }
    if (where != "WHERE") {
      sql += where;
    }
    // Order by urgent
    sql += """ORDER BY ((CASE urgent
                          WHEN 1 THEN 0
                          WHEN 0 THEN 1
                          END) || 
                        (CASE important
                          WHEN 1 THEN 0
                          WHEN 0 THEN 1
                          END)
                          ) """;
    List<Map<String, dynamic>> todos = await _db.rawQuery(sql, args);
    return todos.map((map) {
      return TodoModel.fromDb(map);
    }).toList();
  }
}

SqlDbProvider sqlDbProvider = SqlDbProvider();
