import 'package:flutter/material.dart';
import 'package:todo_assignment/app.dart';
import 'package:todo_assignment/repository/local/sql_db_provider.dart';

/// Build flavours with local storage  
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sqlDbProvider.init();
  runApp(App(
    repository: sqlDbProvider,
  ));
}
