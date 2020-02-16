import 'package:flutter/material.dart';
import 'package:todo_assignment/models/todo_model.dart';

class WidgetContentDecider {
  Widget getIconAsPerCategory(Category category) {
    switch (category) {
      case Category.work:
        return Image.asset(
          "assets/icons/ic_work.png",
        );
        break;
      case Category.social:
        return Image.asset(
          "assets/icons/ic_social.png",
        );
        break;
      case Category.personal:
        return Image.asset(
          "assets/icons/ic_personal.png",
        );
        break;
      default:
        return Image.asset(
          "assets/icons/ic_work.png",
        );
        break;
    }
  }

  Color colorAsPerCondition(var urgent, var important) {
    bool u = urgent == 1 ? true : false;
    bool i = important == 1 ? true : false;
    if (u && !i) {
      return Color(0xFFFEF6C5);
    } else if (!u && !i) {
      return Colors.white;
    } else if (!u && i) {
      return Color(0xFFECCFCF);
    } else {
      return Color(0xFFECCFCF);
    }
  }

  bool shouldRightAlign(int u, int i) => (u == 0 && i == 1) ? true : false;
  
}
