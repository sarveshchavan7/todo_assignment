import 'package:flutter/material.dart';
import 'package:todo_assignment/bloc/todo_bloc_provider.dart';
import 'package:todo_assignment/models/todo_model.dart';
import 'package:todo_assignment/screens/edit_add_todo.dart';
import 'package:todo_assignment/utils/date_picker.dart';
import 'package:uuid/uuid.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> with DatePicker {
  DateTime selectedDate = DateTime.now();
  TodoBloc todoBloc;
  var uuid = new Uuid();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    todoBloc = TodoBlocProvider.of(context);
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
    return StreamBuilder<List<TodoModel>>(
      initialData: <TodoModel>[],
      stream: todoBloc.todos,
      builder: (BuildContext context, AsyncSnapshot<List<TodoModel>> snapshot) {
        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: Dismissible(
                onDismissed: (direction) {
                  TodoModel todoModel = snapshot.data[index]..compeleted = 1;
                  todoBloc.updateTodo(todoModel);
                },
                key: Key(uuid.v1()),
                child: ListTile(
                  title: Text(snapshot.data[index].title),
                  subtitle: Text(
                      '${snapshot.data[index].subTitle}  ${snapshot.data[index].endDate}'),
                  leading: getIconAsPerCategory(snapshot.data[index].category),
                ),
              ),
            );
          },
        );
      },
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

  Widget getIconAsPerCategory(Category category) {
    switch (category) {
      case Category.work:
        return Icon(Icons.work);
        break;
      case Category.social:
        return Icon(Icons.people);
        break;
      case Category.personal:
        return Icon(Icons.person);
        break;
      default:
        return Icon(Icons.work);
        break;
    }
  }
}
