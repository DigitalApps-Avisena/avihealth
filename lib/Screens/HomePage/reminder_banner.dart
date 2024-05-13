import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../const.dart';
import '../../../size_config.dart';
import '../../components/section_title.dart';
// import 'package:shop_app/screens/home/components/notice.dart';

class ReminderBanner extends StatelessWidget {
  const ReminderBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
          width: double.infinity,
        ),
        Padding(
          // margin: EdgeInsets.all(getProportionateScreenWidth(20)),
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
            vertical: getProportionateScreenWidth(15),
          ),
          child: SectionTitle(
            title: "Reminder",
            press: () {},
          ),
        ),
        SizedBox(
          child: Column(
            children: [
              Container(
                height: getProportionateScreenHeight(85),
                width: getProportionateScreenWidth(340),
                decoration: BoxDecoration(
                  color: Color(0xFF6699d8),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 10),
                        blurRadius: 10,
                        color: violet.withOpacity(0.23)),
                  ],
                ),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 0.1, right: 70.0, top: 3.0),
                        child: Text.rich(
                          TextSpan(
                            style: TextStyle(color: Colors.white),
                            children: [
                              TextSpan(
                                  text: "Don't miss your appointment!\n \n",
                                  style: TextStyle(
                                    fontFamily: 'Ubuntu',
                                    fontSize: getProportionateScreenWidth(15),
                                    fontWeight: FontWeight.bold,
                                  )),
                              TextSpan(
                                text:
                                    "Check inbox for more details about your \n appointment",
                                style: TextStyle(
                                  fontFamily: 'Ubuntu',
                                  fontSize: getProportionateScreenWidth(13),
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
