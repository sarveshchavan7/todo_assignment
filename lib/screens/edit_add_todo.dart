import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_assignment/bloc/todo_bloc_provider.dart';
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
  FocusNode focusNode;
  TodoModel _todoModel;
  TodoBloc todoBloc;

  @override
  void initState() {
    focusNode = FocusNode();
    _todoModel = isEditAble ? widget.todoModel : TodoModel.add();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    todoBloc = TodoBlocProvider.of(context);
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
                CategoryChooser(
                  callBackCategory: selectedCategory,
                  currentCategory: _todoModel.category,
                ),
                SizedBox(
                  height: 20,
                ),
                _title(),
                SizedBox(
                  height: 15,
                ),
                _subTitle(),
                SizedBox(
                  height: 25,
                ),
                _date(context),
                SizedBox(
                  height: 15,
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
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        autofocus: true,
        key: SampleKeys.titleFiled,
        validator: (val) => val.trim().isEmpty ? 'Please  titile' : null,
        initialValue: isEditAble ? _todoModel.title : '',
        decoration: InputDecoration(
          hintText: 'Title',
        ),
        onSaved: (titleText) => _todoModel.title = titleText,
      ),
    );
  }

  _subTitle() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        autofocus: true,
        focusNode: focusNode,
        validator: (val) => val.trim().isEmpty ? 'Please sub titile' : null,
        key: SampleKeys.subtitleFiled,
        initialValue: isEditAble ? _todoModel.subTitle : '',
        decoration: InputDecoration(
          hintText: 'Sub title',
        ),
        onSaved: (subTitleText) => _todoModel.subTitle = subTitleText,
      ),
    );
  }

  _date(BuildContext context) {
    focusNode.unfocus();
    return Container(
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.indigo[400]),
      ),
      child: GestureDetector(
        onTap: () async {
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
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 10,
            ),
            Icon(Icons.date_range),
            SizedBox(
              width: 30,
            ),
            Text(
              _todoModel.endDate ?? 'Select Date',
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  _urgentImportant() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.indigo[400]),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Checkbox(
            value: _todoModel.urgent == 1,
            onChanged: (bool value) {
              _todoModel.urgent = value ? 1 : 0;
              setState(() {});
            },
          ),
          Text('Urgent', style: TextStyle(fontWeight: FontWeight.bold)),
          Checkbox(
            value: _todoModel.important == 1,
            onChanged: (bool value) {
              _todoModel.important = value ? 1 : 0;
              setState(() {});
            },
          ),
          Text('Important', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _saveFab() {
    return FloatingActionButton(
      child: const Icon(Icons.check),
      onPressed: () {
        if (areAllFieldEmpty()) {
          _formKey.currentState.save();
          TodoModel todoModel = TodoModel.copyFrom(_todoModel);
          if (isEditAble) {
            todoBloc.updateTodo(todoModel);
          } else {
            todoBloc.addTodo(todoModel);
          }

          Navigator.pop(context);
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
