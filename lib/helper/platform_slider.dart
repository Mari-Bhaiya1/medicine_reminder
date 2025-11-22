

import 'package:flutter/material.dart';

class PlatformSlider extends StatelessWidget {
  final double value, min, max;
  final int divisions;
  final ValueChanged<double> handler;
  final Color color;

  const PlatformSlider({
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.handler,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: this.value,
      onChanged: this.handler,
      min: this.min,
      max: this.max,
      divisions: this.divisions,
      activeColor: this.color,
    );
  }
}
