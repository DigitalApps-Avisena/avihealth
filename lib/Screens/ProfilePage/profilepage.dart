import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avisena/Screens/ProfilePage/profileMenu.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../components/user.dart';
import '../../const.dart';
import '../../size_config.dart';


class ProfilePage extends StatefulWidget {
  ProfilePage({
    Key? key,
    required this.name,
    required this.email,
    required this.phone
  }) : super(key: key);
  String name;
  String email;
  String phone;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<User> users = [];
  var opacity = 0.0;
  bool position = false;
  dynamic _height;
  dynamic _width;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      animator();

      setState(() {});
    });
  }

  animator() {
    if (opacity == 1) {
      opacity = 0;
      position = false;
    } else {
      opacity = 1;
      position = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: violet,
        title: Text(
            'Profile',
          style: TextStyle(
            fontSize: _width * 0.05,
            fontFamily: 'WorkSans',
            fontWeight: FontWeight.bold
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: _width * 0.05,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications,
              size: _width * 0.06,
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
              Color(0xFFA92389),
              Color(0xFF2290AA),
              Color(0xFF2290AA),
            ],
            ),
        ),
        child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Container(//box on top of background
                  margin: EdgeInsets.only(top: _height / 3.7),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(1.0),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(45),
                        topRight: Radius.circular(45),
                      )
                  ),
                  child:  profileMenuListing(),
                ),
                Container(//blur box - user details
                    margin: EdgeInsets.only(top: _height / 5.8),
                         padding: EdgeInsets.symmetric(horizontal: 1),
                         width: 350,
                         height: 175,
                         decoration: new BoxDecoration(
                             borderRadius:
                             new BorderRadius.all(Radius.circular(20)),
                             color: Colors.white.withOpacity(0.90),
                           boxShadow: [
                             BoxShadow(
                               color: Colors.black26,
                               offset: Offset(0.0, 5.0), //(x,y)
                               blurRadius: 8.0,
                             ),
                           ],
                         ),
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: <Widget>[
                           Text(widget.name,
                             style: TextStyle(
                                 fontSize: 20,
                                 color: Colors.black,
                                 fontWeight: FontWeight.bold,
                                 fontFamily: 'WorkSans'
                             ),
                       ),
                       SizedBox(
                         height: 10,
                       ),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           SizedBox(width: 5,),
                           Text(widget.email,
                             style: TextStyle(
                               fontSize: 17.5,
                               color: Colors.black54,
                               fontFamily: 'WorkSans',
                             ),
                           ),
                         ],
                       ),
                       SizedBox(
                         height: 2,
                       ),
                       Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Text("+6${widget.phone}",
                             style: TextStyle(
                               fontSize: 17.5,
                               color: Colors.black54,
                               fontFamily: 'Roboto',
                             ),
                           )
                         ],
                       ),
                     ],
               ),
                ),
                Container(//profile image
                    height: 145, width: 145,
                    margin: EdgeInsets.only(top: _height / 14.5),
                      // child: Image.asset('assets/images/profile_ayu.jpg', height: 160, width: 160),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(70),
                    border: Border.all(width: 1.5, color: const Color(0xFFFFFFFF)),
                    image: DecorationImage(
                        image: AssetImage('assets/images/profile_ayu.jpg'),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0.0, 5.0), //(x,y)
                        blurRadius: 8.0,
                      ),
                    ],
                  ),
                  )
              ],

            ),
    )
    );
  }

  Widget profileMenuListing() {
    SizeConfig().init(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: _height / 10,
          ),
          profileMenu(
            text: "My Account",
            icon: Icons.person,
            press: () {
              // Navigator.push(context,
              //     CupertinoPageRoute(builder: (context) => myAccountPage(email: '', name: '', phone: '',)
              //     )
              // );
            },
          ),
          profileMenu(
            text: "Dependent",
            icon: Icons.family_restroom_rounded,
            press: () {
              // Navigator.push(context,
              //     CupertinoPageRoute(builder: (context) => BrancheScreen()));
            },
          ),
          profileMenu(
            text: "Sutera Membership",
            icon: Icons.credit_card,
            press: () {
              launch('https://api.whatsapp.com/send/?phone=60327828777&text&app_absent=0');
            },
          ),
          profileMenu(
            text: "Privacy Policy",
            icon: Icons.description,
            press: () {
              // Navigator.push(context,
              //     CupertinoPageRoute(builder: (context) => SendEmail()));
            },
          ),
          profileMenu(
            text: "Language",
            icon: Icons.translate_rounded,
            press: () {
              // Navigator.push(context,
              //     CupertinoPageRoute(builder: (context) => SendEmail()));
            },
          ),
          profileMenu(
            text: "Help Center",
            icon: Icons.help_outline_rounded,
            press: () {
              // Navigator.push(context,
              //     CupertinoPageRoute(builder: (context) => SendEmail()));
            },
          ),
          profileMenu(
            text: "Sign Out",
            icon: Icons.logout,
            press: () {
              // Navigator.push(context,
              //     CupertinoPageRoute(builder: (context) => SendEmail()));
            },
          ),
        ],
      ),
    );
  }

}