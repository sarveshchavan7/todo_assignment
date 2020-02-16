import 'package:flutter/material.dart';
import 'package:todo_assignment/models/todo_model.dart';
import 'package:todo_assignment/screens/edit_add_todo.dart';
import 'package:meta/meta.dart';

class CategoryChooser extends StatefulWidget {
  final CallBackCategory callBackCategory;
  final Category currentCategory;

  const CategoryChooser(
      {Key key, @required this.callBackCategory, this.currentCategory})
      : super(key: key);

  @override
  _CategoryChooserState createState() => _CategoryChooserState();
}

class _CategoryChooserState extends State<CategoryChooser> {
  Category category;

  bool get isCategorySelected => widget.currentCategory != null;

  @override
  void initState() {
    category = isCategorySelected ? widget.currentCategory : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          'Select Category',
          style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  setState(() {
                    category = Category.work;
                  });
                  widget.callBackCategory(category);
                },
                child: Container(
                  height: 50,
                  width: 50,
                  child: Image.asset(
                    "assets/icons/ic_work.png",
                    color: selectedColor(Category.work),
                    colorBlendMode: BlendMode.saturation,
                  ),
                )),
            GestureDetector(
                onTap: () {
                  setState(() {
                    category = Category.social;
                  });
                  widget.callBackCategory(category);
                },
                child: Container(
                  height: 50,
                  width: 50,
                  child: Image.asset(
                    "assets/icons/ic_social.png",
                    color: selectedColor(Category.social),
                    colorBlendMode: BlendMode.saturation,
                  ),
                )),
            GestureDetector(
                onTap: () {
                  setState(() {
                    category = Category.personal;
                  });
                  widget.callBackCategory(category);
                },
                child: Container(
                  height: 50,
                  width: 50,
                  child: Image.asset(
                    "assets/icons/ic_personal.png",
                    color: selectedColor(Category.personal),
                    colorBlendMode: BlendMode.saturation,
                  ),
                )),
          ],
        ),
      ],
    );
  }

  Color selectedColor(Category category) {
    return category == this.category ? Colors.grey : Colors.transparent;
  }
}
