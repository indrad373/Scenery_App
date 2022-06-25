// ignore_for_file: use_build_context_synchronously, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scennery_app/constant/base_url.dart';
import 'package:scennery_app/constant/const.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:scennery_app/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  bool _obsecureText = true;

  late String name, email, password;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _toggle() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  checkingForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      name = _nameController.text;
      email = _emailController.text;
      password = _passwordController.text;

      // print(name + email + password);

      if (name == "" || email == "" || password == "") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Container(
              height: 20,
              child: const Center(
                  child: Text("Mohon isi bagian yang masih kosong"))),
          backgroundColor: Const().redColor,
        ));
      } else if (!email.contains("@gmail.com") &&
          !email.contains("@yahoo.com") &&
          !email.contains("@yandex.com")) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Container(
              height: 20,
              child: const Center(
                  child: Text("Cek kembali format email yang kamu masukkan"))),
          backgroundColor: Const().redColor,
        ));
      } else if (password.length < 8) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Container(
              height: 20,
              child: const Center(
                  child: Text("Kata sandi harus memiliki minimal 8 karakter"))),
          backgroundColor: Const().redColor,
        ));
      } else {
        registerFunction();
      }
    }
  }

  registerFunction() async {
    print(name + email + password);
    final response = await http.post(Uri.parse(baseURL.registerURL),
        body: {"name": name, "email": email, "password": password});

    final data = jsonDecode(response.body);
    //get value data from response value
    int value = data['value'];
    String message = data['message'];
    print(message);
    if (value == 2) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Container(height: 20, child: Center(child: Text(message))),
        backgroundColor: Const().redColor,
      ));
      print(message);
    } else if (value == 1) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Container(height: 20, child: Center(child: Text(message))),
        backgroundColor: Const().greenColor,
      ));
      setState(() {
        _nameController.text = "";
        _emailController.text = "";
        _passwordController.text = "";

        Navigator.of(context).pop();

        print(message);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  top: 40, left: 30, right: 30, bottom: 40),
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
                    height: 40,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Daftar",
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
                            height: 40,
                          ),
                          Text("Nama lengkap",
                              style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                      color: Const().mainTitleColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600))),
                          const SizedBox(
                            height: 2,
                          ),
                          TextFormField(
                            controller: _nameController,
                            cursorColor: Const().mainColor,
                            decoration: InputDecoration(
                                labelStyle:
                                    TextStyle(color: Const().mainTitleColor),
                                hintText: "Indra Gantenk",
                                hintStyle: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                        color: Const().hintTextFiledColor,
                                        fontSize: 14)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Const().mainColor)),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Const().underlineTextFieldColor))),
                            onSaved: (value) =>
                                _nameController.text = value.toString(),
                          ),
                          const SizedBox(
                            height: 30,
                          ),

                          //emailll
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
                                labelStyle:
                                    TextStyle(color: Const().mainTitleColor),
                                hintText: "example@mail.com",
                                hintStyle: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                        color: Const().hintTextFiledColor,
                                        fontSize: 14)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Const().mainColor)),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Const().underlineTextFieldColor))),
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
                                    borderSide:
                                        BorderSide(color: Const().mainColor)),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Const().underlineTextFieldColor)),
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
                            onSaved: (value) =>
                                _passwordController.text = value.toString(),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),

                  //Register Button
                  Container(
                    width: double.maxFinite - 20,
                    height: 48,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(6)),
                    child: ElevatedButton(
                      onPressed: () {
                        checkingForm();
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Const().mainColor)),
                      child: Center(
                        child: Text(Const().textRegister,
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
                        Text("Sudah punya akun?",
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    color: Const().mainTitleColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400))),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                          },
                          child: Text(" Masuk",
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
  }
}
