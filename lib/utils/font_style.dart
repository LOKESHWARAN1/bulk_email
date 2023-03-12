import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget getTextStyle(
    String text, FontWeight fontWeight, Color color, double fontSizes) {
  return AutoSizeText(
    text,
    style: GoogleFonts.abyssinicaSil(
      textStyle: TextStyle(
          fontWeight: fontWeight, color: color, fontSize: fontSizes),
    ),
    maxLines: 4,
    minFontSize: 10.0,
    // stepGranularity: 1.0,
  );
}
