// ignore_for_file: unused_import

import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_avisena/Screens/LoginPage/login.dart';
import 'package:flutter_avisena/Screens/OnboardPage/onboard.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../Helperfunctions.dart';

class AnimatedSplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final storage = FlutterSecureStorage();
  bool? userIsLoggedIn;
  var image;
  var _visible = true;
  late AnimationController animationController;
  late Animation<double> animation;

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  getLoggedInState() async {
    var name = await storage.read(key: 'name');
    setState(() {
      if(name != null) {
        userIsLoggedIn = true;
        print("USER LOG IN VALUE HERE >>> $userIsLoggedIn");
      } else {
        userIsLoggedIn;
      }
    });
  }

  Future<void> navigationPage() async {
    if (userIsLoggedIn == true) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(mrn: '', name: '', email: '', phone: '',),
          ));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OnboardPage(),
          ));
    }
  }

  @override
  void initState() {
    super.initState();
    getLoggedInState();
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
    animation =
    new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = _visible;
    });
    // initialise();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                'assets/images/avisena_splashscreen.png',
                width: animation.value * 150,
                height: animation.value * 150,
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}