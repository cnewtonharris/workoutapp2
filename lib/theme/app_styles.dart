import 'package:flutter/material.dart';

class AppStyles {
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 16);

  static const TextStyle header = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subheader = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const BorderRadius defaultRadius = BorderRadius.all(Radius.circular(12));
}
