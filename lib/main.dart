// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:scennery_app/constant/const.dart';
import 'package:scennery_app/pages/login_page.dart';
import 'package:scennery_app/pages/welcome_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Const().mainColor, // status bar color
  ));

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scenery App',
      theme: ThemeData(
        colorScheme:
            ThemeData().colorScheme.copyWith(primary: Const().mainColor),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    //setup initialization from the first time app launch
    initialization();
  }

  void initialization() async {
    //will remove splash screen on 3 secs
    await Future.delayed(const Duration(seconds: 3));
    FlutterNativeSplash.remove();
  }

  var value;
  bool? throughWP;
  getPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");
      throughWP = preferences.getBool("throughWP");

      value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;

      throughWP == true
          ? ThroughWelcomePage.passWelcomePage
          : ThroughWelcomePage.notPassWelcomePage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if ((value == 1) && (throughWP == true)) {
      return const Scaffold(
        body: LoginPage(),
      );
    } else {
      return const Scaffold(
        body: WelcomePage(),
      );
    }
  }
}
