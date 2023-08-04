import 'package:flutter/material.dart';

class CommonDecorator {
  static InputDecoration inputDecorator(String hint) {
    return InputDecoration(
      border: OutlineInputBorder(borderSide: BorderSide.none),
      fillColor: Color(0xffF2F2F2),
      filled: true,
      hintText: hint,
      // labelText: hint,
      hintStyle: TextStyle(color: Colors.grey),
    );
  }
}
