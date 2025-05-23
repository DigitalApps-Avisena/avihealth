import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../Helperfunctions.dart';
import '../../components/API.dart';
import '../../components/Database.dart';
import '../../components/auth.dart';
import '../../const.dart';
import '../../shared_configs.dart';
import '../HomePage/homepage.dart';
import '../OnboardPage/onboard.dart';
import '../SignUp/SignUpPage.dart';
import 'package:flutter_avisena/Screens/ForgotPassword/ForgotPasswordPage.dart';

class LoginPage extends StatefulWidget {
  LoginPage({
    Key? key,
    required this.name,
    required this.email,
    required this.phone,
    required this.mrn
  }) : super(key: key);


  // final VoidCallback loginCallback;
  String name;
  String email;
  String phone;
  String mrn;

  @override
  State<StatefulWidget> createState() => new _LoginSignupPageState();
}

enum SupportState {
  unknown,
  supported,
  unSupported,
}

class _LoginSignupPageState extends State<LoginPage> {

  final storage = FlutterSecureStorage();
  final LocalAuthentication auth = LocalAuthentication();
  SupportState supportState = SupportState.unknown;
  List<BiometricType>? availableBiometrics;

  bool _passwordVisible = false;
  final emailInput = TextEditingController();
  final passwordInput = TextEditingController();
  late final getDeviceToken;
  SharedConfigs configs = SharedConfigs();
  Auth authService = Auth();
  DatabaseMethods databaseMethods = DatabaseMethods();
  final formKey = GlobalKey<FormState>();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  bool iserror = false;
  var token;
  bool isFaceIDSupported = false;
  bool _isGuestMode = false;

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
    exitGuestMode();
  }

  void exitGuestMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isGuestMode = false;
      prefs.setBool('isGuest', false);
    });
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
    var name = await storage.read(key: 'name');
    var email = await storage.read(key: 'email');
    var phone = await storage.read(key: 'phone');
    var mrn = await storage.read(key: 'mrn');

    final auth = LocalAuthentication();

    try {

      // Check available biometric types
      final availableBiometrics = await auth.getAvailableBiometrics();
      bool supportsFaceID = availableBiometrics.contains(BiometricType.face);
      bool supportsFingerprint = availableBiometrics.contains(BiometricType.fingerprint);

      setState(() {
        isFaceIDSupported = availableBiometrics.contains(BiometricType.face);
      });

      // Debug prints or logs (optional)
      print('Supports Face ID: $supportsFaceID');
      print('Supports Fingerprint: $supportsFingerprint');
      print('isFaceIDSupported: $isFaceIDSupported');

      // Prompt for authentication
      final authenticated = await auth.authenticate(
        localizedReason: supportsFaceID
            ? 'Authenticate with Face ID'
            : 'Authenticate with fingerprint',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (!mounted) {
        return;
      }

      if (authenticated) {
        if (name != null) {
          _isGuestMode == false;
          exitGuestMode();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                name: name,
                email: email.toString(),
                phone: phone.toString(),
                mrn: mrn.toString(),
              ),
            ),
          );
        } else {
          return AwesomeDialog(
            padding: const EdgeInsets.all(20),
            context: context,
            dialogType: DialogType.warning,
            animType: AnimType.topSlide,
            showCloseIcon: true,
            title: "Biometric Authentication",
            btnOkColor: violet,
            btnOkText: "Okay",
            desc: "Please login by using email for first time login",
            btnOkOnPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(
                    mrn: widget.mrn,
                    phone: '',
                    email: '',
                    name: '',
                  ),
                ),
              );
            },
          ).show();
        }
      }
    } on PlatformException catch (e) {
      print('Error during biometric authentication: $e');
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
    var receiveData = await ApiService().loginCheck(userData);
    print('receiveData == $receiveData');

    if (receiveData["status"] == "1") {

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
      await storage.write(key: 'name', value: receiveData["name"]);
      await storage.write(key: 'email', value: receiveData["email"]);
      await storage.write(key: 'phone', value: receiveData["phone"]);
      await storage.write(key: 'mrn', value: receiveData["MRN"]);

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(name: receiveData["name"], email: receiveData["email"], phone: receiveData["phone"], mrn: receiveData["MRN"]),
          )
      );
    } else if (receiveData["respond"] == "Login fail, email not found") {
      AwesomeDialog(
        padding: const EdgeInsets.all(20),
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
            MaterialPageRoute(builder: (context) => LoginPage(name: '', email: '', mrn: '', phone: '',)),
          );
        },
      ).show();
    } else {
      return AwesomeDialog(
        padding: const EdgeInsets.all(20),
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
            MaterialPageRoute(builder: (context) => LoginPage(name: '', email: '', mrn: '', phone: '',)),
          );
        },
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    TextStyle style = TextStyle(fontSize: screenWidth * 0.04);

    final emailField = TextFormField(
      controller: emailInput,
      obscureText: false,
      style: style,
      validator: (val) {
        return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val!)
            ? null
            : "Please Enter Correct Email";
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(top: screenHeight * 0.02),
        isDense: true,
        prefixIcon: Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.01),
          child: Icon(
            Icons.email,
            color: Colors.grey,
            size: screenWidth * 0.06,
          ),
        ),
        hintText: "Email",
        hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Roboto', fontSize: screenWidth * 0.033),
        border: InputBorder.none,
      ),
    );

    final passwordField = TextFormField(
      controller: passwordInput,
      obscureText: !_passwordVisible,
      style: style,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
            size: screenWidth * 0.06,
          ),
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
        isDense: true,
        prefixIcon: Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.01),
          child: Icon(
            Icons.lock,
            color: Colors.grey,
            size: screenWidth * 0.06,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: screenHeight * 0.02, horizontal: screenWidth * 0.05),
        hintText: "Password",
        hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Roboto', fontSize: screenWidth * 0.033),
        border: InputBorder.none,
      ),
    );

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: const Color(0xFFa4278d),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          login();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Login",
              textAlign: TextAlign.center,
              style: style.copyWith(
                  color: Colors.white,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      body: KeyboardDismisser(
        gestures: const [
          GestureType.onTap,
          GestureType.onPanUpdateDownDirection
        ],
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Color(0xFFA92389),
                Color(0xFF2290AA),
                Color(0xFF2290AA),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: screenHeight * 0.1),
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.05),
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
                          fontSize: screenWidth * 0.08,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    FadeInUp(
                      duration: Duration(milliseconds: 1300),
                      child: Text(
                        "With Us, It’s Always Personal",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Roboto',
                          fontSize: screenWidth * 0.045,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Expanded(
                child: Container(
                  height: screenHeight * 0.75,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.075),
                    child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: screenHeight * 0.01),
                          Container(
                            alignment: Alignment.center,
                            child: Image.asset(
                              'assets/images/avisena_healthcare_logo.png',
                              width: screenWidth * 0.43,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.05),
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
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(screenWidth * 0.005),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.shade200,
                                        ),
                                      ),
                                    ),
                                    child: Form(
                                      key: formKey,
                                      child: Column(
                                        children: <Widget>[
                                          emailField,
                                          SizedBox(height: screenHeight * 0.04),
                                          passwordField,
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.025),
                            child: SingleChildScrollView(
                              physics: NeverScrollableScrollPhysics(),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          primary: Colors.grey,
                                        ),
                                        child: Text(
                                          'Forgot Your Password?',
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.033,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w400,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ForgotPasswordPage(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          primary: Colors.grey,
                                        ),
                                        child: Text(
                                          'Bypass Here',
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.033,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w400,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => HomePage(name: widget.name, email: widget.email, phone: widget.phone, mrn: widget.mrn),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          primary: Colors.grey,
                                        ),
                                        child: Text(
                                          'See Onboarding Page',
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.033,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w400,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => OnboardPage(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  // SizedBox(height: screenHeight * 0.07),
                                  loginButton,
                                  SizedBox(height: screenHeight * 0.03),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      const Expanded(child: Divider()),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15),
                                        child: Text(
                                          "Or",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontFamily: 'Roboto',
                                            fontSize: screenWidth * 0.033,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const Expanded(child: Divider()),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // TextButton(
                                      //   style: TextButton.styleFrom(
                                      //     primary: Color(0xFFA92389),
                                      //   ),
                                      //   child: const Text(
                                      //     'Biometric Login',
                                      //     style: TextStyle(
                                      //       fontWeight: FontWeight.w900,
                                      //       decoration: TextDecoration.underline,
                                      //     ),
                                      //   ),
                                      //   onPressed: authenticateWithBiometrics,
                                      // ),
                                      IconButton(
                                        onPressed: () {
                                          // Trigger the biometric authentication
                                          authenticateWithBiometrics();
                                        },
                                        icon: isFaceIDSupported
                                            ? Lottie.asset(
                                          'assets/icons/faceID.json',
                                          height: 80,
                                          width: 80,
                                        ) :
                                        Lottie.asset(
                                          'assets/icons/fingerprint.json',
                                          height: 45,
                                          width: 45,
                                        ),
                                        padding: EdgeInsets.zero, // Remove default padding
                                        constraints: BoxConstraints(
                                          minWidth: 90, // Set minimum width
                                          minHeight: 65, // Set minimum height
                                        ), // Remove default constraints
                                      ),
                                      Text(
                                        isFaceIDSupported ? "Face ID" : "Fingerprint",
                                        style: TextStyle(
                                          color: Constants.violet,
                                          fontSize: 12, // Adjust text size
                                          fontFamily: 'WorkSans',
                                          fontWeight: FontWeight.bold, // Optional
                                        ),
                                        textAlign: TextAlign.center, // Align text
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Don\'t have an account?',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Roboto',
                                          fontSize: 15,
                                        ),
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          primary: Color(0xFFA92389),
                                        ),
                                        child: Text(
                                          'Sign Up',
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.w900,
                                              decoration: TextDecoration.underline,
                                              fontSize: screenWidth * 0.033
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => SignUpPage(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
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
      ),
    );
  }

  Widget loading() {
    if (_isLoading) {
      return const Center(
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
                      child: const Text(
                        'Invalid email or password',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 150.0,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
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
          title: const Text('Email Already been used with other provider'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Use the Auth provider',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('Ok'),
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