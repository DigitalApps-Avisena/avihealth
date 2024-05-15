import 'dart:async';
import 'package:flutter/material.dart';

import '../../const.dart';

class HomePage extends StatefulWidget {
  const HomePage();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var opacity = 0.0;
  bool position = false;
  dynamic _height;
  dynamic _width;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      animator();

      setState(() {});
    });
  }

  animator() {
    if (opacity == 1) {
      opacity = 0;
      position = false;
    } else {
      opacity = 1;
      position = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Opacity(
                opacity: 1,
                child: ClipPath(
                  child: Container(
                    height: _height / 7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                      color: violet,
                    ),
                  ),
                ),
              ),
              patientProfile(),
              topBanner()
            ],
          ),
        ),
      ),
    );
  }

  Widget patientProfile() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: _height / 80),
      width: _width,
      height: _height / 15,
      padding: EdgeInsets.only(top: 0, right: 10, left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: new BorderRadius.all(Radius.circular(50.0)),
              border: Border.all(width: 1.5, color: const Color(0xFFFFFFFF)),
              color: Colors.transparent,
              image: DecorationImage(
                  image: AssetImage('assets/images/profile_ayu.jpg'),
                  fit: BoxFit.fill),
            ),
          ),
          SizedBox(
            width: _width * 0.02,
          ),
          Container(
            height: _height * 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Hi, Ayu Nabilah",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
          SizedBox(
            width: _width * 0.45,
          ),
          GestureDetector(
            onTap: () {
              // scaffoldKey.currentState.openEndDrawer();
            },
            child: Icon(
              Icons.notifications,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget topBanner() {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: const Offset(
                  4.0,
                  4.0,
                ),
                blurRadius: 10.0,
                spreadRadius: 2.0,
              )
            ]),
        height: 100,
        margin: EdgeInsets.only(
            left: _width / 18, right: _width / 18, top: _height / 10),
        child: new Column(
          children: [
            Image.asset(
              'assets/images/appointment.png',
              fit: BoxFit.cover,
            ),
          ],
        )
        // child: ClipRRect(
        //     borderRadius: BorderRadius.all(Radius.circular(5.0)),
        //     child: Stack(
        //       children: <Widget>[
        //         Image.asset(
        //           'assets/images/doctor-services.png',
        //           fit: BoxFit.cover,
        //         ),
        //       ],
        //     )),
        );
  }

  Widget doctorList() {
    return AnimatedPositioned(
        top: position ? 460 : 550,
        left: 20,
        right: 20,
        duration: const Duration(milliseconds: 400),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 400),
          opacity: opacity,
          child: AnimatedOpacity(
            opacity: opacity,
            duration: const Duration(milliseconds: 300),
            child: SizedBox(
              height: 270,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // doctorCard(names[0], spacilality[0], images[0]),
                    // doctorCard(names[1], spacilality[1], images[1]),
                    // doctorCard(names[2], spacilality[2], images[2]),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget doctorCard(String name, String specialist, AssetImage image) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        height: 120,
        width: double.infinity,
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            CircleAvatar(
              radius: 30,
              backgroundImage: image,
              backgroundColor: Colors.blue,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(name),
                const SizedBox(
                  height: 5,
                ),
                Text(specialist),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.orangeAccent,
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.orangeAccent,
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.orangeAccent,
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.orangeAccent,
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.orangeAccent,
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            const Icon(
              Icons.navigation_sharp,
              color: Colors.blue,
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryRow() {
    return AnimatedPositioned(
        top: position ? 500 : 620,
        left: 25,
        right: 25,
        duration: const Duration(milliseconds: 400),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 400),
          opacity: opacity,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                category("assets/images/logo.png", "Drug", 5),
                category("assets/images/logo.png", "Virus", 10),
                category("assets/images/logo.png", "Physo", 10),
                category("assets/images/logo.png", "Other", 12),
              ],
            ),
          ),
        ));
  }

  Widget category(String asset, String txt, double padding) {
    return Column(
      children: [
        InkWell(
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              padding: EdgeInsets.all(padding),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                  // child: Image(
                  //   image: AssetImage(asset),
                  // ),
                  ),
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(txt),
      ],
    );
  }
}
