// ignore_for_file: must_be_immutable

import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:scennery_app/constant/const.dart';

class ResponsiveButtonLogin extends StatelessWidget {
  bool isResponsive;
  double? width;

  ResponsiveButtonLogin({Key? key, this.isResponsive = false, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 48,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
      child: ElevatedButton(
        onPressed: () {
          //
        },
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Const().mainColor)),
        child: Center(
          child: Text(Const().textLogin,
              style: GoogleFonts.openSans(
                  textStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600))),
        ),
      ),
    );
  }
}
