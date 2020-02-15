import 'package:flutter/material.dart';
import 'package:todo_assignment/bloc/todo_bloc_provider.dart';
import 'package:todo_assignment/models/todo_model.dart';
import 'package:todo_assignment/screens/edit_add_todo.dart';
import 'package:todo_assignment/utils/date_picker.dart';
import 'package:todo_assignment/widgets/filter.dart';
import 'package:uuid/uuid.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> with DatePicker {
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
        child: _actions(),
      ),
      body: _todoList(),
    );
  }

  Widget _todoList() {
    return StreamBuilder<List<TodoModel>>(
      initialData: <TodoModel>[],
      stream: todoBloc.getTodoListStream,
      builder: (BuildContext context, AsyncSnapshot<List<TodoModel>> snapshot) {
        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: Dismissible(
                onDismissed: (direction) {
                  if (DismissDirection.endToStart == direction) {
                    // Left
                    TodoModel todoModel = snapshot.data[index];
                    todoBloc.deleteTodo(todoModel.id);
                  } else {
                    // Right
                    TodoModel todoModel = snapshot.data[index]..compeleted = 1;
                    todoBloc.updateTodo(todoModel);
                  }
                },
                key: Key(uuid.v1()),
                child: ListTile(
                  title: Text(snapshot.data[index].title),
                  subtitle: Text(
                      "${snapshot.data[index].subTitle}  ${snapshot.data[index].endDate}"),
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

  Widget _actions() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _filterBottomSheet(),
        _compeletedTodoList(),
      ],
    );
  }

  Widget _filterBottomSheet() {
    return IconButton(
      icon: Icon(Icons.filter_list),
      onPressed: _showFilterModalSheet,
    );
  }

  Widget _compeletedTodoList() {
    return IconButton(
      icon: Icon(Icons.done),
      onPressed: () {},
    );
  }

  void _showFilterModalSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return FilterWidget(
            todoBloc: todoBloc,
          );
        });
  }
}
