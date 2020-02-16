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
  int compeleted;

  TodoModel({
    this.id,
    @required this.category,
    @required this.title,
    @required this.subTitle,
    @required this.endDate,
    @required this.urgent,
    @required this.important,
    this.compeleted,
  });

  TodoModel.add();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'category': getCategoryInt(category),
      'title': title,
      'sub_title': subTitle,
      'end_date': endDate,
      'urgent': urgent,
      'important': important,
      'compeleted': compeleted,
    };
  }

  TodoModel.fromDb(Map<String, dynamic> map) {
    id = map['id'];
    category = this.getCategoryEnum(map['category']);
    title = map['title'];
    subTitle = map['sub_title'];
    endDate = map['end_date'];
    urgent = map['urgent'];
    important = map['important'];
    compeleted = map['compeleted'];
  }

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
        return null;
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
        return null;
    }
  }

  factory TodoModel.copyFrom(TodoModel todoModel) {
    return TodoModel(
      id: todoModel.id,
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
    print("""title $title 
        Subtitle $subTitle 
        EndDate $endDate 
        Urgent $urgent 
        Important $important 
        Category ${getCategoryInt(category)} 
        Compeleted $compeleted""");
    return super.toString();
  }
}
