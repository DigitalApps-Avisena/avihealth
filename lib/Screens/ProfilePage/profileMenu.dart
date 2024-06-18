
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avisena/Screens/ProfilePage/component/myAccount.dart';

import '../../components/user.dart';
import '../../const.dart';

class profileMenu extends StatelessWidget {
  const profileMenu({
    Key? key,
    required this.text,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    dynamic _width;
    _width = MediaQuery.of(context).size.width;
    return Container(
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 45, vertical: 15),
              elevation: 10,
                    child: SizedBox(
                      width: _width * 0.80,
                      child: ListTile(
                        onTap: press,
                        leading: Icon(icon, color: violet),
                        title: Text(
                          text,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'WorkSans',
                          ),
                        ),
                        trailing: Wrap(
                          spacing: 12, // space between two icons
                          children: <Widget>[
                            Icon(Icons.keyboard_arrow_right_rounded),
                          ],
                        ),
                      ),
                    )
                )
    );
  }
}