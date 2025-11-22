import 'package:flutter/material.dart';
import 'package:medicinereminder/models/calendardaymodel.dart';

class CalendarDay extends StatefulWidget {
  final CalendarDayModel day;
  final Function onTap;

  const CalendarDay({required this.day, required this.onTap});

  @override
  State<CalendarDay> createState() => _CalendarDayState();
}

class _CalendarDayState extends State<CalendarDay> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder:
          (context, constrains) => Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Text(
                widget.day.dayletter,
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[500],
                ),
              ),
              SizedBox(height: constrains.maxHeight * 0.1),
              GestureDetector(
                onTap: () {
                  widget.onTap(widget.day);
                },
                child: CircleAvatar(
                  radius: constrains.maxHeight*0.25,
                  backgroundColor: widget.day.ischecked?Theme.of(context).primaryColor:Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.all(3.0),
                    child: Text(
                      widget.day.daynumber.toString(),
                      style: TextStyle(
                        color:
                            widget.day.ischecked ? Colors.white : Colors.black,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
