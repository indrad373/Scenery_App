import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scennery_app/constant/base_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback signOutFunction;

  const ProfilePage({required this.signOutFunction, super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  signOutFunction() {
    setState(() {
      widget.signOutFunction();
    });
  }

  var loading = false;

  late String userIdFromPref = "", userId = "";

  getPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userIdFromPref = preferences.getString("id")!;

      userId = userIdFromPref;

      getUserProfile(userId);
    });
  }

  getUserProfile(String userid) async {
    setState(() {
      loading = true;
    });

    final response = await http
        .post(Uri.parse(baseURL.getDetailProfileURL), body: {"id": userid});
    if (response.body.isNotEmpty) {
      final data = json.decode(response.body);
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPreferences();
    userId = userIdFromPref;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  signOutFunction();
                });
              },
              icon: const Icon(Icons.logout))
        ],
      ),
    );
  }
}
