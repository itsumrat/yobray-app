import 'package:flutter/material.dart';

class ColorName {
  final String name;
  final Color color;
  ColorName({required this.name, required this.color});
}

final List<ColorName> colorNameList = <ColorName>[
  ColorName(color: Colors.blue, name: 'Blue'),
  ColorName(color: Colors.white, name: 'White'),
  ColorName(color: Colors.black, name: 'Black'),
  ColorName(color: Colors.green, name: 'Green'),
  ColorName(color: Colors.grey, name: 'Grey'),
  ColorName(color: Colors.yellow, name: 'Yellow'),
  ColorName(color: Colors.orange, name: 'Orange'),
  ColorName(color: Colors.pink, name: 'Pink'),
  ColorName(color: Colors.red, name: 'Red'),
];
