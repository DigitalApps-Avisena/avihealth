import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../const.dart';
import '../../../size_config.dart';

class needHelp extends StatelessWidget {
  const needHelp({
    Key? key,
    required this.text,
    required this.press,
  }) : super(key: key);

  final String text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: press,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Container(
                width: 250,
                decoration: BoxDecoration(color: violet
                    // image: DecorationImage(
                    //     image: AssetImage(image), fit: BoxFit.cover)
                    ),
              ),
              Container(
                width: 280,
                margin: EdgeInsets.only(top: 1),
                padding: EdgeInsets.symmetric(
                    horizontal: 1), //jarak text from start line
                // decoration: BoxDecoration(color: Colors.white),
                child: new BackdropFilter(
                  filter: new ImageFilter.blur(sigmaX: 15.0, sigmaY: 5.0),
                  child: new Container(
                    width: 120,
                    height: 200,
                    decoration: new BoxDecoration(
                        borderRadius:
                            new BorderRadius.all(Radius.circular(20)),
                        color: Colors.grey.shade200.withOpacity(0.2)),
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.only(top: 40, right: 25, left: 40),
                  // alignment: Alignment.center, // Centers the text horizontally and vertically
                  child: Text(
                    "$text\n",
                    maxLines: 5,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      // shadows: outlinedText(strokeColor: Colors.white, strokeWidth: 1),
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'WorkSans',
                      fontWeight: FontWeight.normal,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
