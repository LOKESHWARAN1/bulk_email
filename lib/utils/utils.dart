import 'package:flutter/material.dart';

class Responsive {
  static late Size size;

  //TODO assign your Xd or Figma height and width
  static double xdHeight = 812;
  static double xdWidth = 375;

  static double setHeight({required num value}) {
    double percentage = (value / xdHeight * 100).roundToDouble() / 100;
    return size.height * percentage;
  }

  static double setWidth({required num value}) {
    double percentage = (value / xdWidth * 100).roundToDouble() / 100;
    return size.width * percentage;
  }
}