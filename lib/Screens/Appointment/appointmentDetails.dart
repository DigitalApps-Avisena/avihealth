import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:lottie/lottie.dart';

import '../../const.dart';
import '../HomePage/homepage.dart';

class appointmentDetails extends StatelessWidget {
  final String? name;
  final String? email;
  final String? phone;
  final String? mrn;
  final DateTime? selectedDate;
  final String? selectedOption;
  final String? locationGroup;
  final String? appointmentReason;
  final String? hospitalId;
  final String? hospitalName;
  final String? clinicName;
  final String? doctorName;
  final String? doctorImage;
  final Map? mapData;

  const appointmentDetails({
    Key? key,
    required this.name,
    required this.email,
    required this.phone,
    required this.mrn,
    required this.selectedDate,
    required this.selectedOption,
    required this.appointmentReason,
    required this.locationGroup,
    required this.hospitalId,
    required this.hospitalName,
    required this.clinicName,
    required this.doctorName,
    required this.doctorImage,
    this.mapData,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    dynamic _height;
    dynamic _width;

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.violet,
        title: Text(
          'Details'.tr,
          style: TextStyle(
              fontSize: _width * 0.05,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'WorkSans'
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage(
              name: name.toString(),
              email: email.toString(),
              phone: phone.toString(),
              mrn: mrn.toString(),
              ),
            ),
          ),
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
                borderRadius: BorderRadius.circular(20), // Circular border radius
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/icons/thankyou_success.json',
                      height: 100,
                      width: 100,
                    ),
                    Text(
                      'Appointment Confirmed!',
                      style: TextStyle(
                          fontSize: 18.5,
                          color: Constants.violet,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'WorkSans'
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
                                image: doctorImage != null &&
                                    doctorImage != ""
                                    ? NetworkImage(doctorImage!)
                                    : const AssetImage(
                                    'assets/images/specialist.png')
                                as ImageProvider,
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
                                  ("${doctorName ?? "Dato Dr. Abdul Razak Rahman Hamzah"}"),
                                  style: TextStyle(
                                    color: turquoise,
                                    fontSize: _width * 0.040,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'WorkSans',
                                  ),
                                ),
                                SizedBox(height: _height * 0.02),
                                Text(
                                  ("${clinicName ?? ""}"),
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
                                  "${hospitalName ?? "Avisena Women's & Children's Specialist Hospital"}\n${clinicName ?? "Ear, Nose & Throat"}",
                                  style: const TextStyle(
                                    fontSize: 16,        // Adjust font size
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
                                "Date: ${selectedDate?.toLocal().toString().split(' ')[0] ?? '2024-12-31'}\nSession: ${selectedOption ?? 'Morning'}",
                                style: const TextStyle(
                                  fontSize: 16,        // Adjust font size
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
                              SizedBox(width: 8), // Add space between the icon and text
                              Text(
                                "Ayu Nabilah Binti Dzulkifle\n970617016588",
                                style: TextStyle(
                                  fontSize: 16,        // Adjust font size
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'WorkSans',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage(
                name: name.toString(),
                email: email.toString(),
                phone: phone.toString(),
                mrn: mrn.toString(),
              ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Home'.tr,
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
}
