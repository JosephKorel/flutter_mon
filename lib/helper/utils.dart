import 'package:flutter/material.dart';

String capitalizeFirst(String word) {
  return word[0].toUpperCase() + word.substring(1);
}

void showSnackBar(BuildContext context, String message) {
  SnackBar snackBar = SnackBar(
    content: Text(message),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
