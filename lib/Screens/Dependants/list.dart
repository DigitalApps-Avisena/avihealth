import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avisena/Screens/HomePage/homepage.dart';
import 'package:flutter_avisena/const.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class ListDependants extends StatefulWidget {
  ListDependants({Key? key, this.name}) : super(key: key);
  String? name;

  @override
  State<ListDependants> createState() => _ListDependantsState();
}

class _ListDependantsState extends State<ListDependants> {

  dynamic _height;
  dynamic _width;

  bool selected = false;

  List<Map<String, dynamic>> categories = [
    {
      "name": "Calvin Klein",
      "press": false
    },
    {
      "name": "Rizman Abdullah",
      "press": false
    },
    {
      "name": "Asmawi Ani",
      "press": false
    },
    {
      "name": "Kazim Alias",
      "press": false
    },
    {
      "name": "David Arumugam",
      "press": false
    },
    {
      "name": "Karim Benzema",
      "press": false
    },
    {
      "name": "Iris Henry Marshall Fahmi Brian bin Mark Victor Minho Lee",
      "press": false
    },
    {
      "name": "Stephen Curry",
      "press": false
    },
  ];

  @override
  Widget build(BuildContext context) {

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    TextStyle style = TextStyle(fontSize: _width * 0.04);

    return KeyboardDismisser(
      gestures: const [
        GestureType.onTap,
        GestureType.onPanUpdateDownDirection
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.violet,
          title: Text(
            "Dependant",
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
        backgroundColor : Colors.grey.shade200,
        body: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (BuildContext context, index) {

            var name = categories[index]['name'];
            var press = categories[index]['press'];

            return Padding(
              padding: EdgeInsets.symmetric(vertical: _height * 0.01, horizontal: _width * 0.08),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: press ? turquoise : Colors.white,
                elevation: 5.0,
                child: SizedBox(
                  height: _height * 0.1,
                  child: Row(
                    children: [
                      SizedBox(
                        width: _width * 0.03,
                      ),
                      Icon(
                        CupertinoIcons.person_solid,
                        color: press ? Colors.white : Colors.grey.shade700,
                        size: _width * 0.08,
                      ),
                      SizedBox(
                        width: _width * 0.03,
                      ),
                      SizedBox(
                        width: _width * 0.5,
                        child: Text(
                          name,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: press ? Colors.white : Colors.black
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(bottom: 20, left: 35, right: 35),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(name: '', phone: '', email: '',)));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.add,
                ),
                Text(
                  'Add New',
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
          ),
        ),
      ),
    );
  }
}
