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
  String _date;
  Map _filterMap = {};
  TodoBloc _todoBloc;

  @override
  void initState() {
    super.initState();
    _todoBloc = widget.todoBloc;
    _filterMap.addAll(_todoBloc.getFilterValues);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map>(
        initialData: {},
        stream: _todoBloc.filterStream,
        builder: (context, AsyncSnapshot<Map> snapshot) {
          return Container(
            height: 380,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _backButton(),
                _datePicker(context),
                SizedBox(
                  height: 15,
                ),
                CategoryChooser(
                  callBackCategory: _onCategorySelected,
                  currentCategory: TodoModel.emptyModel()
                      .getCategoryEnum(cast<int>(_filterMap["category"])),
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
        _date = await selectDate(
          context,
          _date != null ? stringToDateTime(_date) : DateTime.now(),
        );
        if (_date != null) {
          _filterMap["end_date"] = _date;
          setState(() {});
        }
      },
      title: Text(
        "${_filterMap['end_date'] ?? 'Select Date'}",
        style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  _onCategorySelected(Category category) {
    _filterMap["category"] = TodoModel.emptyModel().getCategoryInt(category);
    setState(() {});
  }

  Widget _clearFilter() {
    return ListTile(
      leading: Icon(Icons.clear, color: Colors.red),
      onTap: () {
        if (_filterMap.isNotEmpty) {
          // Clear filter
          _todoBloc.applyFilter.add({});
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
      onTap: _isFilterChanged()
          ? () {
              _todoBloc.applyFilter.add(_filterMap);
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

  bool _isFilterChanged() {
    return (_filterMap["end_date"] != _todoBloc.getFilterValues["end_date"] ||
        _filterMap["category"] != _todoBloc.getFilterValues["category"]);
  }

  Widget _backButton() {
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
