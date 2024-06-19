import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_avisena/Screens/HomePage/categories.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../profilepage.dart';

class myAccountPage extends StatefulWidget {
  myAccountPage({
    Key? key,
    required this.name,
    required this.email,
    required this.phone
  }) : super(key: key);

  String name;
  String email;
  String phone;

  @override
  State<myAccountPage> createState() => _myAccountPageState();
}

class _myAccountPageState extends State<myAccountPage> {
  var opacity = 0.0;
  bool position = false;
  dynamic _height;
  dynamic _width;
  var data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      animator();
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
        child: SingleChildScrollView(
          child: Container(
            child: Stack(
              children: [
                Opacity(
                  opacity: 1,
                  child: ClipPath(
                    child: Container(
                      height: _height / 6,
                      decoration: BoxDecoration(
                        gradient:
                        LinearGradient(begin: Alignment.topCenter, colors: [
                          Color(0xFFA92389),
                          Color(0xFF2290AA),
                        ]),
                        // color: violet,
                      ),
                    ),
                  ),
                ),
                bellNotification(),
              ],
            ),
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
      padding: EdgeInsets.only(top: 0, right: 10, left: 20),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            child: Container(
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
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(name: widget.name, email: widget.email, phone: widget.phone),
                  ));
            },
          ),
          SizedBox(
            width: _width * 0.02,
          ),
          Container(
            alignment: Alignment.center,
            child: Expanded(
              child: Text(
                (widget.name.length > 12) ? "Hi, ${widget.name.substring(0, 12)}..." : "${widget.name}",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'WorkSans'),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bellNotification() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: _height / 80),
      width: _width,
      height: _height / 15,
      padding: EdgeInsets.only(top: 0, right: 10, left: 80),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                child: Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: 30,
                ),
                onTap: () {
                  // scaffoldKey.currentState.openEndDrawer();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget topBanner() {
    List<Map<String, dynamic>> categories = [
      {
        "image": "assets/images/shortcut_medical_appointment.png",
        "text": "Appointment",
        "press": ""
      },
      {
        "image": "assets/images/shortcut_doctor.png",
        "text": "Doctors",
        "press": ""
      },
      {
        "image": "assets/images/shortcut_services.png",
        "text": "Services",
        "press": ""
      },
      {
        "image": "assets/images/shortcut_dependent.png",
        "text": "Dependents",
        "press": ""
      },
    ];
    return Container(
      padding: EdgeInsets.only(top: 0, right: 10, left: 5),
      child: GridView.builder(
        itemCount: categories.length,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, childAspectRatio: 1.0), //jarak between cards
        itemBuilder: (context, index) {
          return CategoryCard(
            image: categories[index]["image"],
            text: categories[index]["text"],
            press: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => categories[index]["press"]));
            },
          );
        },
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          // image: DecorationImage(
          //     image: AssetImage('assets/images/appointment-guide-bgr.jpg'),
          //     fit: BoxFit.cover),
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
      height: 120,
      margin: EdgeInsets.only(
          left: _width / 18, right: _width / 18, top: _height / 10),
    );
  }

  Widget headerMyAppointments() {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, top: 250),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('My Appointments',
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'WorkSans')),
          GestureDetector(
            child: Text(
              "More >",
              style: TextStyle(
                  fontFamily: 'WorkSans',
                  color: Colors.blue.shade600,
                  fontSize: 16),
            ),
            // onTap: viewallapp,
          ),
        ],
      ),
    );
  }

  Widget appointmentBanner() {
    return Container(
      padding: EdgeInsets.only(top: 0, right: 10, left: 20, bottom: 20),
      child: Row(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.asset(
                'assets/images/specialist.png',
                height: 80,
                width: 80,
              )),
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          // image: DecorationImage(
          //     image: AssetImage('assets/images/specialist.png')),
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
      height: 160,
      margin: EdgeInsets.only(
          left: _width / 18, right: _width / 18, top: _height / 3.2),
    );
  }

  Widget myAppointmentsButtons() {
    return Container(
      padding: EdgeInsets.only(top: 400, right: 0, left: 50),
      child: Row(
        children: <Widget>[
          FlatButton(
            child: Text("Reschedule",
                style: TextStyle(
                  fontFamily: 'WorkSans',
                  fontSize: 15,
                )),
            onPressed: () {},
            color: Theme.of(context).primaryColor,
            height: 35,
            minWidth: 180,
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          SizedBox(
            width: 18,
          ),
          FlatButton(
            child: Text("Details",
                style: TextStyle(
                  fontFamily: 'WorkSans',
                  fontSize: 15,
                )),
            onPressed: () {},
            color: Theme.of(context).primaryColor,
            height: 35,
            minWidth: 180,
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ],
      ),
    );
  }

  Widget appointmentDetails() {
    return Container(
      padding: EdgeInsets.only(top: 19, right: 10, left: 140),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Dato' Dr. Abdul Razak Rahman Hamzah",
            style: TextStyle(
                color: Colors.blueGrey,
                fontFamily: 'WorkSans',
                fontWeight: FontWeight.bold,
                fontSize: 18.5),
            textAlign: TextAlign.start,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 5),
          Text(
            "Ear, Nose and Throat Clinic",
            style: TextStyle(
                color: Colors.grey, fontFamily: 'WorkSans', fontSize: 12),
            textAlign: TextAlign.start,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 5),
          Text(
            "20 April 2024, AM Session",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'WorkSans',
                fontSize: 13),
            textAlign: TextAlign.start,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 5),
        ],
      ),
      margin: EdgeInsets.only(left: 0, right: _width / 18, top: _height / 3.2),
    );
  }

  Widget discoverMoreTitle() {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, top: 470),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Discover More',
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'WorkSans')),
          GestureDetector(
            child: Text(
              "More >",
              style: TextStyle(
                  fontFamily: 'WorkSans',
                  color: Colors.blue.shade600,
                  fontSize: 16),
            ),
            // onTap: viewallapp,
          ),
        ],
      ),
    );
  }

  Widget discoverMoreBanner1() {
    return Container(
      padding: EdgeInsets.only(top: 0, right: 10, left: 50),
      child: Row(
        children: [
          Text(
            "Book an \nAppointment",
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'WorkSans',
                fontWeight: FontWeight.bold,
                fontSize: 25),
            textAlign: TextAlign.start,
          )
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage('assets/images/appointment-guide-bgr.jpg'),
              fit: BoxFit.cover),
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
      height: 120,
      margin: EdgeInsets.only(
          left: _width / 18, right: _width / 18, top: _height / 1.8),
    );
  }

  Widget discoverMoreBanner2() {
    return Container(
      padding: EdgeInsets.only(top: 0, right: 10, left: 50),
      child: Row(
        children: [
          Text(
            "Paediatric Suction \nRecovery Package",
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'WorkSans',
                fontWeight: FontWeight.bold,
                fontSize: 25),
            textAlign: TextAlign.start,
          )
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          // gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          //   Color(0xFFa4278d),
          //   Color(0xffffffff),
          //   Color(0xffffffff),
          // ]),
          image: DecorationImage(
              image:
              AssetImage('assets/images/paediatric-suction-recovery.jpg'),
              fit: BoxFit.cover),
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
      height: 120,
      margin: EdgeInsets.only(
          left: _width / 18, right: _width / 18, top: _height / 1.4),
    );
  }

  Widget discoverMoreBanner3() {
    return Container(
      padding: EdgeInsets.only(top: 0, right: 10, left: 50),
      child: Row(
        children: [
          Text(
            "Fertility Services",
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'WorkSans',
                fontWeight: FontWeight.bold,
                fontSize: 25),
            textAlign: TextAlign.center,
          )
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage('assets/images/fertility-services-intro.jpg'),
              fit: BoxFit.cover),
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
      height: 120,
      margin: EdgeInsets.only(
          left: _width / 18, right: _width / 18, top: _height / 1.14),
    );
  }
}