import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avisena/Screens/LoginPage/login.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../size_config.dart';
import '../../const.dart';
import '../HomePage/homepage.dart';
import 'body.dart';

class OnboardPage extends StatefulWidget {
  @override
  _OnboardPageState createState() => _OnboardPageState();
}

class _OnboardPageState extends State<OnboardPage> {
  int currentIndex = 0;
  late PageController _controller;
  bool _isGuestMode = false;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
    isGuestModeActive();
  }

  _toggleGuestMode(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isGuestMode = value;
      prefs.setBool('isGuest', value);
    });
  }

  Future<bool> isGuestModeActive() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isGuest') ?? false; // Default to false
  }


  void checkGuestMode() async {
    bool isGuest = await isGuestModeActive();
    if (!isGuest) {
      // Navigate to login or home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginPage(mrn: '', name: '', email: '', phone: '')),
      );
    }
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: contents.length,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, i) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      SizedBox(height: 80),
                      Lottie.asset(
                        contents[i].lottie,
                        height: 280,
                      ),
                      SizedBox(height: 40),
                      Text(
                        contents[i].title,
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'WorkSans',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                       Padding(
                         padding: EdgeInsets.all(10.0),
                         child: Text(
                           contents[i].description,
                           style: TextStyle(
                             fontSize: 15.5,
                             fontFamily: 'WorkSans',
                             color: Colors.black,
                           ),
                           overflow: TextOverflow.ellipsis,
                           maxLines: 10,
                           textAlign: TextAlign.center,
                         ),
                       )
                    ],
                  ),
                );
              },
            ),
          ),
          SmoothPageIndicator(
            controller: _controller,
            count: 5,
            effect: ExpandingDotsEffect(
              activeDotColor: Theme.of(context).primaryColor,
              dotColor: Colors.purple.shade100,
              dotHeight: 8,
              dotWidth: 8,
              spacing: 12,
            ),
          ),
          Container(
            margin: EdgeInsets.all(40),
            child: currentIndex == contents.length - 1
                ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                // Sign Up Button
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LoginPage(mrn: '', name: '', email: '', phone: ''),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text("Sign Up"),
                    ),
                  ),
                  // Continue as Guest Button
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        _toggleGuestMode(true);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HomePage(name: '', email: '', phone: '', mrn: ''),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: turquoise, // Different color for guest mode
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text("Continue as Guest", textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'WorkSans'
                        ),
                      ),
                    ),
                  ),
              ],
            )
                : SizedBox(
                  width: 140,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                    _controller.nextPage(
                      duration: Duration(milliseconds: 100),
                      curve: Curves.bounceIn,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor, // Updated property
                    onPrimary: Colors.white, // Updated property
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                    child: Text("Next"),
              ),
            )
          ),
        ],
      ),
    );
  }
}