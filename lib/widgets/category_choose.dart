import 'package:flutter/material.dart';
import 'package:todo_assignment/models/todo_model.dart';
import 'package:todo_assignment/screens/edit_add_todo.dart';
import 'package:meta/meta.dart';

class CategoryChooser extends StatefulWidget {
  final CallBackCategory callBackCategory;

  const CategoryChooser({Key key, @required this.callBackCategory})
      : super(key: key);

  @override
  _CategoryChooserState createState() => _CategoryChooserState();
}

class _CategoryChooserState extends State<CategoryChooser> {
  Category category;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        IconButton(
          color: selectedColor(Category.work),
          icon: Icon(Icons.work),
          onPressed: () {
            setState(() {
              category = Category.work;
            });
            widget.callBackCategory(category);
          },
        ),
        IconButton(
          color: selectedColor(Category.personal),
          icon: Icon(Icons.person),
          onPressed: () {
            setState(() {
              category = Category.personal;
            });
            widget.callBackCategory(category);
          },
        ),
        IconButton(
          color: selectedColor(Category.social),
          icon: Icon(Icons.people),
          onPressed: () {
            setState(() {
              category = Category.social;
            });
            widget.callBackCategory(category);
          },
        ),
      ],
    );
  }

  Color selectedColor(Category category) {
    return category == this.category ? Colors.red : Colors.grey;
  }
}
