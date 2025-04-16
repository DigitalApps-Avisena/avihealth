import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import '../../components/API.dart';
import '../../components/database.dart';
import '../../const.dart';
import 'appointmentDetails.dart';

class appointmentConfirmation extends StatefulWidget {

  appointmentConfirmation({
    Key? key,
    required this.name,
    required this.email,
    required this.phone,
    required this.mrn,
    required this.selectedDate,
    required this.selectedOption,
    required this.selectedValue,
    required this.appointmentReason,
    required this.hospitalId,
    required this.hospitalName,
    required this.clinicName,
    required this.locationGroup,
    required this.doctorName,
    required this.doctorImage,
    this.mapData,
  }) : super(key: key);

  String? name;
  String? email;
  String? phone;
  String? mrn;
  DateTime? selectedDate;
  String? selectedOption;
  String? selectedValue;
  String? appointmentReason;
  String? hospitalId;
  String? hospitalName;
  String? clinicName;
  String? locationGroup;
  String? doctorName;
  String? doctorImage;
  Map? mapData;

  @override
  State<appointmentConfirmation> createState() => _appointmentConfirmationState();
}

class _appointmentConfirmationState extends State<appointmentConfirmation> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  var mapData;

  @override
  void initState() {
    super.initState();
    print("mapData Appt Confirm: $mapData");
    print("Hospital(sessionBooking): ${widget.hospitalName}");
    print("Clinic Name(sessionBooking): ${widget.clinicName}");
    print("Doctor Name(sessionBooking): ${widget.doctorName}");
    print("Date(sessionBooking): ${widget.selectedDate}");
  }

  _displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(content: Text('processing...'));
    _scaffoldKey.currentState?.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    dynamic _height;
    dynamic _width;

    _height = MediaQuery
        .of(context)
        .size
        .height;
    _width = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.violet,
        title: Text(
          'Confirmation'.tr,
          style: TextStyle(
              fontSize: _width * 0.05,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'WorkSans'
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: _width * 0.06
          ),
        ),
        elevation: 10,
      ),
      backgroundColor: Colors.grey.shade200,
      body: KeyboardDismisser(
        gestures: const [
          GestureType.onTap,
          GestureType.onPanUpdateDownDirection
        ],
        child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              height: _height * 1.20,
              decoration: BoxDecoration(
                color: Colors.white, // Background color of the container
                borderRadius: BorderRadius.circular(
                    20), // Circular border radius
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 15),
                      // Space from the top
                      child: Text(
                        'Appointment Details',
                        style: TextStyle(
                            fontSize: 18.5,
                            color: Constants.violet,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'WorkSans'
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.all(_width * 0.03),
                      child: Row(
                        children: [
                          Container(
                            height: _height * 0.15,
                            width: _width * 0.3,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  widget.doctorImage ??
                                      "assets/images/default.jpg",
                                ),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          SizedBox(width: _width * 0.03),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ("${widget.doctorName}"),
                                  style: TextStyle(
                                    color: turquoise,
                                    fontSize: _width * 0.040,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'WorkSans',
                                  ),
                                ),
                                SizedBox(height: _height * 0.02),
                                Text(
                                  ("${widget.clinicName}"),
                                  style: TextStyle(
                                    fontSize: _width * 0.035,
                                    fontFamily: 'WorkSans',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.all(_width * 0.03),
                      child: Column(
                        children: [
                          //Hospital and Service selected
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_rounded,
                                color: violet,
                                size: 40,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "${widget.hospitalName}\n${widget
                                      .clinicName}",
                                  style: const TextStyle(
                                    fontSize: 16, // Adjust font size
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'WorkSans',
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          //Date and Session selected
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_month_rounded,
                                color: violet,
                                size: 40,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Date: ${widget.selectedDate?.toLocal()
                                    .toString()
                                    .split(' ')[0] ?? 'None'}\nSession: ${widget
                                    .selectedOption ?? 'None'}",
                                style: const TextStyle(
                                  fontSize: 16, // Adjust font size
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'WorkSans',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          //Patient Details
                          Row(
                            children: const [
                              Icon(
                                Icons.person, // Icon of a calendar
                                color: violet, // Set color for the icon
                                size: 40, // Adjust size as needed
                              ),
                              SizedBox(width: 8),
                              // Add space between the icon and text
                              Text(
                                "Ayu Nabilah Binti Dzulkifle\n970617016588",
                                style: TextStyle(
                                  fontSize: 16, // Adjust font size
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'WorkSans',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Text("Selected Date: ${selectedDate?.toLocal().toString().split(' ')[0] ?? 'None'}"),
                    // Text("Preferred Session: ${selectedOption ?? 'None'}"),
                    // Text("Reason for Appointment: ${appointmentReason ?? 'None'}"),
                  ],
                ),
              ),
            )
        ),
      ),
      bottomNavigationBar: Container(
          margin: const EdgeInsets.only(bottom: 20, left: 30, right: 30),
          child:
          ElevatedButton(
            onPressed: () {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.success,
                animType: AnimType.bottomSlide,
                title: "Success",
                desc: "Your appointment has been successfully booked!",
                btnOkText: "Okay",
                // Custom text for the "OK" button
                btnOkOnPress: () {
                  insertToFirebaseAppointment();
                },
                btnOkColor: Constants.violet, // Use your color for the button
              ).show();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Book Now'.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            style: ElevatedButton.styleFrom(
              elevation: 5,
              primary: Constants.violet,
              padding: EdgeInsets.all(_width * 0.05),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          )

      ),
    );
  }

  onSubmit() async {
    _displaySnackBar(context);
    Map<String, dynamic> updatePatientApi = {
      "passCode": "Avi@2024",
      "reqNumber": "12",
      "icAccHolder": "950506045330",
      "icDependent": "",
      "hospitalId": widget.hospitalId,
      "location": "12",
      "doctorResource": "902",
      "ctpcp": "415",
      "appointmentResource": "1",
      "appointmentDate": widget.selectedDate?.toLocal().toString().split(' ')[0],
      "slotTimeID": widget.selectedOption,
      "timeHorolog": "34200",
      "appointmentNote": widget.appointmentReason,
      "appointmentType": widget.selectedValue,

    };

    print("updatePatientApi ======!!! $updatePatientApi");
    await ApiService()
        .createAppointment(updatePatientApi)
        .then((value) async {
      if (value == null) {
        Navigator.pushNamed(context, "/SERVER_ERROR");
      } else {
        print("response profile == ${value}");

        // await insertToFirebaseAppointment(value);
      }
        }
    );
  }

  insertToFirebaseAppointment() async {
    var date = "${DateTime.now().toString().split(' ')[0]}";
    var formattime = DateFormat('kk:mm:ss').format(DateTime.now());
    print('hhh');
    await DatabaseMethods().addAppointment();
    goToThankYouPage(mapData);
  }

  void goToThankYouPage(thismapData) {
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
            mapData : mapData,
          )
        ),
            (Route<dynamic> route) => false);
  }
}

