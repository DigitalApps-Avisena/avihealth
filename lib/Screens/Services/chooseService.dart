import 'dart:convert';
import 'dart:ui';
import 'package:flutter_avisena/l10n/localization.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avisena/Screens/Services/chooseSpecialist.dart';
import 'package:flutter_avisena/const.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class ChooseService extends StatefulWidget {
  ChooseService({Key? key, required this.name, required this.email, required this.phone, required this.mrn, required this.hospitalId}) : super(key: key);
  String name;
  String email;
  String phone;
  String mrn;
  String hospitalId;

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

  List<Map<String, dynamic>> categories = [
    {
      "image": "assets/images/service_accidentemergency.jpeg",
      "text": "Accident & Emergency",
      "press": false
    },
    {
      "image": "assets/images/service_accidentemergency.jpeg",
      "text": "Avisena Care (Home Care)",
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
        'reqNumber' : '2',
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
            AppLocalizations.of(context)!.translate('Choose Service')!,
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
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Colors.white,
            child: GridView.builder(
              itemCount: clinics.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, childAspectRatio: _width * 0.004
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
                      selected = true;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                      color: isSelected ? turquoise : Colors.white,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                scale: 50,
                                image: const AssetImage(
                                  "assets/images/service_accidentemergency.jpeg",
                                ),
                                fit: BoxFit.cover,
                                opacity: isSelected ? 200 : 1
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: _width * 0.02),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: _height / 5),
                                  color: violet,
                                  child: Text(
                                    clinic['clinicName'],
                                    style: const TextStyle(
                                      color: Colors.white
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: _height / 5),
                                  child: const Icon(
                                    CupertinoIcons.arrow_right_circle,
                                    color: Colors.white
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            ),
          ),
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          child: (selected == true) ? ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChooseSpecialist(
                    name: widget.name,
                    email: widget.email,
                    phone: widget.phone,
                    mrn: widget.mrn,
                    hospitalId: selectedHospitalId!,
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
                  AppLocalizations.of(context)!.translate('Next')!,
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
                  AppLocalizations.of(context)!.translate('Next')!,
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
