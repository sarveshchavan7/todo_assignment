import 'package:flutter/material.dart';
import 'package:todo_assignment/bloc/todo_bloc_provider.dart';
import 'package:todo_assignment/models/todo_model.dart';
import 'package:todo_assignment/routes_keys.dart';
import 'package:todo_assignment/screens/edit_add_todo.dart';
import 'package:todo_assignment/utils/date_picker.dart';
import 'package:todo_assignment/utils/widget_content_decider.dart';
import 'package:todo_assignment/widgets/filter.dart';
import 'package:uuid/uuid.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList>
    with DatePicker, WidgetContentDecider {
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
        if (snapshot.data.length == 0) {
          return Center(
            child: Text(
              'No Todos Found',
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView.builder(
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
                      TodoModel todoModel = snapshot.data[index]
                        ..compeleted = 1;
                      todoBloc.updateTodo(todoModel);
                    }
                  },
                  key: Key(uuid.v1()),
                  child: _todoListTile(snapshot, index),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _todoListTile(AsyncSnapshot snapshot, int index) {
    return Container(
      decoration: BoxDecoration(
          color: colorAsPerCondition(
              snapshot.data[index].urgent, snapshot.data[index].important)),
      child: shouldRightAlign(
              snapshot.data[index].urgent, snapshot.data[index].important)
          ? ListTile(
              onTap: () {
                onTapTodoListTile(snapshot.data[index]);
              },
              dense: true,
              title: titleText("${snapshot.data[index].title}"),
              subtitle: subTitle(
                  "${snapshot.data[index].subTitle} \n${snapshot.data[index].endDate}"),
              isThreeLine: true,
              trailing: getIconAsPerCategory(snapshot.data[index].category),
            )
          : ListTile(
              onTap: () {
                onTapTodoListTile(snapshot.data[index]);
              },
              dense: true,
              title: titleText("${snapshot.data[index].title}"),
              subtitle: subTitle(
                  "${snapshot.data[index].subTitle} \n${snapshot.data[index].endDate}"),
              isThreeLine: true,
              leading: getIconAsPerCategory(snapshot.data[index].category),
            ),
    );
  }

  void onTapTodoListTile(TodoModel todoModel) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return EditAddTodo(todoModel: todoModel);
    }));
  }

  Widget titleText(String title) {
    return Text(
      title,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15.0),
    );
  }

  Widget subTitle(String subTitle) {
    return Text(
      subTitle,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: Colors.black),
    );
  }

  Widget endDate(String endDate) {
    return Expanded(
      flex: 1,
      child: Text(
        endDate,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _addTodoFab() {
    return FloatingActionButton(
      child: const Icon(
        Icons.add,
      ),
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return EditAddTodo();
        }));
      },
    );
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
      icon: Icon(
        Icons.filter_list,
        color: Colors.indigo[200],
      ),
      onPressed: _showFilterModalSheet,
    );
  }

  Widget _compeletedTodoList() {
    return IconButton(
      icon: Icon(
        Icons.done,
        color: Colors.indigo[200],
      ),
      onPressed: () {
        Navigator.pushNamed(
          context,
          RoutesKey.completedTodo,
        );
      },
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
