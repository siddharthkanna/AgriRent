import 'package:flutter/material.dart';

Widget profileImage() {
  return const CircleAvatar(
    backgroundImage: NetworkImage(
        'https://play-lh.googleusercontent.com/C9CAt9tZr8SSi4zKCxhQc9v4I6AOTqRmnLchsu1wVDQL0gsQ3fmbCVgQmOVM1zPru8UH=w240-h480-rw'), // Replace with your image asset
    radius: 25.0,
  );
}
