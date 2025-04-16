import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_avisena/Screens/Services/chooseService.dart';
import 'package:flutter_avisena/const.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import '../../const.dart';
import '../../const.dart';

class ChooseHospital extends StatefulWidget {
  ChooseHospital({Key? key, required this.name, required this.email, required this.phone, required this.mrn}) : super(key: key);
  String? name;
  String? email;
  String? phone;
  String? mrn;

  @override
  State<ChooseHospital> createState() => _ChooseHospitalState();
}

class _ChooseHospitalState extends State<ChooseHospital> {

  dynamic _height;
  dynamic _width;

  String? hospital;
  String? selectedhospitalName;

  bool selected = false;

  List<Map<String, dynamic>> categories = [
    {
      "image": "assets/images/service_ash.jpeg",
      "name": "Avisena Specialist Hospital",
      "address": "No. 4, Jalan Ikhtisas, Seksyen 14,\n40000 Shah Alam, Selangor D.E, Malaysia.",
      "press": false,
      "hospitalId" : '1'
    },
    {
      "image": "assets/images/service_awch.jpeg",
      "name": "Avisena Women's & Children's Specialist Hospital",
      "address": "No. 3, Jalan Perdagangan 14/4,\nSeksyen 14, 40000 Shah Alam, Selangor, Malaysia.",
      "press": false,
      "hospitalId" : '2'
    },
  ];

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
            'Hospital'.tr,
            style: TextStyle(
              fontSize: _width * 0.04,
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
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            color: Colors.white,
            child: GridView.builder(
              itemCount: categories.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: _width * 0.0033
              ),
              itemBuilder: (context, index) {

                var hospitalName = categories[index]['name'];
                var address = categories[index]['address'];
                var image = categories[index]['image'];
                var press = categories[index]['press'];
                var hospitalId = categories[index]['hospitalId'];

                return InkWell(
                  onTap: () {
                    setState(() {
                      for(var i = 0; i < categories.length; i++) {
                        categories[i]['press'] = i == index;
                      }
                      selected = true;
                      hospital = hospitalId;
                      selectedhospitalName = hospitalName;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Card(
                      elevation: 15,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                      color: (press) ? turquoise : Colors.white,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: _height * 0.01,
                            ),
                            Container(
                              height: _height * 0.2,
                              width: _width * 0.80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: AssetImage(image),
                                    fit: BoxFit.cover,
                                  )
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                hospitalName,
                                style: TextStyle(
                                    fontSize: _width * 0.03,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'WorkSans',
                                    color: (press) ? Colors.white : Colors.black
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                address,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: _width * 0.03,
                                    fontFamily: 'WorkSans',
                                    color: (press) ? Colors.white : Colors.black
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ),
                  ),
                );
              }
            ),
          ),
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(bottom: 20, left: 30, right: 30),
          child: (selected == true) ? ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChooseService(
                    name: widget.name,
                    email: widget.email,
                    phone: widget.phone,
                    mrn: widget.mrn,
                    hospitalId: hospital!,
                    hospitalName: selectedhospitalName!,
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
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ),
    );
  }
}