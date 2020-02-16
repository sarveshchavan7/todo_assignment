import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:todo_assignment/bloc/todo_bloc_provider.dart';
import 'package:todo_assignment/models/todo_model.dart';
import 'package:todo_assignment/utils/widget_content_decider.dart';

class CompletedTodo extends StatefulWidget {
  final TodoBloc todoBloc;

  const CompletedTodo({Key key, @required this.todoBloc}) : super(key: key);

  @override
  _CompletedTodoState createState() => _CompletedTodoState();
}

class _CompletedTodoState extends State<CompletedTodo>
    with WidgetContentDecider {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Completed Todos"),
      ),
      body: _todoListTile(),
    );
  }

  Widget _todoListTile() {
    return StreamBuilder<List<TodoModel>>(
        initialData: <TodoModel>[],
        stream: widget.todoBloc.getCompletedTodoListStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<TodoModel>> snapshot) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Container(
                      decoration: BoxDecoration(
                          color: getcolorAsPerCondition(
                              snapshot.data[index].urgent,
                              snapshot.data[index].important)),
                      child: shouldRightAlign(snapshot.data[index].urgent,
                              snapshot.data[index].important)
                          ? ListTile(
                              dense: true,
                              title: _titleText("${snapshot.data[index].title}"),
                              subtitle: _subTitle(
                                  "${snapshot.data[index].subTitle} \n${snapshot.data[index].endDate}"),
                              isThreeLine: true,
                              trailing: getIconAsPerCategory(
                                  snapshot.data[index].category),
                            )
                          : ListTile(
                              dense: true,
                              title: _titleText("${snapshot.data[index].title}"),
                              subtitle: _subTitle(
                                  "${snapshot.data[index].subTitle} \n${snapshot.data[index].endDate}"),
                              isThreeLine: true,
                              leading: getIconAsPerCategory(
                                  snapshot.data[index].category),
                            ),
                    ),
                  );
                }),
          );
        });
  }

  Widget _titleText(String title) {
    return Text(
      title,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15.0),
    );
  }

  Widget _subTitle(String subTitle) {
    return Text(
      subTitle,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: Colors.black),
    );
  }
}
