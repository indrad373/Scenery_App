// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:scennery_app/constant/base_url.dart';
import 'package:scennery_app/constant/const.dart';
import 'package:scennery_app/constant/const_image.dart';
import 'package:scennery_app/model/carousel_model.dart';
import 'package:scennery_app/model/popular_place_model.dart';
import 'package:scennery_app/model/today_topic_model.dart';
import 'package:scennery_app/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var loadingUserProfile = false;
  var loadingCarousel = false;
  var loadingPopularPlace = false;
  var loadingTodayTopic = false;

  bool userimageNull = true;

  late String userIdFromPref = "", userId = "";

  List<UserModel> userData = [];
  List<CarouselModel> carouselData = [];
  List<PopularPlaceModel> popularPlaceData = [];
  List<TodayTopicModel> todayTopicData = [];

  late int _currentCarouselIndicator = 0;
  final CarouselController _controller = CarouselController();

  getPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userIdFromPref = preferences.getString("id")!;

      userId = userIdFromPref;

      getUserProfile(userId);
      getCarousel();
      getPopularPlace();
      getTodayTopic();
    });
  }

  getUserProfile(String userid) async {
    setState(() {
      loadingUserProfile = true;
    });

    //print("userid, $userid");

    final response = await http
        .post(Uri.parse(baseURL.getDetailProfileURL), body: {"id": userid});
    if (response.body.isNotEmpty) {
      final data = json.decode(response.body);
      //print(data);
      if (mounted) {
        setState(() {
          for (Map<String, dynamic> i in data) {
            userData.add(UserModel.fromJson(i));
          }
          loadingUserProfile = false;
        });
      }
    } else if (mounted) {
      setState(() {
        loadingUserProfile = false;
      });
    }

    return userData;
  }

  getCarousel() async {
    setState(() {
      loadingCarousel = true;
    });

    //print("userid, $userid");

    final response = await http.get(Uri.parse(baseURL.getCarouselURL));
    if (response.body.isNotEmpty) {
      final data = json.decode(response.body);
      //print(data);
      if (mounted) {
        setState(() {
          for (Map<String, dynamic> i in data) {
            carouselData.add(CarouselModel.fromJson(i));
          }
          loadingCarousel = false;
          //print(carouselData);
        });
      }
    } else {
      setState(() {
        loadingCarousel = false;
      });
    }

    return carouselData;
  }

  getPopularPlace() async {
    setState(() {
      loadingPopularPlace = true;
    });

    final response = await http.get(Uri.parse(baseURL.getPopularPlaceURL));
    if (response.body.isNotEmpty) {
      final data = json.decode(response.body);
      //print(data);
      if (mounted) {
        setState(() {
          for (Map<String, dynamic> i in data) {
            popularPlaceData.add(PopularPlaceModel.fromJson(i));
          }
          loadingPopularPlace = false;
          //print(popularPlaceData);
        });
      }
    } else {
      setState(() {
        loadingPopularPlace = false;
      });
    }

    return popularPlaceData;
  }

  getTodayTopic() async {
    setState(() {
      loadingTodayTopic = true;
    });

    final response = await http.get(Uri.parse(baseURL.getTodayTopicURL));
    if (response.body.isNotEmpty) {
      final data = json.decode(response.body);
      //print(data);
      if (mounted) {
        setState(() {
          for (Map<String, dynamic> i in data) {
            todayTopicData.add(TodayTopicModel.fromJson(i));
          }
          loadingTodayTopic = false;
          //print(todayTopicData);
        });
      }
    } else {
      setState(() {
        loadingTodayTopic = false;
      });
    }

    return todayTopicData;
  }

  @override
  void initState() {
    super.initState();
    getPreferences();
    userId = userIdFromPref;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder(
                future: getUserProfile(userId),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    userData = snapshot.data;
                    userData[0].image == null
                        ? userimageNull == true
                        : userimageNull == false;
                    return Padding(
                      padding:
                          const EdgeInsets.only(top: 30, left: 30, right: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Halo ${userData[0].name}!",
                                  style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                          color: Const().mainTitleColor,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700))),
                              Text("Mari jelajahi Indonesia",
                                  style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                          color: Const().mainTextColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400)))
                            ],
                          ),
                          Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: userimageNull == false
                                        ? NetworkImage(
                                            'http://192.168.43.67/scenery-api-native/upload/profile/${userData[0].image}')
                                        : AssetImage(constImage.personImage)
                                            as ImageProvider),
                              )),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const SizedBox();
                }),

            //sizedBox
            const SizedBox(
              height: 30,
            ),

            //Carousel
            Column(
              children: [
                CarouselSlider.builder(
                  itemCount: carouselData.length,
                  options: CarouselOptions(
                      autoPlay: true,
                      height: 180,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: true,
                      aspectRatio: 16 / 9,
                      autoPlayInterval: const Duration(seconds: 10),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentCarouselIndicator = index;
                        });
                      }),
                  itemBuilder: ((context, index, realIndex) {
                    if (carouselData.isNotEmpty) {
                      return Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              gradient: const LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black,
                                  Colors.white,
                                ],
                              ),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      "http://192.168.43.67/scenery-api-native/upload/carousel/${carouselData[index].image}",
                                      scale: 2))),
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 20.0,
                                left: 22.0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(carouselData[index].title,
                                        style: GoogleFonts.openSans(
                                            textStyle: TextStyle(
                                                color: Const().whiteColor,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w700))),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(constImage.pin_icon,
                                            width: 16, height: 16),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Text(carouselData[index].province,
                                            style: GoogleFonts.openSans(
                                                textStyle: TextStyle(
                                                    color: Const().whiteColor,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500))),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ));
                    }
                    return const SizedBox();
                  }),
                ),
                const SizedBox(
                  height: 14,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: carouselData.map((url) {
                    int index = carouselData.indexOf(url);
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentCarouselIndicator == index
                            ? const Color(0xFF247180)
                            : const Color(0xFFEEEEEE),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),

            //sizedBox
            const SizedBox(
              height: 30,
            ),

            //Tempat populer text
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(Const.textTitlePopuler,
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: Const().mainTitleColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700))),
                      Text(Const.textSeeAll,
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: Const().mainColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600))),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(Const.textSubTitlePopuler,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Const().mainTextColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w400))),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),

            //Popular Place
            CarouselSlider.builder(
              carouselController: _controller,
              itemCount: popularPlaceData.length,
              options: CarouselOptions(
                  scrollDirection: Axis.horizontal,
                  enlargeCenterPage: false,
                  enableInfiniteScroll: true,
                  autoPlay: false,
                  height: 180,
                  viewportFraction: 0.85,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  pageSnapping: true),
              itemBuilder: ((context, index, realIndex) {
                if (popularPlaceData.isNotEmpty) {
                  return Container(
                      margin: const EdgeInsets.only(right: 30),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          gradient: const LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black,
                              Colors.white,
                            ],
                          ),
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(
                                  "http://192.168.43.67/scenery-api-native/upload/popular_place/${popularPlaceData[index].image}",
                                  scale: 2))),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 20,
                            left: 22,
                            right: 22,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(popularPlaceData[index].title,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                            color: Const().whiteColor,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700))),
                                const SizedBox(
                                  height: 6,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(constImage.pin_icon,
                                        width: 16, height: 16),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text(popularPlaceData[index].city,
                                        style: GoogleFonts.openSans(
                                            textStyle: TextStyle(
                                                color: Const().whiteColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ));
                }
                return const SizedBox();
              }),
            ),

            const SizedBox(
              height: 30,
            ),

            //today topic
            FutureBuilder(
                future: getTodayTopic(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    todayTopicData = snapshot.data;
                    return Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(Const.textTitleTopic,
                                  style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                          color: Const().mainTitleColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700))),
                              Text(todayTopicData[0].category,
                                  style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                          color: Const().mainTitleColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700))),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(todayTopicData[0].sub_title,
                              style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                      color: Const().mainTextColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400))),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            height: 220,
                            width: 400,
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                        "http://192.168.43.67/scenery-api-native/upload/today_topic/${todayTopicData[0].image}"))),
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: 26,
                                  left: 0,
                                  right: 20,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(todayTopicData[0].title,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.openSans(
                                              textStyle: TextStyle(
                                                  color: Const().whiteColor,
                                                  fontSize: 22,
                                                  fontWeight:
                                                      FontWeight.w700))),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.timer,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                              "${todayTopicData[0].readTime} mins",
                                              style: GoogleFonts.openSans(
                                                  textStyle: TextStyle(
                                                      color: Const().whiteColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500))),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const SizedBox();
                }),

            const SizedBox(
              height: 30,
            ),
          ],
        ),
      )),
    );
  }
}
