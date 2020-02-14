import 'package:meta/meta.dart';

enum Category { work, social, personal }

class TodoModel {
  int id;
  Category category;
  String title;
  String subTitle;
  String endDate;
  int urgent;
  int important;

  TodoModel.add();

  TodoModel({
    this.id,
    @required this.category,
    @required this.title,
    @required this.subTitle,
    @required this.endDate,
    @required this.urgent,
    @required this.important,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'category': category,
      'title': title,
      'sub_title': subTitle,
      'end_date': endDate,
      'urgent': urgent,
      'important': important
    };
  }

  TodoModel.fromDb(Map<String, dynamic> map)
      : id = map['id'],
        category = map['category'],
        title = map['title'],
        subTitle = map['sub_title'],
        endDate = map['end_date'],
        urgent = map['urgent'],
        important = map['important'];

  int getCategoryInt(Category category) {
    switch (category) {
      case Category.work:
        return 1;
        break;
      case Category.social:
        return 2;
        break;
      case Category.personal:
        return 3;
        break;
      default:
        return 1;
        break;
    }
  }

  Category getCategoryEnum(int categoryNumber) {
    switch (categoryNumber) {
      case 1:
        return Category.work;
        break;
      case 2:
        return Category.social;
        break;
      case 3:
        return Category.personal;
        break;
      default:
        return Category.work;
    }
  }

  factory TodoModel.copyFrom(TodoModel todoModel) {
    return TodoModel(
      category: todoModel.category,
      title: todoModel.title,
      subTitle: todoModel.subTitle,
      urgent: todoModel.urgent ?? 0,
      important: todoModel.important ?? 0,
      endDate: todoModel.endDate,
    );
  }

  @override
  String toString() {
    print('$title $subTitle $endDate $urgent $important ${getCategoryInt(category)}');
    return super.toString();
  }
}
