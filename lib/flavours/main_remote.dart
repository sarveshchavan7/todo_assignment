import 'package:flutter/material.dart';
import 'package:todo_assignment/app.dart';
import 'package:todo_assignment/repository/network/firestone.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App(
    repository: FireStoneStorage(),
  ));
}
