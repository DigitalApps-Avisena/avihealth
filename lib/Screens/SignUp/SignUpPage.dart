import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import '../../Helperfunctions.dart';
import '../../components/API.dart';
import '../../components/Database.dart';
import '../../components/auth.dart';
import '../../const.dart';
import '../../shared_configs.dart';
import '../LoginPage/login.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage();

  // final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => new _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var _height;
  var _width;

  bool _passwordVisible = false;
  // final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  final emailInput = TextEditingController();
  final icInput = TextEditingController();
  final phoneInput = TextEditingController();
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

  void signUp() async {
    var userData = {
      "passCode": "Avi@2024",
      "reqNumber": "2",
      "ic": icInput.text,
      "email": emailInput.text,
      "phone": phoneInput.text,
    };
    var receiveData = await ApiService(userData).signUpCheck(userData);
    print('receiveData == $receiveData');

    if (receiveData["status"] == "1") {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => LoginPage()),
      // );
      AwesomeDialog(
        padding: EdgeInsets.all(20),
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.topSlide,
        showCloseIcon: false,
        title: "Success!",
        btnOkColor: violet,
        btnOkText: "Okay",
        desc:
        "We've sent you an email. Please check your email for verification to continue",
        btnOkOnPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
      ).show();
      FirebaseFirestore.instance
          .collection('users')
          .doc(receiveData["MRN"])
          .set({
        'token': getDeviceToken,
        'name': receiveData["name"],
        'MRN': receiveData["MRN"],
        'email': receiveData["email"],
        'IC': receiveData["IC"],
        'phone': receiveData["phone"],
        'createdAt': FieldValue.serverTimestamp(),
      });
    } else if (receiveData["statusCode"] == "02") {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Wrong Password!'),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('IC number does not registered on our system.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    print("NENGOK SINI $receiveData");
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

    final phoneNoField = TextFormField(
      controller: phoneInput,
      style: style,
      //   },
      decoration: InputDecoration(
          isDense: true,
          prefixIcon: Padding(
            padding: EdgeInsets.only(top: 10), // add padding to adjust icon
            child: Icon(
              Icons.phone,
              color: Colors.grey,
            ),
          ),
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Phone No.",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
          border: InputBorder.none),
    );

    final signUpButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xFFA92389),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          signUp();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Sign Up",
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

    // final dialogBox = Material(
    //   child: Container(
    //     padding: EdgeInsets.all(50),
    //     child: Column(
    //       children: [
    //         AnimatedButton(
    //           text: "",
    //           color: Colors.green,
    //           pressEvent: (){
    //             AwesomeDialog(
    //
    //             )
    //           }
    //         )
    //       ],
    //     ),
    //   ),
    // );

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
              height: 80,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeInUp(
                      duration: Duration(milliseconds: 1000),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  FadeInUp(
                      duration: Duration(milliseconds: 1300),
                      child: Text(
                        "Connect with us now!",
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
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Image.asset(
                              'assets/images/avisena_healthcare_logo.png'),
                          width: 200,
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
                                        // loading(),
                                        emailField,
                                        SizedBox(height: 30.0),
                                        icField,
                                        SizedBox(height: 30.0),
                                        phoneNoField,
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
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 50,
                                  ),
                                  signUpButton,
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('Already have an account?',
                                          style: TextStyle(color: Colors.grey)),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          primary: Color(0xFFA92389),
                                        ),
                                        child: const Text(
                                          'Login Here',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            decoration:
                                            TextDecoration.underline,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginPage(),
                                              ));
                                        },
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
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

  Widget loading() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Container();
    }
  }

  showerror() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)), //this right here
            child: Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        'Invalid email or password',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 150.0,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "OK",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: violet,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<void> errorAccountSignin(context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Email Already been used with other provider'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Use the Auth provider',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}