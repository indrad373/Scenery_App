import 'package:flutter/material.dart';
import 'package:scennery_app/constant/const.dart';
import 'package:scennery_app/constant/const_image.dart';
import 'package:scennery_app/pages/login_page.dart';
import 'package:scennery_app/view/explore/explore_page.dart';
import 'package:scennery_app/view/home/home_page.dart';
import 'package:scennery_app/view/profile/profile_page.dart';
import 'package:scennery_app/view/search/search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigatorPage extends StatefulWidget {
  const NavigatorPage({super.key});

  //final VoidCallback signOutFunction;

  //const NavigatorPage(this.signOutFunction, {super.key});

  @override
  State<NavigatorPage> createState() => _NavigatorPageState();
}

//enum to validate login condition / status
enum LoginStatus { notSignIn, signIn }

class _NavigatorPageState extends State<NavigatorPage>
    with SingleTickerProviderStateMixin {
  LoginStatus _loginStatus = LoginStatus.signIn;

  // signOutFunction() {
  //   setState(() {
  //     widget.signOutFunction();
  //   });
  // }

  late String name = "", email = "";

  getPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString("name")!;
      name.split(" ");
      email = preferences.getString("email")!;
    });

    //print(name);
  }

  late TabController _tabController;
  int? indexTab;

  @override
  void initState() {
    super.initState();
    getPreferences();

    int tabIndex = 0;
    indexTab = tabIndex;

    _tabController = TabController(vsync: this, length: 4);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  signOutFunction() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      //value 400 for initiate that user has been signedOut
      preferences.setInt("value", 400);

      _loginStatus = LoginStatus.notSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.signIn:
        return Scaffold(
          body: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const HomePage(),
                const SearchPage(),
                const ExplorePage(),
                ProfilePage(signOutFunction: signOutFunction),
              ]),
          bottomNavigationBar: TabBar(
              controller: _tabController,
              labelColor: Const().mainColor,
              unselectedLabelColor: Const().mainTitleColor,
              indicatorColor: Const().mainColor,
              onTap: ((value) {
                setState(() {
                  //_tabController.index = value;
                  indexTab = value;
                });
                print(_tabController.index);
              }),
              tabs: <Widget>[
                Tab(
                  icon: indexTab == 0
                      ? Image.asset(
                          constImage.home,
                          width: 24,
                          height: 24,
                        )
                      : Image.asset(
                          constImage.home_outlined,
                          width: 24,
                          height: 24,
                        ),
                ),
                Tab(
                  icon: indexTab == 1
                      ? Image.asset(
                          constImage.search,
                          width: 24,
                          height: 24,
                        )
                      : Image.asset(
                          constImage.search_outlined,
                          width: 24,
                          height: 24,
                        ),
                ),
                Tab(
                  icon: indexTab == 2
                      ? Image.asset(
                          constImage.explore,
                          width: 24,
                          height: 24,
                        )
                      : Image.asset(
                          constImage.explore_outlined,
                          width: 24,
                          height: 24,
                        ),
                ),
                Tab(
                  icon: indexTab == 3
                      ? Image.asset(
                          constImage.user,
                          width: 24,
                          height: 24,
                        )
                      : Image.asset(
                          constImage.user_outlined,
                          width: 24,
                          height: 24,
                        ),
                ),
              ]),
        );
      case LoginStatus.notSignIn:
        return const LoginPage();
    }
  }
}
