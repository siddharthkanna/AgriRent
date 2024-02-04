import 'package:agrirent/theme/palette.dart';
import 'package:flutter/material.dart';

Widget messageBubble(String message) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    child: Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: const BoxDecoration(
          color: Palette.red,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    ),
  );
}
