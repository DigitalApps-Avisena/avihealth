import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottie/lottie.dart';
import 'dart:convert';

import '../../Helperfunctions.dart';
import '../../components/API.dart';
import '../../components/Database.dart';
import '../../components/auth.dart';
import '../../const.dart';
import '../../shared_configs.dart';
import '../HomePage/homepage.dart';
import '../SignUp/SignUpPage.dart';
import 'package:flutter_avisena/Screens/ForgotPassword/ForgotPasswordPage.dart';

class LoginPage extends StatefulWidget {
  LoginPage();

  // final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => new _LoginSignupPageState();
}

enum SupportState {
  unknown,
  supported,
  unSupported,
}

class _LoginSignupPageState extends State<LoginPage> {
  var _height;
  var _width;

  final LocalAuthentication auth = LocalAuthentication();
  SupportState supportState = SupportState.unknown;
  List<BiometricType>? availableBiometrics;

  bool _passwordVisible = false;
  // final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  final emailInput = TextEditingController();
  final passwordInput = TextEditingController();
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
    auth.isDeviceSupported().then((bool isSupported) => setState(() =>
        supportState =
            isSupported ? SupportState.supported : SupportState.unSupported));
    super.initState();
    checkBiometric();
    getAvailableBiometrics();
  }

  Future<void> checkBiometric() async {
    late bool canCheckBiometric;
    try {
      canCheckBiometric = await auth.canCheckBiometrics;
      print("Biometric supported: $canCheckBiometric");
    } on PlatformException catch (e) {
      print(e);
      canCheckBiometric = false;
    }
  }

  Future<void> getAvailableBiometrics() async {
    late List<BiometricType> biometricTypes;
    try {
      biometricTypes = await auth.getAvailableBiometrics();
      print("supported biometrics $biometricTypes");
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) {
      return;
    }
    setState(() {
      availableBiometrics = biometricTypes;
    });
  }

  Future<void> authenticateWithBiometrics() async {
    try {
      final authenticated = await auth.authenticate(
          localizedReason: 'Authenticate with fingerprint or Face ID',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: false,
          ));

      if (!mounted) {
        return;
      }

      if (authenticated) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    } on PlatformException catch (e) {
      print(e);
      return;
    }
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

  void login() async {
    var userData = {
      "email": emailInput.text,
      "password": passwordInput.text,
      "passCode": "Avi@2024",
      "reqNumber": "1",
    };
    var receiveData = await ApiService(userData).loginCheck(userData);
    print('receiveData == $receiveData');

    if (receiveData["status"] == "1") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );

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
        'gender': receiveData["gender"],
        'dependent': receiveData["dependent"],
        'dateOfBirth': receiveData["dateOfBirth"],
        'createdAt': FieldValue.serverTimestamp(),
      });
    } else if (receiveData["respond"] == "Login fail, email not found") {
      AwesomeDialog(
        padding: EdgeInsets.all(20),
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        title: "User not found!",
        btnOkColor: violet,
        btnOkText: "Okay",
        desc:
            "Please make sure you use the email that has been registered with us",
        btnOkOnPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
      ).show();
    } else {
      return AwesomeDialog(
        padding: EdgeInsets.all(20),
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        title: "Wrong password!",
        btnOkColor: violet,
        btnOkText: "Okay",
        desc:
            "Please check your password carefully and try again or just click on Forgot Your Password link below",
        btnOkOnPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
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
          hintStyle:
              TextStyle(color: Colors.grey, fontFamily: 'Roboto', fontSize: 15),
          border: InputBorder.none),
    );

    final passwordField = TextFormField(
      controller: passwordInput,
      obscureText: _passwordVisible ? false : true,
      style: style,
      //   },
      decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: () {
              // Update the state i.e. toogle the state of passwordVisible variable
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
          isDense: true,
          prefixIcon: Padding(
            padding: EdgeInsets.only(top: 10), // add padding to adjust icon
            child: Icon(
              Icons.lock,
              color: Colors.grey,
            ),
          ),
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          hintStyle:
              TextStyle(color: Colors.grey, fontFamily: 'Roboto', fontSize: 15),
          border: InputBorder.none),
    );

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xFFa4278d),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          login();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Login",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold)),
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
          Color(0xFFa4278d),
          Color(0xff5dbad4),
          Color(0xFF2e92b0),
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
                        "Login",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'WorkSans',
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
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Roboto',
                            fontSize: 18),
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
                                        passwordField,
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
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          primary: Colors.grey,
                                        ),
                                        child: const Text(
                                          'Forgot Your Password?',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.w400,
                                              decoration:
                                                  TextDecoration.underline),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ForgotPasswordPage(),
                                              ));
                                        },
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 70,
                                  ),
                                  loginButton,
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      const Expanded(child: Divider()),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Text("Or",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontFamily: 'Roboto',
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      const Expanded(child: Divider()),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          primary: Color(0xFFa4278d),
                                        ),
                                        child: const Text(
                                          'Biometric Login',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                        onPressed: authenticateWithBiometrics,
                                      ),
                                      Lottie.asset(
                                          'assets/images/biometric_auth.json',
                                          height: 40,
                                          width: 40),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('Don\'t have an account?',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontFamily: 'Roboto',
                                              fontSize: 15)),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          primary: Color(0xFFa4278d),
                                        ),
                                        child: const Text(
                                          'Sign Up',
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
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
                                                    SignUpPage(),
                                              ));
                                        },
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('Don\'t have an account?',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontFamily: 'Roboto',
                                              fontSize: 15)),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          primary: Color(0xFFa4278d),
                                        ),
                                        child: const Text(
                                          'Go to Home Screen',
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
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
                                                    HomePage(),
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
