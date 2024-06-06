import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avisena/Screens/HomePage/homepage.dart';
import 'package:flutter_avisena/const.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class ChooseSpecialist extends StatefulWidget {
  ChooseSpecialist({Key? key, this.name}) : super(key: key);
  String? name;

  @override
  State<ChooseSpecialist> createState() => _ChooseSpecialistState();
}

class _ChooseSpecialistState extends State<ChooseSpecialist> {

  bool selected = false;

  dynamic _height;
  dynamic _width;

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
            "Choose Specialists",
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
            itemCount: categories.length,
            itemBuilder: (BuildContext context, index) {
              var image = categories[index]['image'];
              var name = categories[index]['name'];
              var role = categories[index]['role'];
              var press = categories[index]['press'];

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
                  padding: EdgeInsets.symmetric(horizontal : _width * 0.04, vertical: _height * 0.005),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    color: (press) ? turquoise : Colors.white,
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
                                image: AssetImage(image),
                                fit: BoxFit.cover
                              )
                            ),
                          ),
                          SizedBox(width: _width * 0.03),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: _width * 0.045,
                                    fontWeight: FontWeight.bold,
                                    color: press ? Colors.white : turquoise,
                                  ),
                                ),
                                SizedBox(height: _height * 0.02),
                                Text(
                                  role,
                                  style: TextStyle(
                                    fontSize: _width * 0.035,
                                    color: press ? Colors.white : Colors.grey.shade600,
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
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(name: widget.name)));
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
