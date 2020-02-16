import 'package:flutter/material.dart';
import 'package:todo_assignment/bloc/todo_bloc_provider.dart';
import 'package:todo_assignment/models/todo_model.dart';
import 'package:todo_assignment/utils/date_picker.dart';
import 'package:todo_assignment/widgets/category_choose.dart';

class FilterWidget extends StatefulWidget {
  final TodoBloc todoBloc;

  const FilterWidget({Key key, @required this.todoBloc}) : super(key: key);

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> with DatePicker {
  String date;
  Map filterMap = {};
  TodoBloc todoBloc;

  @override
  void initState() {
    super.initState();
    todoBloc = widget.todoBloc;
    filterMap.addAll(todoBloc.getFilterValues);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map>(
        initialData: {},
        stream: todoBloc.filterStream,
        builder: (context, AsyncSnapshot<Map> snapshot) {
          return Container(
            height: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _clearFilter(),
                _datePicker(context),
                CategoryChooser(
                  callBackCategory: onCategorySelected,
                  currentCategory: TodoModel.add()
                      .getCategoryEnum(cast<int>(filterMap["category"])),
                ),
                _saveFilter(),
              ],
            ),
          );
        });
  }

  Widget _datePicker(BuildContext context) {
    return ListTile(
      leading: IconButton(
        icon: Icon(Icons.date_range),
        onPressed: () async {
          date = await selectDate(
            context,
            date != null ? stringToDateTime(date) : DateTime.now(),
          );
          if (date != null) {
            filterMap["end_date"] = date;
            setState(() {});
          }
        },
      ),
      title: Text("${filterMap['end_date'] ?? 'Select Date'}"),
    );
  }

  onCategorySelected(Category category) {
    filterMap["category"] = TodoModel.add().getCategoryInt(category);
    setState(() {});
  }

  Widget _clearFilter() {
    return ListTile(
      leading: IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          if (filterMap.isNotEmpty) {
            // Clear filter
            todoBloc.applyFilter.add({});
          }
          Navigator.pop(context);
        },
      ),
      title: Text('Clear'),
    );
  }

  T cast<T>(x) => x is T ? x : null;

  Widget _saveFilter() {
    return Center(
      child: RaisedButton(
          color: Colors.lightBlueAccent,
          child: Text('Apply Filter'),
          onPressed: isFilterChanged
              ? () {
                  todoBloc.applyFilter.add(filterMap);
                  Navigator.pop(context);
                }
              : null),
    );
  }

  bool get isFilterChanged =>
      filterMap["end_date"] != todoBloc.getFilterValues["end_date"] ||
      filterMap["category"] != todoBloc.getFilterValues["category"];
}
