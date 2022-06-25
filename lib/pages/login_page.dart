// ignore_for_file: sized_box_for_whitespace, use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scennery_app/constant/base_url.dart';
import 'package:scennery_app/constant/const.dart';
import 'package:http/http.dart' as http;
import 'package:scennery_app/pages/navigator_page.dart';
import 'package:scennery_app/pages/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

//enum to validate login condition / status
enum LoginStatus { notSignIn, signIn }

class _LoginPageState extends State<LoginPage> {
  //create a default condition
  LoginStatus _loginStatus = LoginStatus.notSignIn;

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  bool _obsecureText = true;

  late String email, password;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _toggle() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  checkingForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      email = _emailController.text;
      password = _passwordController.text;
      setState(() {
        print("$email $password");
        loginFunction();
      });
    }
  }

  loginFunction() async {
    final response = await http.post(Uri.parse(baseURL.loginURL),
        body: {"email": email, "password": password});

    final data = jsonDecode(response.body);
    print(data);
    //get message data from response value
    String message = data['message'];

    //get value data from response value
    int value = data['value'];
    if (value == 1) {
      setState(() {
        //get name and email data from response value
        String nameFromAPI = data['name'];
        String emailFromAPI = data['email'];
        String idFromAPI = data['id'];

        _emailController.text = "";
        _passwordController.text = "";

        _loginStatus = LoginStatus.signIn;

        savePreferences(value, nameFromAPI, emailFromAPI, idFromAPI);

        print(message);
      });
    } else if (value == 2 && email.contains("@gmail.com") ||
        email.contains("@yahoo.com") ||
        email.contains("@yandex.com")) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Container(height: 20, child: Center(child: Text(message))),
        backgroundColor: Const().redColor,
      ));
      print(message);
    } else if (value == 3 && password != "") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Container(height: 20, child: Center(child: Text(message))),
        backgroundColor: Const().redColor,
      ));
      print(message);
    }
  }

  signOutFunction() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      //value 400 for initiate that user has been signedOut
      preferences.setInt("value", 400);

      _loginStatus = LoginStatus.notSignIn;
    });
  }

  savePreferences(int value, String nameFromAPI, String emailFromAPI,
      String idFromAPI) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      preferences.setInt("value", value);
      preferences.setString("name", nameFromAPI);
      preferences.setString("email", emailFromAPI);
      preferences.setString("id", idFromAPI);
    });
  }

  var value;
  getPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");

      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    super.initState();

    getPreferences();
    print(_loginStatus);
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    switch (_loginStatus) {
      //if the login status not signin so we will show the login page
      case LoginStatus.notSignIn:
        return Scaffold(
          //resizeToAvoidBottomInset: keyboardHeight <= 0.0 ? true : false,
          body: SafeArea(
            child: SizedBox(
              width: screenWidth,
              height: screenHeight - keyboardHeight + 30,
              child: SingleChildScrollView(
                physics: keyboardHeight <= 0.0
                    ? const NeverScrollableScrollPhysics()
                    : const ClampingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 60, left: 30, right: 30, bottom: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        Const().logoImage,
                        width: 150,
                        height: 100,
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Masuk",
                                  style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                          color: Const().mainTitleColor,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600))),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                  "Mari belajar dan berexplorasi pariwisata lokal Indonesia",
                                  style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                          color: Const().mainTextColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400))),
                              const SizedBox(
                                height: 60,
                              ),
                              Text("Alamat email",
                                  style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                          color: Const().mainTitleColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600))),
                              const SizedBox(
                                height: 2,
                              ),
                              TextFormField(
                                controller: _emailController,
                                cursorColor: Const().mainColor,
                                decoration: InputDecoration(
                                    labelStyle: TextStyle(
                                        color: Const().mainTitleColor),
                                    hintText: "example@mail.com",
                                    hintStyle: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                            color: Const().hintTextFiledColor,
                                            fontSize: 14)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Const().mainColor)),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Const()
                                                .underlineTextFieldColor))),
                                validator: (value) {
                                  if (value.toString().isEmpty ||
                                      value == null) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Container(
                                          height: 20,
                                          child: const Center(
                                              child: Text(
                                                  "Email tidak boleh kosong"))),
                                      backgroundColor: Const().redColor,
                                    ));
                                  } else if (!value
                                          .toString()
                                          .contains("@gmail.com") &&
                                      !value
                                          .toString()
                                          .contains("@yahoo.com") &&
                                      !value
                                          .toString()
                                          .contains("@yandex.com")) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Container(
                                          height: 20,
                                          child: const Center(
                                              child: Text(
                                                  "Cek kembali format email kamu"))),
                                      backgroundColor: Const().redColor,
                                    ));
                                  }
                                  return null;
                                },
                                onSaved: (value) =>
                                    _emailController.text = value.toString(),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Text("Kata sandi",
                                  style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                          color: Const().mainTitleColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600))),
                              const SizedBox(
                                height: 2,
                              ),
                              TextFormField(
                                controller: _passwordController,
                                cursorColor: Const().mainColor,
                                decoration: InputDecoration(
                                    labelStyle: TextStyle(
                                        color: Const().mainTitleColor,
                                        fontWeight: FontWeight.w400),
                                    hintText: "**********",
                                    hintStyle: TextStyle(
                                        color: Const().hintTextFiledColor,
                                        fontSize: 14),
                                    focusColor: Const().mainColor,
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Const().mainColor)),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Const()
                                                .underlineTextFieldColor)),
                                    suffixIconColor: _obsecureText
                                        ? Const().hintTextFiledColor
                                        : Const().mainColor,
                                    suffixIcon: IconButton(
                                      icon: Icon(_obsecureText
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      focusColor: _obsecureText
                                          ? Const().hintTextFiledColor
                                          : Const().mainColor,
                                      highlightColor: _obsecureText
                                          ? Const().mainColor
                                          : Const().hintTextFiledColor,
                                      splashColor: _obsecureText
                                          ? Const().hintTextFiledColor
                                          : Const().mainColor,
                                      onPressed: () {
                                        _toggle();
                                      },
                                    )),
                                obscureText: _obsecureText,
                                validator: (value) {
                                  if (value.toString().isEmpty ||
                                      value == null) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Container(
                                          height: 20,
                                          child: const Center(
                                              child: Text(
                                                  "Password tidak boleh kosong"))),
                                      backgroundColor: Const().redColor,
                                    ));
                                  } else if (value.toString().length < 8) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Container(
                                          height: 20,
                                          child: const Center(
                                              child: Text(
                                                  "Password harus memiliki 8 karakter"))),
                                      backgroundColor: Const().redColor,
                                    ));
                                  }
                                  return null;
                                },
                                onSaved: (value) =>
                                    _passwordController.text = value.toString(),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text("Lupa kata sandi?",
                                      style: GoogleFonts.openSans(
                                          textStyle: TextStyle(
                                              color: Const().mainColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400))),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 60,
                      ),

                      //Login Button
                      Container(
                        width: double.maxFinite - 20,
                        height: 48,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6)),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              checkingForm();
                            });
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Const().mainColor)),
                          child: Center(
                            child: Text(Const().textLogin,
                                style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600))),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                            Text("Belum punya akun?",
                                style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                        color: Const().mainTitleColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400))),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterPage()));
                              },
                              child: Text(" Daftar",
                                  style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                          color: Const().mainColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600))),
                            ),
                          ])),
                      const SizedBox(height: 55)
                    ],
                  ),
                ),
              ),
            ),
          ),
        );

      //if the login status signin we will redirect to homepage
      case LoginStatus.signIn:
        return const NavigatorPage();
    }
  }
}
