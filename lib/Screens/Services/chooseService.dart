import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avisena/Screens/Services/chooseSpecialist.dart';
import 'package:flutter_avisena/const.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class ChooseService extends StatefulWidget {
  ChooseService({Key? key, this.name}) : super(key: key);
  String? name;

  @override
  State<ChooseService> createState() => _ChooseServiceState();
}

class _ChooseServiceState extends State<ChooseService> {

  bool selected = false;

  dynamic _height;
  dynamic _width;

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
    {
      "image": "assets/images/service_accidentemergency.jpeg",
      "text": "Child Development",
      "press": false
    },
    {
      "image": "assets/images/service_accidentemergency.jpeg",
      "text": "Child Psychology",
      "press": false
    },
    {
      "image": "assets/images/service_accidentemergency.jpeg",
      "text": "Dentistry",
      "press": false
    },
    {
      "image": "assets/images/service_accidentemergency.jpeg",
      "text": "Diagnotic Image",
      "press": false
    },
    {
      "image": "assets/images/service_accidentemergency.jpeg",
      "text": "Diagnotic Laboratory",
      "press": false
    },
    {
      "image": "assets/images/service_accidentemergency.jpeg",
      "text": "General Obstetrics and Gynaecology",
      "press": false
    },
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
    {
      "image": "assets/images/service_accidentemergency.jpeg",
      "text": "Child Development",
      "press": false
    },
    {
      "image": "assets/images/service_accidentemergency.jpeg",
      "text": "Child Psychology",
      "press": false
    },
    {
      "image": "assets/images/service_accidentemergency.jpeg",
      "text": "Dentistry",
      "press": false
    },
    {
      "image": "assets/images/service_accidentemergency.jpeg",
      "text": "Diagnotic Image",
      "press": false
    },
    {
      "image": "assets/images/service_accidentemergency.jpeg",
      "text": "Diagnotic Laboratory",
      "press": false
    },
    {
      "image": "assets/images/service_accidentemergency.jpeg",
      "text": "General Obstetrics and Gynaecology",
      "press": false
    },
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
    {
      "image": "assets/images/service_accidentemergency.jpeg",
      "text": "Child Development",
      "press": false
    },
    {
      "image": "assets/images/service_accidentemergency.jpeg",
      "text": "Child Psychology",
      "press": false
    },
    {
      "image": "assets/images/service_accidentemergency.jpeg",
      "text": "Dentistry",
      "press": false
    },
    {
      "image": "assets/images/service_accidentemergency.jpeg",
      "text": "Diagnotic Image",
      "press": false
    },
    {
      "image": "assets/images/service_accidentemergency.jpeg",
      "text": "Diagnotic Laboratory",
      "press": false
    },
    {
      "image": "assets/images/service_accidentemergency.jpeg",
      "text": "General Obstetrics and Gynaecology",
      "press": false
    },
    {
      "image": "assets/images/service_accidentemergency.jpeg",
      "text": "Diagnotic Image",
      "press": false
    },
    {
      "image": "assets/images/service_accidentemergency.jpeg",
      "text": "Diagnotic Laboratory",
      "press": false
    },
    {
      "image": "assets/images/service_accidentemergency.jpeg",
      "text": "General Obstetrics and Gynaecology",
      "press": false
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
            "Choose Service",
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
                itemCount: categories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: _width * 0.002
                ),
                itemBuilder: (context, index) {

                  var text = categories[index]['text'];
                  var image = categories[index]['image'];
                  var press = categories[index]['press'];
                  var textlength = categories[index]['text'].length;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        for(var i = 0; i < categories.length; i++) {
                          categories[i]['press'] = i == index;
                        }
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
                        color: press ? turquoise : Colors.white,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  scale: 50,
                                  image: AssetImage(
                                    image,
                                  ),
                                  fit: BoxFit.cover,
                                  opacity: press ? 200 : 1
                                )
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: _width * 0.02),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: _height / 5),
                                    child: Text(
                                      (text.length > 17) ? '${text.substring(0, 17)}\n${text.substring(17, textlength)}' : text,
                                      style: const TextStyle(
                                        color: Colors.white
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: _height / 5),
                                    child: Icon(CupertinoIcons.arrow_right_circle, color: Colors.white,)
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
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChooseSpecialist(name: widget.name)));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Next',
                  style: TextStyle(
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
              children: const [
                Text(
                  'Next',
                  style: TextStyle(
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
