import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avisena/Screens/Dependants/add.dart';
import 'package:flutter_avisena/Screens/HomePage/categories.dart';
import 'package:flutter_avisena/l10n/localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';

import '../../components/section_title.dart';
import '../../const.dart';
import '../../size_config.dart';
import 'needHelp.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, this.name}) : super(key: key);
  String? name;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final storage = const FlutterSecureStorage();

  var opacity = 0.0;
  var namelength;
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
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Stack(
              children: [
                Opacity(
                  opacity: 1,
                  child: ClipPath(
                    child: Container(
                      height: _height / 6,
                      decoration: const BoxDecoration(
                        gradient:
                        LinearGradient(begin: Alignment.topCenter, colors: [
                          Color(0xFFA92389),
                          Color(0xFF2290AA),
                        ]),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                        // color: violet,
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    patientProfile(),
                    topBanner(),
                    headerMyAppointments(),
                    appointmentBanner(),
                    discoverMoreTitle(),
                    discoverMoreBanner1(),
                    discoverMoreBanner2(),
                    discoverMoreBanner3(),
                    needHelpTitle(),
                    needHelpCard()
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget patientProfile() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          margin: EdgeInsets.only(top: _height / 80),
          // width: _width,
          height: _height / 15,
          // padding: const EdgeInsets.only(top: 0, right: 10, left: 20),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                  border: Border.all(width: 1.5, color: const Color(0xFFFFFFFF)),
                  color: Colors.transparent,
                  image: const DecorationImage(
                      image: AssetImage('assets/images/profile_ayu.jpg'),
                      fit: BoxFit.fill),
                ),
              ),
              SizedBox(
                width: _width * 0.02,
              ),
              Container(
                alignment: Alignment.center,
                child: Expanded(
                  child: (widget.name != null) ? Text(
                    (widget.name!.length > 12) ? "Hi, ${widget.name!.substring(0, 12)}..." : "${widget.name}",
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'WorkSans'),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ) : const Text('null'),
                ),
              ),
            ],
          ),
        ),
        bellNotification()
      ],
    );
  }

  Widget bellNotification() {
    return GestureDetector(
      child: const Icon(
        Icons.notifications,
        color: Colors.white,
        size: 32,
      ),
      onTap: () {
        // scaffoldKey.currentState.openEndDrawer();
      },
    );
  }

  Widget topBanner() {
    List<Map<String, dynamic>> categories = [
      {
        "image": "assets/images/shortcut_medical_appointment.png",
        "text": AppLocalizations.of(context)!.translate('Appointment')!,
        "press": ""
      },
      {
        "image": "assets/images/shortcut_doctor.png",
        "text": AppLocalizations.of(context)!.translate('Doctors')!,
        "press": ""
      },
      {
        "image": "assets/images/shortcut_services.png",
        "text": AppLocalizations.of(context)!.translate('Services')!,
        "press": ""
      },
      {
        "image": "assets/images/shortcut_dependent.png",
        "text": AppLocalizations.of(context)!.translate('Dependants')!,
        "press": AddDependants(name: widget.name)
      },
    ];
    return Container(
      padding: const EdgeInsets.only(top: 0, right: 10, left: 5),
      child: GridView.builder(
        itemCount: categories.length,
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, childAspectRatio: 1.0), //jarak between cards
        itemBuilder: (context, index) {
          return CategoryCard(
            image: categories[index]["image"],
            text: categories[index]["text"],
            press: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => categories[index]["press"]
                ),
              );
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
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(
                4.0,
                4.0,
              ),
              blurRadius: 10.0,
              spreadRadius: 2.0,
            )
          ]),
      height: _height * 0.15,
      margin: EdgeInsets.only(
          left: _width / 18, right: _width / 18, top: _height / 40),
    );
  }

  Widget headerMyAppointments() {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, top: _height * 0.045),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            AppLocalizations.of(context)!.translate('My Appointments')!,
            style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                fontFamily: 'WorkSans'
            ),
          ),
          GestureDetector(
            child: Text(
              "${AppLocalizations.of(context)!.translate('More')!} >",
              style: TextStyle(
                  fontFamily: 'WorkSans',
                  color: Colors.blue.shade600,
                  fontSize: 16
              ),
            ),
            // onTap: viewallapp,
          ),
        ],
      ),
    );
  }

  Widget appointmentBanner() {
    return Container(
      padding: EdgeInsets.only(top: _height * 0.004, right: 10, left: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.asset(
                    'assets/images/specialist.png',
                    height: 80,
                    width: 80,
                  )
              ),
              SizedBox(
                width: _width * 0.01,
              ),
              appointmentDetails(),
            ],
          ),
          myAppointmentsButtons(),
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(
                4.0,
                4.0,
              ),
              blurRadius: 10.0,
              spreadRadius: 2.0,
            )
          ]
      ),
      height: _height * 0.23,
      margin: EdgeInsets.only(
          left: _width / 18, right: _width / 18, top: _height / 35
      ),
    );
  }

  Widget appointmentDetails() {
    return SizedBox(
      width: _width * 0.59,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Dato' Dr. Abdul Razak Rahman Hamzah",
            style: TextStyle(
                color: Colors.blueGrey,
                fontFamily: 'WorkSans',
                fontWeight: FontWeight.bold,
                fontSize: 18.5
            ),
            textAlign: TextAlign.start,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 5),
          Text(
            "Ear, Nose and Throat Clinic",
            style: TextStyle(
                color: Colors.grey,
                fontFamily: 'WorkSans',
                fontSize: 12
            ),
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
                fontSize: 13
            ),
            textAlign: TextAlign.start,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 5),
        ],
      ),
      // margin: EdgeInsets.only(left: 0, right: _width / 18),
    );
  }

  Widget myAppointmentsButtons() {
    return Row(
      children: <Widget>[
        FlatButton(
          child: Text(
            AppLocalizations.of(context)!.translate('Reschedule')!,
            style: const TextStyle(
              fontFamily: 'WorkSans',
              fontSize: 15,
            ),
          ),
          onPressed: () async {
            await storage.write(key: 'language', value: 'en');
            await storage.write(key: 'global', value: 'US');
            var batista = await storage.read(key: 'language');
            print('HohohOHOHOH $batista');
          },
          color: Theme.of(context).primaryColor,
          height: 35,
          minWidth: _width * 0.38,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        const SizedBox(
          width: 18,
        ),
        FlatButton(
          child: Text(
            AppLocalizations.of(context)!.translate('Details')!,
            style: const TextStyle(
              fontFamily: 'WorkSans',
              fontSize: 15,
            ),
          ),
          onPressed: () async {
            await storage.write(key: 'language', value: 'ms');
            await storage.write(key: 'global', value: 'MY');
          },
          color: Theme.of(context).primaryColor,
          height: 35,
          minWidth: _width * 0.38,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ],
    );
  }

  Widget discoverMoreTitle() {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, top: _height * 0.045),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            AppLocalizations.of(context)!.translate('Discover More')!,
            style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                fontFamily: 'WorkSans'
            ),
          ),
          GestureDetector(
            child: Text(
              '${AppLocalizations.of(context)!.translate('More')!} >',
              style: TextStyle(
                  fontFamily: 'WorkSans',
                  color: Colors.blue.shade600,
                  fontSize: 16
              ),
            ),
            // onTap: viewallapp,
          ),
        ],
      ),
    );
  }

  Widget discoverMoreBanner1() {
    return Container(
      padding: const EdgeInsets.only(top: 0, right: 10, left: 50),
      child: Row(
        children: const [
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
          image: const DecorationImage(
              image: AssetImage('assets/images/appointment-guide-bgr.jpg'),
              fit: BoxFit.cover),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(
                4.0,
                4.0,
              ),
              blurRadius: 10.0,
              spreadRadius: 2.0,
            )
          ]
      ),
      height: 120,
      margin: EdgeInsets.only(
          left: _width / 18, right: _width / 18, top: _height / 35
      ),
    );
  }

  Widget discoverMoreBanner2() {
    return Container(
      padding: const EdgeInsets.only(top: 0, right: 10, left: 50),
      child: Row(
        children: const [
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
          image: const DecorationImage(
              image: AssetImage('assets/images/paediatric-suction-recovery.jpg'),
              fit: BoxFit.cover
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(
                4.0,
                4.0,
              ),
              blurRadius: 10.0,
              spreadRadius: 2.0,
            )
          ]
      ),
      height: 120,
      margin: EdgeInsets.only(
          left: _width / 18, right: _width / 18, top: _height / 35
      ),
    );
  }

  Widget discoverMoreBanner3() {
    return Container(
      padding: const EdgeInsets.only(top: 0, right: 10, left: 50),
      child: Row(
        children: const [
          Text(
            "Fertility Services",
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'WorkSans',
                fontWeight: FontWeight.bold,
                fontSize: 25
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          image: const DecorationImage(
              image: AssetImage('assets/images/fertility-services-intro.jpg'),
              fit: BoxFit.cover),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(
                4.0,
                4.0,
              ),
              blurRadius: 10.0,
              spreadRadius: 2.0,
            )
          ]
      ),
      height: 120,
      margin: EdgeInsets.only(
          left: _width / 18, right: _width / 18, top: _height / 35
      ),
    );
  }

  Widget needHelpTitle() {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, top: _height * 0.045),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '${AppLocalizations.of(context)!.translate('Need Help')!} ?',
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              fontFamily: 'WorkSans',
            ),
          ),
        ],
      ),
    );
  }

  Widget needHelpCard() {
    int currentPage = 0;
    List<Map<String, dynamic>> webData = [
      {
        "text": "Admission & Discharge \nDepartment Contact \nInformation",
        "press": ""
      },
      {"text": "View Room Rates", "press": ""},
      {"text": "Patient & Family Rights", "press": ""},
      {"text": "Contact Us", "press": ""},
    ];
    return Container(
      child: SizedBox(
        width: (350),
        height: (150),
        child: ListView.builder(
          // onPageChanged: (value) {
          //   setState(() {
          //     currentPage = value;
          //   });
          // },
          scrollDirection: Axis.horizontal,
          itemCount: webData.length,
          itemBuilder: (context, index) => needHelp(
            text: webData[index]["text"],
            press: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => webData[index]["press"],
                ),
              );
            },
          ),
        ),
      ),
      margin: EdgeInsets.only(
          left: _width / 18, right: _width / 18, top: _height / 35
      ),
    );
  }
}