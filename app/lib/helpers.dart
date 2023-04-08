import 'package:intl/intl.dart';

extension DateTimeHelper on DateTime {
  //To weekDay Fri or Fri 04
  String toWeekDay() {
    DateTime datetime = DateTime.parse(toIso8601String());
    DateFormat dateFormat = DateFormat('EEE dd MMM${','} yyyy');
    return dateFormat.format(datetime);
  }
}
