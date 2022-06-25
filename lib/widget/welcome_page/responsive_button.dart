// ignore_for_file: must_be_immutable

import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:scennery_app/constant/const.dart';
import 'package:scennery_app/pages/login_page.dart';

class ResponsiveButton extends StatelessWidget {
  bool isResponsive;
  double? width;

  ResponsiveButton({Key? key, this.isResponsive = false, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 48,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: ((context) => const LoginPage())));
        },
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Const().mainColor)),
        child: Center(
          child: Text(Const().textWelcomeButton,
              style: GoogleFonts.openSans(
                  textStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600))),
        ),
      ),
    );
  }
}
