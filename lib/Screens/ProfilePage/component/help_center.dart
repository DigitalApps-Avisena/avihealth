import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avisena/const.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpCenter extends StatefulWidget {
  @override
  HelpCenterState createState() => HelpCenterState();
}

class HelpCenterState extends State<HelpCenter> {

  dynamic _width;

  // final LatLng _center = const LatLng(3.072311413646597, 101.52342357118974);
  final LatLng _center = const LatLng(3.0717126040570144, 101.52119828248152);
  late GoogleMapController _googleMapController;

  @override
  void dispose() {
    // TODO: implement dispose
    _googleMapController.dispose();
    super.dispose();
  }

  // Color state for button.
  Color _getTextColor(Set<MaterialState> states) => states.any(<MaterialState>{
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
  }.contains)
      ? turquoise
      : violet;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Help Center",
          style: TextStyle(
            fontSize: 22,
            fontFamily: 'WorkSans',
            fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 22,
          ),
        ),
        backgroundColor: Constants.violet,
      ),
      body: Column(
        children: [
          Flexible(
            flex: 2,
            child: GoogleMap(
              onTap: (_center) {},
              onMapCreated: (mapController) {
                mapController.showMarkerInfoWindow(
                    MarkerId("Avisena Woman\'s & Children")
                );
              },
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 16.5,
              ),
              markers:
              {
                const Marker(
                  markerId: const MarkerId("Avisena Woman\'s & Children"),
                  position: LatLng(3.071695244368616, 101.52124270995965),
                  infoWindow: InfoWindow(
                    title: "Avisena Woman\'s & Children",
                  ),// InfoWindow
                ),
              },
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Get in touch with us today. We’re always ready to help.",
                    style: TextStyle(
                      fontSize: 18.5,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      color: turquoise
                    ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Listed below are contact details to get in touch with us with any questions and/or concerns you may have.",
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'WorkSans'
                    ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            ],
          ),
          Flexible(
              flex: 3,
              child: Container(
                margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextButton.icon(
                            onPressed: () {
                              FlutterPhoneDirectCaller.callNumber('+6 03 5515 1888');
                              },
                            icon: Icon(Icons.call, color: Colors.white, size: 20),
                            style: TextButton.styleFrom(
                                backgroundColor: MaterialStateColor.resolveWith(_getTextColor),
                                shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)
                                ),
                                padding: EdgeInsets.all(10.0),
                                elevation: 10
                            ),
                            label: Text("General Line", style: TextStyle(color: Colors.white, fontSize: 15.0, fontFamily: 'WorkSans'),
                            ),
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            FlutterPhoneDirectCaller.callNumber('+6 03 5515 1966');
                          },
                          icon: Icon(Icons.record_voice_over_outlined, color: Colors.white, size: 20),
                          style: TextButton.styleFrom(
                              backgroundColor: MaterialStateColor.resolveWith(_getTextColor),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              padding: EdgeInsets.all(10.0),
                              elevation: 10
                          ),
                          label: Text("Appointment Line", style: TextStyle(color: Colors.white, fontSize: 15.0, fontFamily: 'WorkSans'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(padding: EdgeInsets.all(8.0),
                        child: TextButton.icon(
                          onPressed: () {
                            launch('mailto:awcsh.careline@avisena.com.my?subject=This is Subject');
                          },
                          icon: Icon(Icons.email_outlined, color: Colors.white, size: 20),
                          style: TextButton.styleFrom(
                              backgroundColor: MaterialStateColor.resolveWith(_getTextColor),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18)
                              ),
                              padding: EdgeInsets.all(10.0),
                              elevation: 10
                          ),
                          label: Text("Email", style: TextStyle(color: Colors.white, fontSize: 15.0, fontFamily: 'WorkSans'),
                          ),
                        ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: Color(0xFF2290AA), size: 18),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Avisena Women's & Children's Specialist Hospital:",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily:'WorkSans',
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    Text("No. 3, Jalan Perdagangan 14/4, Seksyen 14, 40000 Shah Alam, \nSelangor.",
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily:'WorkSans',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.access_time_rounded, color: Color(0xFF2290AA), size: 18),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Specialists Clinic hours:",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily:'WorkSans',
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    Text("Monday to Friday: \n9am to 5pm | 6pm to 8pm \n\nSaturday: \n9am to 1pm \n\nSunday / Public Holidays: \nClosed",
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily:'WorkSans',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.emergency_outlined, color: Color(0xFF2290AA), size: 18),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Accident & Emergency:",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily:'WorkSans',
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    Text("A & E is open 24 hours.",
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily:'WorkSans',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
    ]
          )
    );
  }
}

