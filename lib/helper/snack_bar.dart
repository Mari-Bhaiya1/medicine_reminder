import 'package:flutter/material.dart';

class Snackbar {
  void showSnack(String message, BuildContext context, Function? undo) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: undo != null
            ? SnackBarAction(
          textColor: Theme.of(context).primaryColor,
          label: "Undo",
          onPressed: () => undo(),
        )
            : null,
      ),
    );
  }
}