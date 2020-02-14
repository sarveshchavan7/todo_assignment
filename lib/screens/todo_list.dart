import 'package:flutter/material.dart';
import 'package:todo_assignment/screens/edit_add_todo.dart';
import 'package:todo_assignment/utils/date_picker_mixin.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> with DatePickerMixin {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _addTodoFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _datePicker(context),
            _categoryChooser(),
          ],
        ),
      ),
      body: _todoList(),
    );
  }

  Widget _datePicker(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.date_range),
      onPressed: () async {
        selectedDate =
            await selectDate(context, selectedDate) ?? DateTime.now();
      },
    );
  }

  Widget _categoryChooser() {
    return IconButton(
      icon: Icon(Icons.category),
      onPressed: () {},
    );
  }

  Widget _todoList() {
    return Container(
      child: Center(
        child: Text('data'),
      ),
    );
  }

  Widget _addTodoFab() {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return EditAddTodo();
        }));
      },
    );
  }
}
