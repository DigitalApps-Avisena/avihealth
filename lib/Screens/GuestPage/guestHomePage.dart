import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avisena/Screens/Dependents/add.dart';
import 'package:flutter_avisena/Screens/Dependents/list.dart';
import 'package:flutter_avisena/Screens/HomePage/categories.dart';
import 'package:flutter_avisena/Screens/Services/chooseHospital.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/Database.dart';
import '../../components/section_title.dart';
import '../../const.dart';
import '../../size_config.dart';
import '../Appointment/appointmentDetails.dart';
import '../Appointment/appointmentListing.dart';
import '../HomePage/needHelp.dart';
import '../ProfilePage/profilepage.dart';


class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
    required this.name,
    required this.email,
    required this.phone,
    required this.mrn,
    this.selectedDate,
    this.selectedOption,
    this.appointmentReason,
    this.locationGroup,
    this.hospitalId,
    this.hospitalName,
    this.clinicName,
    this.doctorName,
    this.doctorImage,
    this.mapData,
  }) : super(key: key);

  String name;
  String email;
  String phone;
  String mrn;
  DateTime? selectedDate;
  String? selectedOption;
  String? locationGroup;
  String? appointmentReason;
  String? hospitalId;
  String? hospitalName;
  String? clinicName;
  String? doctorName;
  String? doctorImage;
  Map? mapData;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  DatabaseMethods databaseMethods = new DatabaseMethods();

  final storage = const FlutterSecureStorage();

  final customboxshadow = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 0.5,
          blurRadius: 1,
          offset: new Offset(2.0, 2.0), // changes position of shadow
        ),
      ]);

  var opacity = 0.0;
  var namelength;
  bool position = false;
  dynamic _height;
  dynamic _width;
  Map<String, dynamic>? appointmentData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      animator();
      _getData();
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

  Future<void> _getData() async {
    try{
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("appointment").doc("5").get();
      if(documentSnapshot.exists){
        setState(() {
          appointmentData = documentSnapshot.data() as Map<String, dynamic>?;
        });
      }else{
        print("No data");
      }
    } catch (e){print(e);
    }
  }

  // Function to handle opening the app or navigating to the store
  // void launchAnotherApp() async {
  //   if (!await launchUrl(Uri.parse("https://play.google.com/store/apps/details?id=com.truecare2u.truecare2u"),
  //       mode: LaunchMode.externalApplication)) {
  //     throw 'Could not launch ';
  //   }
  // }

  // Future<void> _launchAppOrStore() async {
  //   // Custom URL scheme for the app
  //   final Uri appUri = Uri.parse('truecare2u://');
  //
  //   // URL to the Play Store
  //   final Uri storeUri = Uri.parse(
  //     'https://play.google.com/store/apps/details?id=com.truecare2u.truecare2u',
  //   );
  //
  //   try {
  //     // Try to launch the app
  //     if (await canLaunchUrl(appUri)) {
  //       print('App is installed, launching...');
  //       await launchUrl(appUri, mode: LaunchMode.externalApplication);
  //     } else {
  //       print('App not installed, redirecting to the Play Store...');
  //       await launchUrl(storeUri, mode: LaunchMode.externalApplication);
  //     }
  //   } catch (e) {
  //     print('Error launching app or store: $e');
  //     // Fallback to Play Store if something goes wrong
  //     await launchUrl(storeUri, mode: LaunchMode.externalApplication);
  //   }
  // }

  Future<void> _launchAppOrStore() async {
    const String packageName = 'com.truecare2u.truecare2u';

    final Uri storeUri = Uri.parse(
      'https://play.google.com/store/apps/details?id=$packageName',
    );

    try {
      bool isInstalled = await DeviceApps.isAppInstalled(packageName);

      if (isInstalled) {
        print('App is installed, launching...');
        await launchUrl(
          Uri.parse('truecare2u://'),
          mode: LaunchMode.externalApplication,
        );
      } else {
        print('App not installed, redirecting to the Play Store...');
        await launchUrl(storeUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      print('Error launching app or store: $e');
      await launchUrl(storeUri, mode: LaunchMode.externalApplication);
    }
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
                      height: _height / 5,
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
                Padding(
                  padding: const EdgeInsets.only(left: 200, right: 20),
                  child: Opacity(
                    opacity: 0.3, // Set opacity for transparency
                    child: Image.asset(
                      'assets/images/avisena_logo_white.png', // Update with your image path
                      height: 200,
                      width: 200,// Adjust height as needed
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    patientProfile(),
                    SizedBox(
                      height: 30,
                    ),
                    // topBanner(),
                    bookAppointmentBanner(context),
                    headerMyAppointments(),
                    appointmentData == null ? Center() :
                    myAppointments(),
                    // discoverMoreTitle(),
                    // discoverMoreBanner1(),
                    // discoverMoreBanner2(),
                    // discoverMoreBanner3(),
                    exploreTitle(),
                    exploreServices(),
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
          margin: EdgeInsets.only(top: _height / 50),
          height: _height / 15,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    border: Border.all(width: 1.5, color: const Color(0xFFFFFFFF)),
                    color: Colors.transparent,
                    image: DecorationImage(
                      image: AssetImage('assets/images/profile_ayu.jpg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        name: widget.name,
                        email: widget.email,
                        phone: widget.phone,
                        mrn: widget.mrn,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                width: _width * 0.02,
              ),
              Container(
                alignment: Alignment.center,
                child: (widget.name != null)
                    ? Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Good day,\n", // First part of the text
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white70, // Different color for contrast
                          fontWeight: FontWeight.normal,
                          fontFamily: 'WorkSans',
                        ),
                      ),
                      TextSpan(
                        text: (widget.name.length > 12)
                            ? ""
                            : widget.name, // Second part of the text
                        style: const TextStyle(
                          fontSize: 20, // Slightly smaller size for the name
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'WorkSans',
                        ),
                      ),
                    ],
                  ),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                )

                    : const Text('null'),
              ),
            ],
          ),
        ),
        SizedBox(width: 10),
        bellNotification(),
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
        "text": 'Appointment'.tr,
        "press": ""
      },
      {
        "image": "assets/images/shortcut_doctor.png",
        "text": 'Doctors'.tr,
        "press": ""
      },
      {
        "image": "assets/images/shortcut_services.png",
        "text": 'Services'.tr,
        "press": ChooseHospital(name: widget.name, email: widget.email, phone: widget.phone, mrn: widget.mrn)
      },
      {
        "image": "assets/images/shortcut_dependent.png",
        "text": 'Dependents'.tr,
        "press": ListDependents(name: widget.name, email: widget.email, phone: widget.phone)
      },
    ];
    return Container(
      padding: const EdgeInsets.only(top: 10, right: 10, left: 5),
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
      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(10.0),
      //     color: Colors.white,
      //     // image: DecorationImage(
      //     //     image: AssetImage('assets/images/appointment-guide-bgr.jpg'),
      //     //     fit: BoxFit.cover),
      //     boxShadow: const [
      //       BoxShadow(
      //         color: Colors.grey,
      //         offset: Offset(
      //           4.0,
      //           4.0,
      //         ),
      //         blurRadius: 10.0,
      //         spreadRadius: 2.0,
      //       )
      //     ]),
      height: _height * 0.13,
      margin: EdgeInsets.only(
          left: _width * 0.05, right: _width * 0.05, top: _height * 0.01, bottom: _height * 0.05
      ),
    );
  }

  Widget bookAppointmentBanner(BuildContext context) { // Add BuildContext parameter
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChooseHospital(name: widget.name, email: widget.email, phone: widget.phone, mrn: widget.mrn)),
        );
      },
      child: Container(
        padding: const EdgeInsets.only(top: 0, right: 10, left: 50),
        child: Row(
          children: const [
            Text(
              "Book an \nAppointment",
              style: TextStyle(
                  color: turquoise,
                  fontFamily: 'WorkSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
              textAlign: TextAlign.center,
            )
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          image: const DecorationImage(
            image: AssetImage('assets/images/appointment-guide-bgr.jpg'),
            fit: BoxFit.cover,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(4.0, 4.0),
              blurRadius: 10.0,
              spreadRadius: 2.0,
            )
          ],
        ),
        height: 120,
        margin: EdgeInsets.only(
          left: _width / 18,
          right: _width / 18,
          top: _height / 35,
        ),
      ),
    );
  }


  Widget headerMyAppointments() {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, top: _height * 0.040),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'My Appointments'.tr,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'WorkSans'
            ),
          ),
          GestureDetector(
            child: Text(
              "${'More'.tr} >",
              style: TextStyle(
                  fontFamily: 'WorkSans',
                  color: Colors.blue.shade600,
                  fontSize: 15
              ),
            ),
            // onTap: viewallapp,
          ),
        ],
      ),
    );
  }

  Widget myAppointments() {
    return Container(
      padding: EdgeInsets.only(top: _height * 0.004, right: 10, left: _width * 0.05),
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
              myAppointmentDetails(),
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
          left: _width * 0.047, right: _width * 0.047, top: _height / 35
      ),
    );
  }

  Widget myAppointmentDetails() {
    return SizedBox(
      width: _width * 0.59,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${appointmentData!["doctor_name"] ?? ""}",
            style: TextStyle(
                color: turquoise,
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
            "${appointmentData!["service"] ?? ""}",
            style: TextStyle(
                color: Colors.blueGrey,
                fontFamily: 'WorkSans',
                fontSize: 13
            ),
            textAlign: TextAlign.start,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 5),
          Text(
            "${appointmentData!["appointmentDate"] ?? ""} | ${appointmentData!["session"] ?? ""}",
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
            'Reschedule'.tr,
            style: const TextStyle(
              fontFamily: 'WorkSans',
              fontSize: 15,
            ),
          ),
          onPressed: () async {

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
            'Details'.tr,
            style: const TextStyle(
              fontFamily: 'WorkSans',
              fontSize: 15,
            ),
          ),
          onPressed: () async {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => appointmentDetails(
                      name: widget.name,
                      email: widget.email,
                      phone: widget.phone,
                      mrn: widget.mrn,
                      locationGroup: widget.locationGroup,
                      hospitalId: widget.hospitalId,
                      hospitalName: widget.hospitalName,
                      clinicName: widget.clinicName,
                      doctorName: widget.doctorName,
                      doctorImage: widget.doctorImage,
                      appointmentReason: widget.appointmentReason,
                      selectedOption: widget.selectedOption,
                      selectedDate: widget.selectedDate,
                      mapData : widget.mapData,
                    )
                ),
                    (Route<dynamic> route) => false);
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
            'Discover More'.tr,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'WorkSans'
            ),
          ),
          GestureDetector(
            child: Text(
              '${'More'.tr} >',
              style: TextStyle(
                  fontFamily: 'WorkSans',
                  color: Colors.blue.shade600,
                  fontSize: 15
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
                fontSize: 20),
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
                fontSize: 20),
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
                fontSize: 20
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

  Widget exploreTitle() {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, top: _height * 0.048),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Explore'.tr,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'WorkSans'
            ),
          ),
          // GestureDetector(
          //   child: Text(
          //     '${'More'.tr} >',
          //     style: TextStyle(
          //         fontFamily: 'WorkSans',
          //         color: Colors.blue.shade600,
          //         fontSize: 15
          //     ),
          //   ),
          //   // onTap: viewallapp,
          // ),
        ],
      ),
    );
  }

  Widget exploreServices() {
    return Container(
        margin: EdgeInsets.only(
            left: _width * 0.04, right: _width * 0.05, top: _height * 0.02, bottom: 0),
        height: _height * 0.16,
        width: _width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: <Widget>[
                  Container(
                    width: _width / 4.5,
                    height: _width / 3.9,
                    // height: _width / 4.2,
                    // margin: EdgeInsets.only(left: _width*0.01,right: _width*0.01),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => appointmentListing(
                                name: widget.name,
                                email: widget.email,
                                phone: widget.phone,
                                mrn: widget.mrn,
                                locationGroup: widget.locationGroup,
                                hospitalId: widget.hospitalId,
                                hospitalName: widget.hospitalName,
                                clinicName: widget.clinicName,
                                doctorName: widget.doctorName,
                                doctorImage: widget.doctorImage,
                                appointmentReason: widget.appointmentReason,
                                selectedOption: widget.selectedOption,
                                selectedDate: widget.selectedDate,
                                mapData : widget.mapData,
                              )
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            width: _width / 5.5,
                            height: _width / 6,
                            padding: EdgeInsets.all((10)), //icon size
                            decoration: customboxshadow,
                            child: Image.asset(
                              'assets/icons/appointment.png',
                              height: _height / 18,
                              width: _width / 14,
                            ),
                          ),
                          SizedBox(
                            height: _height * 0.01,
                          ),
                          Text(
                            'Appointment',
                            style: TextStyle(
                                fontFamily: 'WorkSans',
                                fontWeight: FontWeight.normal,
                                fontSize: MediaQuery.of(context).size.width * 0.030,
                                color: Colors.black
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: _width / 4.5,
                    height: _width / 3.9,
                    // margin: EdgeInsets.only(left: _width*0.01,right: _width*0.01),
                    child: GestureDetector(
                      onTap: () {
                      },
                      child: Column(
                        children: [
                          Container(
                            width: _width / 5.5,
                            height: _width / 6,
                            padding: EdgeInsets.all((7)), //icon size
                            decoration: customboxshadow,
                            child: Image.asset(
                              'assets/icons/queue_ticket.png',
                              // color: _deeppurple,
                              height: _height / 18,
                              width: _width / 14,
                            ),
                          ),
                          SizedBox(
                            height: _height * 0.01,
                          ),
                          Text(
                            'Queue',
                            style: TextStyle(
                                fontFamily: 'WorkSans',
                                fontWeight: FontWeight.normal,
                                fontSize: MediaQuery.of(context).size.width * 0.030,
                                color: Colors.black
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: _width / 4.5,
                    height: _width / 3.9,
                    // margin: EdgeInsets.only(left: _width*0.01,right: _width*0.01),
                    child: GestureDetector(
                        onTap: () {
                        },
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                width: _width / 5.5,
                                height: _width / 6,
                                padding: EdgeInsets.all((9)), //icon size
                                decoration: customboxshadow,
                                child: Image.asset(
                                  'assets/icons/heart_line.png',
                                  // color: _deeppurple,
                                  height: _height / 18,
                                  width: _width / 14,
                                ),
                              ),
                              SizedBox(
                                height: _height * 0.01,
                              ),
                              Text(
                                'Health Record',
                                style: TextStyle(
                                    fontFamily: 'WorkSans',
                                    fontWeight: FontWeight.normal,
                                    fontSize: MediaQuery.of(context).size.width * 0.030,
                                    color: Colors.black
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                              )
                            ],
                          ),
                        )),
                  ),
                  Container(
                    width: _width / 4.5,
                    height: _width / 3.9,
                    child: GestureDetector(
                      onTap: _launchAppOrStore, // Call the function on tap
                      child: Column(
                        children: [
                          Container(
                            width: _width / 5.5,
                            height: _width / 6,
                            padding: EdgeInsets.all(7), // Icon size
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset(
                              'assets/icons/TC2U_Transparent.png',
                              height: _height / 18,
                              width: _width / 14,
                            ),
                          ),
                          SizedBox(height: _height * 0.01),
                          Text(
                            'TrueCare2U',
                            style: TextStyle(
                              fontFamily: 'WorkSans',
                              fontWeight: FontWeight.normal,
                              fontSize: MediaQuery.of(context).size.width * 0.030,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget needHelpTitle() {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, top: _height * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '${'Need Help'.tr} ?',
            style: const TextStyle(
              fontSize: 18,
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
          left: _width / 18, right: _width / 18, top: _height / 35, bottom:  _height / 35
      ),
    );
  }
}