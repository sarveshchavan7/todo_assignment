import 'package:flutter/material.dart';
import 'package:todo_assignment/models/todo_model.dart';
import 'package:todo_assignment/sample_keys.dart';
import 'package:todo_assignment/utils/date_picker_mixin.dart';
import 'package:todo_assignment/widgets/category_choose.dart';

typedef CallBackCategory(Category category);

class EditAddTodo extends StatefulWidget {
  final TodoModel todoModel;

  EditAddTodo({this.todoModel});

  @override
  _EditAddTodoState createState() => _EditAddTodoState();
}

class _EditAddTodoState extends State<EditAddTodo> with DatePickerMixin {
  TodoModel _todoModel;
  String _titleText;
  String _subTitleText;
  String _endDate;
  bool _urgent;
  bool _important;
  Category _category;

  @override
  void initState() {
    _todoModel = isEditAble ? widget.todoModel : TodoModel.add();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditAble ? 'Edit' : 'Add',
          style: TextStyle(fontSize: 17.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            CategoryChooser(callBackCategory: selectedCategory),
            _title(),
            SizedBox(
              height: 10,
            ),
            _subTitle(),
            _date(context),
            _urgentImportant(),
          ],
        ),
      ),
    );
  }

  selectedCategory(Category category) {
    _todoModel.category = category;
    print(category);
  }

  Widget _title() {
    return TextFormField(
      key: SampleKeys.titleFiled,
      decoration: InputDecoration(
        hintText: 'Title',
      ),
      onSaved: (titleText) {
        _titleText = titleText;
      },
    );
  }

  _subTitle() {
    return TextFormField(
      key: SampleKeys.subtitleFiled,
      decoration: InputDecoration(
        hintText: 'Sub title',
      ),
      onSaved: (subTitleText) {
        _subTitleText = subTitleText;
      },
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
    return Row();
  }

  bool get isEditAble => widget.todoModel != null;
}
