import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerMixin {
  Future<String> selectDate(BuildContext context, DateTime selectedDate) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: todaysDefaultDate(),
        lastDate: DateTime.now().add(Duration(days: 365)));
    if (picked != null) {
      return DateFormat('dd-MM-yyyy').format(picked);
    } else {
      return null;
    }
  }

  DateTime todaysDefaultDate() {
    return DateFormat("dd-MM-yyyy").parse(DateTime.now().toString());
  }

  String dateTimeToString(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  DateTime stringToDateTime(String date) {
    return DateFormat("dd-MM-yyyy").parse(date);
  }
}
