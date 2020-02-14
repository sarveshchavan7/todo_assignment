import 'package:flutter/material.dart';
import 'package:todo_assignment/app.dart';
import 'package:todo_assignment/repository/local/sql_db_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App(
    repository: SqlDbProvider(),
  ));
}
