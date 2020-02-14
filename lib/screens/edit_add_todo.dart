import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_assignment/models/todo_model.dart';
import 'package:todo_assignment/sample_keys.dart';
import 'package:todo_assignment/utils/date_picker.dart';
import 'package:todo_assignment/widgets/category_choose.dart';

typedef CallBackCategory(Category category);

class EditAddTodo extends StatefulWidget {
  final TodoModel todoModel;

  EditAddTodo({this.todoModel});

  @override
  _EditAddTodoState createState() => _EditAddTodoState();
}

class _EditAddTodoState extends State<EditAddTodo> with DatePicker {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TodoModel _todoModel;

  @override
  void initState() {
    _todoModel = isEditAble ? widget.todoModel : TodoModel.add();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _saveFab(),
      appBar: AppBar(
        title: Text(
          isEditAble ? 'Edit' : 'Add',
          style: TextStyle(fontSize: 17.0),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                CategoryChooser(callBackCategory: selectedCategory),
                _title(),
                SizedBox(
                  height: 10,
                ),
                _subTitle(),
                SizedBox(
                  height: 10,
                ),
                _date(context),
                SizedBox(
                  height: 10,
                ),
                _urgentImportant(),
              ],
            ),
          )),
    );
  }

  selectedCategory(Category category) {
    _todoModel.category = category;
    print(category);
  }

  Widget _title() {
    return TextFormField(
      key: SampleKeys.titleFiled,
      validator: (val) => val.trim().isEmpty ? 'Please  titile' : null,
      initialValue: isEditAble ? _todoModel.title : '',
      decoration: InputDecoration(
        hintText: 'Title',
      ),
      onSaved: (titleText) => _todoModel.title = titleText,
    );
  }

  _subTitle() {
    return TextFormField(
      validator: (val) => val.trim().isEmpty ? 'Please sub titile' : null,
      key: SampleKeys.subtitleFiled,
      initialValue: isEditAble ? _todoModel.subTitle : '',
      decoration: InputDecoration(
        hintText: 'Sub title',
      ),
      onSaved: (subTitleText) => _todoModel.subTitle = subTitleText,
    );
  }

  _date(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.date_range),
          onPressed: () async {
            // Get date
            String date = await selectDate(
                context,
                _todoModel.endDate == null
                    ? DateTime.now()
                    : stringToDateTime(_todoModel.endDate));
            if (date != null) {
              _todoModel.endDate = date;
              setState(() {});
            }
          },
        ),
        Text(
          _todoModel.endDate ?? 'Select Date',
        )
      ],
    );
  }

  _urgentImportant() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text('Urgent'),
        Checkbox(
          value: _todoModel.urgent == 1,
          onChanged: (bool value) {
            _todoModel.urgent = value ? 1 : 0;
            setState(() {});
          },
        ),
        Text('Important'),
        Checkbox(
          value: _todoModel.important == 1,
          onChanged: (bool value) {
            _todoModel.important = value ? 1 : 0;
            setState(() {});
          },
        ),
      ],
    );
  }

  Widget _saveFab() {
    return FloatingActionButton(
      child: const Icon(Icons.check),
      onPressed: () {
        if (areAllFieldEmpty()) {
          _formKey.currentState.save();
          TodoModel todoModel = TodoModel.copyFrom(_todoModel);
          todoModel.toString();
        }
      },
    );
  }

  bool areAllFieldEmpty() {
    // Validate input text fields,date and category
    bool areTextFiedlValid = _formKey.currentState.validate();

    if (_todoModel.endDate == null) {
      Fluttertoast.showToast(msg: "Please Select Date");
      return false;
    }

    if (_todoModel.category == null) {
      Fluttertoast.showToast(msg: "Please Select Category");
      return false;
    }
    return areTextFiedlValid;
  }

  bool get isEditAble => widget.todoModel != null;
}
