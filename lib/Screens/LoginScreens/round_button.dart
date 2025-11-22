import 'package:flutter/material.dart';
import 'package:medicinereminder/helper/constants.dart';

class RoundButton extends StatelessWidget {

  const RoundButton({super.key, required this.colour, required this.title, required this.onPress});

  final Color colour;
  final String title;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),

      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),

        child: MaterialButton(
          onPressed:onPress,
          minWidth: 200.0,
          height: 42.0,
          child: Text(title, style: kTextStyle.copyWith(color: Colors.white)),
        ),
      ),
    );
  }
}
