import 'package:flutter/material.dart';


class PlatformButton extends StatelessWidget {

  final VoidCallback handle;
  final Color color;
  final Widget ButtonChild;


  const PlatformButton({required this.handle,required this.color,required this.ButtonChild});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: handle,
      style: TextButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      child: ButtonChild,
    );
  }
}
