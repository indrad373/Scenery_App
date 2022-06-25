// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText extends StatelessWidget {
  double size;
  final Color color;
  final String text;

  AppText(
      {Key? key, this.size = 16, this.color = Colors.white, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.openSans(
        textStyle: TextStyle(
            color: color, fontSize: size, fontWeight: FontWeight.w400),
      ),
    );
  }
}
