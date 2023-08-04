import 'package:flutter/material.dart';

class UnknownRoutePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Text('Unknown page, please define this route'),
        ),
      ),
    );
  }
}
