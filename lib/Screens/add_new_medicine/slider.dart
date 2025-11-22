import 'package:flutter/material.dart';
import 'package:medicinereminder/helper/platform_slider.dart';

class UserSlider extends StatelessWidget {
  final int howmanydays;
  final ValueChanged<double> handler;
  const UserSlider({required this.handler,required this.howmanydays});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: PlatformSlider(value: this.howmanydays.toDouble(), min: 1, max: 30, divisions: 31, handler: this.handler, color: Theme.of(context).primaryColor))
      ],
    );
  }
}
