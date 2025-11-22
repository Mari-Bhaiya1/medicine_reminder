import 'package:flutter/material.dart';

import '../../models/calendardaymodel.dart';
import 'calendar_day.dart';

class Calendar extends StatefulWidget {
  final Function chooseDay;
  final List<CalendarDayModel> daylist;

  const Calendar({required this.daylist, required this.chooseDay});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceheight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Container(
      height: deviceheight * 0.12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ...widget.daylist.map(
            (day) => Expanded(child: CalendarDay(day: day, onTap: widget.chooseDay)),
          ),
        ],
      ),
    );
  }
}
