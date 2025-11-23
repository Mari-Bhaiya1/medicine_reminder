import 'package:intl/intl.dart';

class CalendarDayModel {
  String dayletter;
  int daynumber;
  int monthnumber;
  int yearnumber;
  bool ischecked;

  CalendarDayModel(
    this.dayletter,
    this.daynumber,
    this.monthnumber,
    this.yearnumber,
    this.ischecked,
  );

  List<CalendarDayModel> getcurrentday() {
    final List<CalendarDayModel> dayslist = [];
    DateTime currentTime = DateTime.now();

    for (int i = 0; i < 7; i++) {
      dayslist.add(
        CalendarDayModel(
          DateFormat.E().format(currentTime).toString()[0],
          currentTime.day,
          currentTime.month,
          currentTime.year,
          false,
        ),
      );
      currentTime = currentTime.add(const Duration(days: 1));
    }

    dayslist[0].ischecked = true;
    return dayslist;
  }
}
