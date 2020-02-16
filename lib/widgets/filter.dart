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
            height: 380,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                backButton(),
                _datePicker(context),
                SizedBox(
                  height: 15,
                ),
                CategoryChooser(
                  callBackCategory: onCategorySelected,
                  currentCategory: TodoModel.add()
                      .getCategoryEnum(cast<int>(filterMap["category"])),
                ),
                SizedBox(
                  height: 15,
                ),
                _saveFilter(),
                _clearFilter(),
              ],
            ),
          );
        });
  }

  Widget _datePicker(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.date_range),
      onTap: () async {
        date = await selectDate(
          context,
          date != null ? stringToDateTime(date) : DateTime.now(),
        );
        if (date != null) {
          filterMap["end_date"] = date;
          setState(() {});
        }
      },
      title: Text(
        "${filterMap['end_date'] ?? 'Select Date'}",
        style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  onCategorySelected(Category category) {
    filterMap["category"] = TodoModel.add().getCategoryInt(category);
    setState(() {});
  }

  Widget _clearFilter() {
    return ListTile(
      leading: Icon(Icons.clear, color: Colors.red),
      onTap: () {
        if (filterMap.isNotEmpty) {
          // Clear filter
          todoBloc.applyFilter.add({});
        }
        Navigator.pop(context);
      },
      title: Text(
        'Clear Filter',
        style: TextStyle(
            fontSize: 17.0, fontWeight: FontWeight.bold, color: Colors.red),
      ),
    );
  }

  Widget _saveFilter() {
    return ListTile(
      leading: Icon(Icons.done),
      onTap: isFilterChanged
          ? () {
              todoBloc.applyFilter.add(filterMap);
              Navigator.pop(context);
            }
          : null,
      title: Text(
        'Apply Filter',
        style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  T cast<T>(x) => x is T ? x : null;

  bool get isFilterChanged =>
      filterMap["end_date"] != todoBloc.getFilterValues["end_date"] ||
      filterMap["category"] != todoBloc.getFilterValues["category"];

  Widget backButton() {
    return ListTile(
      leading: Icon(Icons.chevron_left),
      title: Text(
        'Back',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19.0),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
