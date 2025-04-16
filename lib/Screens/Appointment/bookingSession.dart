import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_avisena/Screens/Services/chooseService.dart';
import 'package:flutter_avisena/const.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../Helperfunctions.dart';
import '../../const.dart';
import '../Services/chooseHospital.dart';
import 'appointmentConfirmation.dart';

class sessionBooking extends StatefulWidget {
  sessionBooking({
    Key? key,
    required this.name,
    required this.email,
    required this.phone,
    required this.mrn,
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
  String? hospitalId;
  String? hospitalName;
  String? clinicName;
  String? locationGroup;
  String? doctorName;
  String? doctorImage;
  Map? mapData;


  @override
  State<sessionBooking> createState() => _sessionBookingState();
}

class _sessionBookingState extends State<sessionBooking> {

  DateTime? selectedDay; // Start with null to have no pre-selected day.
  DateTime focusedDay = DateTime.now(); // Required by TableCalendar.

  dynamic _height;
  dynamic _width;

  // For radio buttons
  String? selectedOption;

  //For dropdown
  String? selectedValue;

  // Controller for the text field
  TextEditingController appointmentReasonController = TextEditingController();

  //Next button
  bool selected = false;

  List<String> membersname = [];
  List<String> membersid = [];
  var selectedUser;
  var selectedid;

  @override
  void initState() {
    super.initState();
    print("Hospital(sessionBooking): ${widget.hospitalName}");
    print("Clinic Name(sessionBooking): ${widget.clinicName}");
    print("Doctor Name(sessionBooking): ${widget.doctorName}");
  }

  submitSurvey() async {
    Constants.myName = (await HelperFunctions.getUserNameSharedPreference());
    Constants.myId = (await HelperFunctions.getUserIdSharedPreference());
    Constants.myPhone = await HelperFunctions.getUserPhoneNoPreference();
    Constants.address = Constants.address;
    Map<String, dynamic> mapData = {
      "username": Constants.myName,
      "userId": Constants.myId,
      "appointmentId": null,
      "createdDate": DateTime.now(),
      "status": "Pending",
      "care provider": widget.doctorName,
      "appointmentDate": selectedDay,
      "appointmentTime": selectedOption,
      "appointmentType": selectedValue,
      "hospitalId": widget.hospitalId,
      "hospitalName": widget.hospitalName,
      "service": widget.clinicName,
      "address": Constants.address,
      "phone": Constants.myPhone,
    };
    print("mapData Booking Session: $mapData");
    // print("itstrue ");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => appointmentConfirmation(
          name: widget.name,
          email: widget.email,
          phone: widget.phone,
          mrn: widget.mrn,
          selectedDate: selectedDay,
          selectedOption: selectedOption,
          selectedValue: selectedValue,
          appointmentReason: appointmentReasonController.text,
          hospitalId: widget.hospitalId,
          hospitalName: widget.hospitalName,
          clinicName: widget.clinicName,
          locationGroup: widget.locationGroup,
          doctorName: widget.doctorName,
          doctorImage: widget.doctorImage,
          mapData: mapData,
        ),
      ),
    );
    }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.violet,
        title: Text(
          'Booking Session'.tr,
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
            decoration: BoxDecoration(
              color: Colors.white, // Background color of the container
              borderRadius: BorderRadius.circular(20), // Circular border radius
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TableCalendar(
                    focusedDay: focusedDay,
                    firstDay: DateTime(2000),
                    lastDay: DateTime(2100),
                    selectedDayPredicate: (day) {
                      // Highlight only if selectedDay is not null and matches the clicked day
                      return selectedDay != null && isSameDay(day, selectedDay);
                    },
                    onDaySelected: (clickedDay, focusedDay) {
                      setState(() {
                        selectedDay = clickedDay; // Update selectedDay on user click
                        this.focusedDay = focusedDay; // Update focusedDay as required
                      });
                    },
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false, // Hides the week/month toggle button
                      titleCentered: true, // Optional: Centers the month name
                      titleTextStyle: TextStyle(
                        fontSize: 20, // Custom font size
                        fontWeight: FontWeight.bold, // Custom font weight
                        color: Colors.black, // Custom text color
                        // fontStyle: FontStyle.italic, // Optional: Italicize the text
                      ),
                    ),
                    daysOfWeekStyle: const DaysOfWeekStyle(
                      // Custom style for weekdays (name of the day)
                      weekdayStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      // Custom style for weekends (name of the day)
                      weekendStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    calendarStyle: const CalendarStyle(
                      // Regular date style
                      defaultTextStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      // Weekend date style
                      weekendTextStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      // Customize the decoration of the selected day
                      selectedDecoration: BoxDecoration(
                        color: turquoise, // Set your custom color here
                        shape: BoxShape.circle, // Shape of the selected day
                      ),
                      todayDecoration: BoxDecoration(
                        color: violet, // Color for today
                        shape: BoxShape.circle,
                      ),
                      // Optionally, customize text styles
                      selectedTextStyle:   TextStyle(color: Colors.white), // Text color
                      todayTextStyle: TextStyle(color: Colors.white), // Text color for today
                    ),
                  ),
                  const SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Aligns all children to the left
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 16.0), // Optional: Add some left padding
                        child: Text(
                          "Preferred Session",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'WorkSans'
                          ),
                        ),
                      ),
                      RadioListTile<String>(
                        title: Text("Morning"),
                        value: "Morning",
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value;
                          });
                        },
                        activeColor: Constants.violet,
                      ),
                      RadioListTile<String>(
                        title: Text("Afternoon"),
                        value: "Afternoon",
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value;
                          });
                        },
                        activeColor: Constants.violet,
                      ),
                      RadioListTile<String>(
                        title: Text("Evening"),
                        value: "Evening",
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value;
                          });
                        },
                        activeColor: Constants.violet,
                      ),
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Text(
                          "Appointment Type",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'WorkSans'
                          ),
                        ),
                      ),
                      SizedBox(height: 10),  // Space between text and dropdown
                      // Simple Dropdown Button
                      Padding(
                        padding: EdgeInsets.only(left: 30.0),
                        child: DropdownButton<String>(
                          hint: const Text(
                            "Select an option",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'WorkSans'
                            ),
                          ), // Placeholder text when no option is selected
                          value: selectedValue,  // Currently selected value
                          items: <String>['Consultation with procedure', 'Consultation without procedure']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),  // Text to display for each dropdown item
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValue = newValue;  // Update the selected value
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Text(
                          "Appointment Reason",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'WorkSans'
                          ),
                        ),
                      ),
                      SizedBox(height: 10), // Space between text and dropdown
                      // Text Input Field
                      Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Container(
                            width: 370, // Set fixed width for the text field
                            height: 50, // Set a fixed height to shorten the text field
                            child: TextField(
                              controller: appointmentReasonController, // Controller to handle input text
                              decoration: const InputDecoration(
                                hintText: "Enter your reason...", // Placeholder text when no input
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey, width: 2.0), // Normal state
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: violet, width: 2.0), // Focused state
                                ), // Border styling
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, // Horizontal padding inside the TextField
                                  vertical: 15.0,   // Vertical padding inside the TextField
                                ),
                              ),
                            ),
                          )
                      ),
                      const SizedBox(height: 30),
                      // Button to navigate to the next page
                      Container(
                        margin: const EdgeInsets.only(bottom: 20, left: 30, right: 30),
                        child: ElevatedButton(
                          onPressed: () {
                            submitSurvey();
                            // Pass values to the next page
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => appointmentConfirmation(
                            //       name: widget.name,
                            //       email: widget.email,
                            //       phone: widget.phone,
                            //       mrn: widget.mrn,
                            //       selectedDate: selectedDay,
                            //       selectedOption: selectedOption,
                            //       appointmentReason: appointmentReasonController.text,
                            //       hospitalId: widget.hospitalId,
                            //       hospitalName: widget.hospitalName,
                            //       clinicName: widget.clinicName,
                            //       locationGroup: widget.locationGroup,
                            //       doctorName: widget.doctorName,
                            //       doctorImage: widget.doctorImage,
                            //     ),
                            //   ),
                            // );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Next'.tr,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            primary: Constants.violet,
                            padding: EdgeInsets.all(_width * 0.05),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),

          ),
        ),
      ),
      // bottomNavigationBar:
      // Container(
      //   decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: const BorderRadius.only(
      //         topLeft: Radius.circular(20.0),
      //         topRight: Radius.circular(20.0)),
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.grey.withOpacity(0.5),
      //         spreadRadius: 1,
      //         blurRadius: 1,
      //         offset: const Offset(0.0, 0.0), // changes position of shadow
      //       ),
      //     ],
      //   ),
      //   width: _width,
      //   height: _height * 0.10,
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: [
      //       Center(
      //         child: GestureDetector(
      //           onTap: () => {
      //             appointmentConfirmation(
      //               name: widget.name,
      //               email: widget.email,
      //               phone: widget.phone,
      //               mrn: widget.mrn,
      //               locationGroup: widget.locationGroup,
      //               hospitalId: widget.hospitalId,
      //               clinicName: widget.clinicName,
      //               selectedDate: selectedDay,
      //               selectedOption: selectedOption,
      //               appointmentReason: appointmentReasonController.text,
      //               hospitalName: widget.hospitalName,
      //               doctorName: widget.doctorName,
      //               doctorImage: widget.doctorImage,
      //             )
      //           },
      //           child: Container(
      //             margin:
      //             EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      //             padding: EdgeInsets.only(
      //                 left: _width * 0.02, right: _width * 0.02),
      //             width: _width * 0.8,
      //             height: _height * 0.07,
      //             decoration: BoxDecoration(
      //                 color: Constants.violet,
      //                 borderRadius: BorderRadius.circular(50),
      //                 boxShadow: [
      //                   BoxShadow(
      //                     color: Colors.grey.withOpacity(0.2),
      //                     spreadRadius: 0.5,
      //                     blurRadius: 1,
      //                     offset: new Offset(
      //                         2.0, 2.0), // changes position of shadow
      //                   ),
      //                 ]),
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: [
      //                 Text(
      //                   "Next",
      //                   style: TextStyle(
      //                       color: Colors.white,
      //                       fontSize: 18,
      //                       fontWeight: FontWeight.bold),
      //                 ),
      //                 SizedBox(
      //                   width: 10,
      //                 ),
      //                 Icon(
      //                   Icons.arrow_forward,
      //                   color: Colors.white,
      //                   size: 14,
      //                 )
      //               ],
      //             ),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // )
    );
  }
}


