import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_avisena/Screens/HomePage/homepage.dart';
import 'package:flutter_avisena/const.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:http/http.dart' as http;

class ChooseSpecialist extends StatefulWidget {
  ChooseSpecialist({Key? key, required this.name, required this.email, required this.phone, required this.mrn, required this.hospitalId, required this.clinicName, required this.locationGroup}) : super(key: key);
  String name;
  String email;
  String phone;
  String mrn;
  String hospitalId;
  String clinicName;
  String locationGroup;

  @override
  State<ChooseSpecialist> createState() => _ChooseSpecialistState();
}

class _ChooseSpecialistState extends State<ChooseSpecialist> {

  List<dynamic> specialists = [];

  dynamic _height;
  dynamic _width;

  bool selected = false;

  String? selectedDoctorName;
  String? selectedDoctorImage;
  String? selectedClinicName;
  String? selectedCtpcp;
  String? selectedDoctorResource;
  String? selectedLocation;
  String? selectedLocationGroup;
  String? selectedHospitalId;

  List<Map<String, dynamic>> categories = [
    {
      "image": "assets/images/service_ash.jpeg",
      "name": "Dato' Dr. Abdul Razak Rahman Hamzah",
      "role": "Consultant ENT, Head & Neck Surgeon",
      "press": false
    },
    {
      "image": "assets/images/service_awch.jpeg",
      "name": "Prof Dato' Dr. Abdullah Sani Mohamed",
      "role": "Consultant ENT",
      "press": false
    },
    {
      "image": "assets/images/service_awch.jpeg",
      "name": "Dr. Ahmad Kusyairi Bin Khalid",
      "role": "Consultant ENT, Head & Neck Surgeon",
      "press": false
    },
  ];

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  Future<void> _fetchData() async {
    final response = await http.post(
      Uri.parse('http://10.10.0.11/trakcare/web/his/app/API/general.csp'),
      body: {
        'passCode' : 'Avi@2024',
        'reqNumber' : '9',
        'hospitalId' : widget.hospitalId,
        'locationGroup' : widget.locationGroup
      },
    );
    final responseBody = json.decode(response.body);
    setState(() {
      specialists = responseBody['list'];
    });
  }

  @override
  Widget build(BuildContext context) {

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return KeyboardDismisser(
      gestures: const [
        GestureType.onTap,
        GestureType.onPanUpdateDownDirection
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.violet,
          title: Text(
            'Choose Specialists'.tr,
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
        body: Padding(
          padding: EdgeInsets.only(top: _height * 0.025),
          child: ListView.builder(
            itemCount: specialists.length,
            itemBuilder: (BuildContext context, index) {
              final specialist = specialists[index];
              final isSelected = specialist['doctorName'] == selectedDoctorName;

              return InkWell(
                onTap: () {
                  setState(() {
                    selectedDoctorName = specialist['doctorName'];
                    selectedDoctorImage = specialist['doctorImage'];
                    selectedClinicName = specialist['clinicName'];
                    selectedCtpcp = specialist['ctpcp'];
                    selectedDoctorResource = specialist['doctorResource'];
                    selectedLocation = specialist['location'];
                    selectedLocationGroup = specialist['locationGroup'];
                    selectedHospitalId = specialist['hospitalId'];
                    selected = true;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal : _width * 0.04, vertical: _height * 0.005),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    color: (isSelected) ? turquoise : Colors.white,
                    elevation: 5.0,
                    child: Padding(
                      padding: EdgeInsets.all(_width * 0.03),
                      child: Row(
                        children: [
                          Container(
                            height: _height * 0.1,
                            width: _width * 0.2,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  specialist['doctorImage'],
                                ),
                                fit: BoxFit.contain
                              )
                            ),
                          ),
                          SizedBox(width: _width * 0.03),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  specialist['doctorName'],
                                  style: TextStyle(
                                    fontSize: _width * 0.045,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? Colors.white : turquoise,
                                  ),
                                ),
                                SizedBox(height: _height * 0.02),
                                Text(
                                  specialist['clinicName'],
                                  style: TextStyle(
                                    fontSize: _width * 0.035,
                                    color: isSelected ? Colors.white : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(bottom: 20, left: 30, right: 30),
          child: (selected == true) ? ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(name: widget.name, email: '', phone: '', mrn: '')));
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
          ) : ElevatedButton(
            onPressed: () {},
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
              primary: Colors.grey,
              padding: EdgeInsets.all(_width * 0.05),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)
              ),
            ),
          ),
        ),
      ),
    );
  }
}
