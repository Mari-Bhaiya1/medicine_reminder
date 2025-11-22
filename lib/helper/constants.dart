import 'package:flutter/material.dart';

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kTextStyle = TextStyle(
  color: Colors.black,
  fontFamily: 'Poppins',
  fontSize: 15.0
);

InputDecoration kTextFieldDesign({required Color borderColor, required String hintTexts}) {
  return InputDecoration(
    hintText: hintTexts,
    hintStyle: const TextStyle(
      color: Colors.black,
      fontFamily: 'Poppins',
      fontSize: 10.0
    ),
    contentPadding:
    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide:
      BorderSide(color: borderColor, width: 1.0),
      borderRadius: const BorderRadius.all(Radius.circular(32.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide:
      BorderSide(color: borderColor, width: 2.0),
      borderRadius: const BorderRadius.all(Radius.circular(32.0)),
    ),
  );
}
