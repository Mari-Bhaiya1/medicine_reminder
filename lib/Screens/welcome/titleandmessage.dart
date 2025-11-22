import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
class TitleandMessage extends StatelessWidget {
  final double deviceheight;

  const TitleandMessage({required this.deviceheight});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Padding(
            padding: EdgeInsets.only(left: 40.0, right: 40.0),

            child: AutoSizeText(
              'Be in control of your medicine',
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                color: Colors.black,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(left: 40.0, right: 40.0,top: 10.0),

            child: AutoSizeText(
              'An easy-to-use and reliable app that helps you remember to take your meds at the tight time',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Colors.grey[600],
                height: 1.3,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
          ),
        ),
      ],
    );
  }
}
