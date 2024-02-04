import 'package:agrirent/theme/palette.dart';
import 'package:flutter/material.dart';

class CustomSnackBar {
  static void showError(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Palette.red,
      ),
    );
  }
}
