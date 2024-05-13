import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../size_config.dart';
import '../../const.dart';

class Welcome extends StatefulWidget {
  @override
  _Welcome createState() => _Welcome();
}

class _Welcome extends State<Welcome> {
  String username = '';
  String name = '';
  String displayName = '';

  @override
  void initState() {
    super.initState();
    getEmployerID();
  }

  void getEmployerID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = (prefs.getString('name') ?? '');
      name = (prefs.getString('name') ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // SizedBox(
        //   height: 10,
        //   width: 10,
        // ),
        Padding(
          // margin: EdgeInsets.all(getProportionateScreenWidth(20)),
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
            vertical: getProportionateScreenWidth(15),
          ),
          child: Column(
            children: <Widget>[
              _getHeader(name.length > 12
                  ? '${name.substring(0, 12)}...'
                  : name), //condition if..else
            ],
          ),
        ),
      ],
    );
  }

  Widget _getHeader(String name) {
    return Container(
      margin: EdgeInsets.only(top: 2, left: 1, right: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(children: <Widget>[
            CircleAvatar(
              child: Icon(
                Icons.person_pin,
                color: Colors.white,
                size: 42,
              ),
              radius: avatarsize,
              backgroundColor: violet,
            ),
            SizedBox(
              width: 5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Good day,",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.normal),
                ),
                Text(
                  "",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.bold),
                ),
              ],
            )
          ]),
          Icon(
            Icons.notifications_none_outlined,
            color: Colors.white,
            size: 32,
          ),
        ],
      ),
    );
  }
}
