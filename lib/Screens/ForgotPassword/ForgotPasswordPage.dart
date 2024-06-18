import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_avisena/Screens/OnboardPage/onboard.dart';
import 'dart:convert';

import '../../Helperfunctions.dart';
import '../../components/API.dart';
import '../../components/Database.dart';
import '../../components/auth.dart';
import '../../const.dart';
import '../../shared_configs.dart';
import '../HomePage/homepage.dart';
import '../LoginPage/login.dart';

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage();

  // final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => new _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  var _height;
  var _width;

  bool _passwordVisible = false;
  // final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  final emailInput = TextEditingController();
  final icInput = TextEditingController();
  late final getDeviceToken;
  SharedConfigs configs = SharedConfigs();
  Auth authService = new Auth();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final formKey = GlobalKey<FormState>();
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();

  TextStyle style = TextStyle(fontSize: 20.0, color: Colors.black);
  bool _isLoading = false;
  String? _errorMessage;
  bool iserror = false;
  var token;
  var mrn;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getToken();
    FirebaseMessaging.instance.getToken().then((newToken) {
      print('iosToken  $newToken');
      getDeviceToken = newToken;
    });
  }

  _getToken() async {
    if (Platform.isIOS) {
      FirebaseMessaging.instance.requestPermission();
    }
    FirebaseMessaging.instance.getToken().then((devicetoken) {
      print('Device token : $devicetoken');
      setState(() {
        token = devicetoken;
      });
    });
  }

  void forgotPassword() async {
    var userData = {
      "email": emailInput.text,
      "ic": icInput.text,
      "passCode": "Avi@2024",
      "reqNumber": "5",
    };
    var receiveData = await ApiService(userData).forgotPasswordCheck(userData);
    print('receiveData == $receiveData');

    if (receiveData["respond"] == "Update password1 success") {
      AwesomeDialog(
        padding: EdgeInsets.all(20),
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.topSlide,
        showCloseIcon: false,
        title: "A password reset link has been sent to your email",
        btnOkColor: violet,
        btnOkText: "Okay",
        desc:
        "Please follow the instruction and the link received in your email to reset your password",
        btnOkOnPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
      ).show();

      FirebaseFirestore.instance
          .collection('users')
          .doc(receiveData["mrn"])
          .set({
        'token': getDeviceToken,
        'name': receiveData["name"],
        'mrn': receiveData["mrn"],
        'createdAt': FieldValue.serverTimestamp(),
      });
    } else if (receiveData["respond"] == "IC not belong to the email") {
      AwesomeDialog(
        padding: EdgeInsets.all(20),
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        showCloseIcon: false,
        title: "IC number does not match",
        btnOkColor: violet,
        btnOkText: "Okay",
        desc: "Please make sure the IC number is belong to the email",
        btnOkOnPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
          );
        },
      ).show();
    } else {
      AwesomeDialog(
        padding: EdgeInsets.all(20),
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        showCloseIcon: false,
        title: "Unknown email address",
        btnOkColor: violet,
        btnOkText: "Okay",
        desc:
        "Please make sure you use the email that has been registered with us",
        btnOkOnPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
          );
        },
      ).show();
    }
  }

  // updatePatientData(id, token) async {
  //   var mapData = {
  //     "ID": id,
  //     "token": token,
  //   };
  //   await ApiService(userData).updatePatientApi(mapData);
  // }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    final emailField = TextFormField(
      controller: emailInput,
      obscureText: false,
      style: style,
      validator: (val) {
        return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(val!)
            ? null
            : "Please Enter Correct Email";
      },
      decoration: InputDecoration(
          contentPadding:
          EdgeInsets.only(top: 20), // add padding to adjust text
          isDense: true,
          prefixIcon: Padding(
            padding: EdgeInsets.only(top: 10), // add padding to adjust icon
            child: Icon(
              Icons.email,
              color: Colors.grey,
            ),
          ),
          hintText: "Email",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
          border: InputBorder.none),
    );

    final icField = TextFormField(
      controller: icInput,
      obscureText: false,
      style: style,
      validator: (val) {
        return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(val!)
            ? null
            : "Please Enter Correct Email";
      },
      decoration: InputDecoration(
          contentPadding:
          EdgeInsets.only(top: 20), // add padding to adjust text
          isDense: true,
          prefixIcon: Padding(
            padding: EdgeInsets.only(top: 10), // add padding to adjust icon
            child: Icon(
              Icons.person_sharp,
              color: Colors.grey,
            ),
          ),
          hintText: "IC No.",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
          border: InputBorder.none),
    );

    final submitForgotPasswordButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xFFA92389),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          forgotPassword();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Submit",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            SizedBox(
              width: 10,
            ),
            // Icon(
            //   Icons.arrow_forward,
            //   color: deeppurple,
            // )
          ],
        ),
      ),
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
              Color(0xFFA92389),
              Color(0xFF2290AA),
              Color(0xFF2290AA),
            ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 18,
                )),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeInUp(
                      duration: Duration(milliseconds: 1000),
                      child: Text(
                        "Forgot Password",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  FadeInUp(
                      duration: Duration(milliseconds: 1300),
                      child: Text(
                        "With Us, It’s Always Personal",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    )),
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Image.asset(
                              'assets/images/avisena_healthcare_logo.png'),
                          width: 212,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: Column(
                                children: <Widget>[
                                  const Text(
                                      'Insert your email and IC number for which you want to reset your password.',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FadeInUp(
                          duration: Duration(milliseconds: 1400),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(219, 211, 219, 1.0),
                                      blurRadius: 20,
                                      offset: Offset(0, 10))
                                ]),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade200))),
                                  child: Form(
                                    key: formKey,
                                    child: Column(
                                      children: <Widget>[
                                        emailField,
                                        SizedBox(height: 30.0),
                                        icField,
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: EdgeInsets.all(30),
                            child: SingleChildScrollView(
                              physics: NeverScrollableScrollPhysics(),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 70,
                                  ),
                                  submitForgotPasswordButton,
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     const Text('Already have an account?',
                        //         style: TextStyle(color: Colors.grey)),
                        //     TextButton(
                        //       style: TextButton.styleFrom(
                        //         primary: Color(0xFFa4278d),
                        //       ),
                        //       child: const Text(
                        //         'Login Here',
                        //         style: TextStyle(
                        //           fontWeight: FontWeight.w900,
                        //           decoration: TextDecoration.underline,
                        //         ),
                        //       ),
                        //       onPressed: () {
                        //         AwesomeDialog(
                        //           padding: EdgeInsets.all(20),
                        //           context: context,
                        //           dialogType: DialogType.success,
                        //           animType: AnimType.topSlide,
                        //           showCloseIcon: true,
                        //           title:
                        //               "A password reset link has been sent to your email",
                        //           btnOkColor: violet,
                        //           btnOkText: "Okay",
                        //           desc:
                        //               "Please follow the instruction and the link received in your email to reset your password",
                        //           btnOkOnPress: () {
                        //             Navigator.push(
                        //               context,
                        //               MaterialPageRoute(
                        //                   builder: (context) => LoginPage()),
                        //             );
                        //           },
                        //         ).show();
                        //       },
                        //     )
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}