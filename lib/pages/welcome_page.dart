import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scennery_app/constant/const.dart';
import 'package:scennery_app/pages/login_page.dart';
import 'package:scennery_app/widget/welcome_page/app_large_text.dart';
import 'package:scennery_app/widget/welcome_page/app_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

//enum to validate login condition / status
enum ThroughWelcomePage { passWelcomePage, notPassWelcomePage }

class _WelcomePageState extends State<WelcomePage> {
  //create a default condition
  ThroughWelcomePage _throughWelcomePage =
      ThroughWelcomePage.notPassWelcomePage;

  double widthDouble = double.maxFinite;
  double heightDouble = double.maxFinite;

  List images = ["LogoAtWelcome.png", "WelcomePageBackground.png"];

  savePreferences(bool throughWP) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      preferences.setBool("throughWP", throughWP);
    });
  }

  bool? throughWP;
  getPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      throughWP = preferences.getBool("throughWP");

      _throughWelcomePage = throughWP == true
          ? ThroughWelcomePage.passWelcomePage
          : ThroughWelcomePage.notPassWelcomePage;
    });
  }

  @override
  void initState() {
    super.initState();
    getPreferences();
  }

  @override
  Widget build(BuildContext context) {
    switch (_throughWelcomePage) {
      case ThroughWelcomePage.notPassWelcomePage:
        return Scaffold(
          body: PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: 1,
              itemBuilder: (_, index) {
                return Container(
                  width: widthDouble,
                  height: heightDouble,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/img/${images[1]}"),
                          fit: BoxFit.cover)),
                  child: SafeArea(
                    child: Container(
                      margin: const EdgeInsets.only(
                          top: 60, left: 30, right: 30, bottom: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/img/${images[0]}",
                            width: 150,
                            height: 100,
                          ),
                          Column(
                            children: [
                              AppLargeText(
                                  text:
                                      "Bersiap untuk eksplorasi pariwisata Indonesia."),
                              const SizedBox(
                                height: 20,
                              ),
                              AppText(
                                  text:
                                      "Temukan berbagai macam tempat baru yang dapat kamu kunjungi."),
                              const SizedBox(
                                height: 30,
                              ),
                              Container(
                                width: double.maxFinite,
                                height: 48,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6)),
                                child: ElevatedButton(
                                  onPressed: () {
                                    savePreferences(true);
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                const LoginPage())));
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Const().mainColor)),
                                  child: Center(
                                    child: Text(Const().textWelcomeButton,
                                        style: GoogleFonts.openSans(
                                            textStyle: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600))),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
        );
      case ThroughWelcomePage.passWelcomePage:
        return const LoginPage();
    }
  }
}
