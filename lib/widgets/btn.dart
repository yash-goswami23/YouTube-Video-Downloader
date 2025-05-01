import 'package:flutter/material.dart';

Widget btn({required VoidCallback onTap, String? txt, Color? clr}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      alignment: AlignmentDirectional.center,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: clr ?? Colors.amber,
      ),
      child: Text(
        txt ?? "Download",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ),
  );
}
