import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../const.dart';
import '../../../size_config.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.image,
    required this.text,
    required this.press,
  }) : super(key: key);

  final String image, text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.all(
              (6), //icon size
            ),
            height: 50,
            width: 70,
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                  offset: const Offset(5, 10),
                  color: violet.withOpacity(0.23),
                  blurRadius: 5,
                ),
              ],
              color: Color(0xFFf8f8ff),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Image.asset(image),
          ),
          SizedBox(height: 10),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'WorkSans', fontSize: 14.5, color: Colors.black),
            maxLines: 2,
          )
        ],
      ),
    );
  }
}
