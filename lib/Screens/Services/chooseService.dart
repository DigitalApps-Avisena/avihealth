import 'dart:convert';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avisena/Screens/Services/chooseSpecialist.dart';
import 'package:flutter_avisena/const.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class ChooseService extends StatefulWidget {
  ChooseService({Key? key, required this.name, required this.email, required this.phone, required this.mrn, required this.hospitalId, required this.hospitalName}) : super(key: key);
  String? name;
  String? email;
  String? phone;
  String? mrn;
  String? hospitalId;
  String? hospitalName;

  @override
  State<ChooseService> createState() => _ChooseServiceState();
}

class _ChooseServiceState extends State<ChooseService> {

  List<dynamic> clinics = [];

  dynamic _height;
  dynamic _width;

  bool selected = false;

  String? selectedClinicName;
  String? selectedLocationGroup;
  String? selectedHospitalId;
  String? selectedhospitalName;


  @override
  void initState() {
    _fetchData();
    super.initState();
    print("Hospital(Service) : ${widget.hospitalName}");
  }

  Future<void> _fetchData() async {
    final response = await http.post(
      Uri.parse('http://10.10.0.11/trakcare/web/his/app/API/general.csp'),
      body: {
        'passCode' : 'Avi@2024',
        'reqNumber' : '8',
        'hospitalId' : widget.hospitalId
      },
    );
    final responseBody = json.decode(response.body);
    setState(() {
      clinics = responseBody['list'];
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
            'Services'.tr,
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
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: _width * 0.06
            ),
          ),
          elevation: 10,
        ),
        backgroundColor: Colors.grey.shade200,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, // Background color of the container
              borderRadius: BorderRadius.circular(20), // Circular border radius
            ),
            child: GridView.builder(
            itemCount: clinics.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of items per row
              crossAxisSpacing: 2.0, // Space between items horizontally
              mainAxisSpacing: 2.0, // Space between items vertically
              childAspectRatio: 5 / 6, // Adjust the width-to-height ratio of the items
            ),
            itemBuilder: (context, index) {
              final clinic = clinics[index];
              final isSelected = clinic['clinicName'] == selectedClinicName;

              return InkWell(
                onTap: () {
                  setState(() {
                    selectedClinicName = clinic['clinicName'];
                    selectedLocationGroup = clinic['locationGroup'];
                    selectedHospitalId = clinic['hospitalId'];
                    selectedhospitalName = widget.hospitalName;
                    selected = true;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), // Match Card's border radius
                    border: Border.all(
                      color: isSelected ? Constants.violet : Colors.transparent, // Dynamic border color
                      width: 2.5, // Border width
                    ),
                  ),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: isSelected ? smoothPink.withOpacity(0.6) : Colors.white,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: AssetImage(
                                "assets/images/services/${clinic['clinicName']}.jpeg",
                              ),
                              fit: BoxFit.cover,
                              opacity: isSelected ? 200 : 1,
                            ),
                          ),
                        ),
                        // Gradient overlay at the bottom
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20), // Match card border radius
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.8), // Black shadow at the bottom
                                Colors.transparent, // Clear at the top
                              ],
                              begin: Alignment.bottomCenter, // Gradient starts at the bottom
                              end: Alignment.topCenter, // Gradient ends at the top
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Container(
                                  // color: violet,
                                  margin: EdgeInsets.only(top: _height / 6),
                                  padding: const EdgeInsets.all(4.0), // Padding inside the colored box
                                  child: Text(
                                    clinic['clinicName'],
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'WorkSans'
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 4,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: _height / 6),
                                child: const Icon(
                                  CupertinoIcons.arrow_right_circle,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

      ),
        bottomNavigationBar:
        Container(
          margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          child: (selected == true) ?
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChooseSpecialist(
                    name: widget.name,
                    email: widget.email,
                    phone: widget.phone,
                    mrn: widget.mrn,
                    hospitalId: selectedHospitalId!,
                    hospitalName: widget.hospitalName,
                    clinicName: selectedClinicName!,
                    locationGroup: selectedLocationGroup!,
                  ),
                ),
              );
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
          )
              :
          // ElevatedButton(
          //   onPressed: () {},
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Text(
          //         'Next'.tr,
          //         style: const TextStyle(
          //           fontWeight: FontWeight.bold
          //         ),
          //       ),
          //     ],
          //   ),
          //   style: ElevatedButton.styleFrom(
          //     elevation: 5,
          //     primary: Colors.grey,
          //     padding: EdgeInsets.all(_width * 0.05),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(30)
          //     ),
          //   ),
          // ),
          //////////////////////////////////////////////////////
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChooseSpecialist(
                    name: widget.name,
                    email: widget.email,
                    phone: widget.phone,
                    mrn: widget.mrn,
                    hospitalId: "",
                    hospitalName: widget.hospitalName,
                    clinicName: "",
                    locationGroup:"",
                  ),
                ),
              );
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
          )
        ),
      ),
    );
  }
}
