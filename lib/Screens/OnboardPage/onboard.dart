import 'package:flutter/material.dart';
import 'package:flutter_avisena/Screens/LoginPage/login.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../size_config.dart';
import '../../const.dart';
import 'body.dart';

class OnboardPage extends StatefulWidget {
  @override
  _OnboardPageState createState() => _OnboardPageState();
}

class _OnboardPageState extends State<OnboardPage> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
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
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          contents[i].description,
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Roboto',
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 8,
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
            height: 40,
            margin: EdgeInsets.all(40),
            width: 200,
            child: FlatButton(
              child: Text(
                  currentIndex == contents.length - 1 ? "Continue" : "Next"),
              onPressed: () {
                if (currentIndex == contents.length - 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LoginPage(),
                    ),
                  );
                }
                _controller.nextPage(
                  duration: Duration(milliseconds: 100),
                  curve: Curves.bounceIn,
                );
              },
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}