import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avisena/Screens/Dependants/add.dart';
import 'package:flutter_avisena/Screens/HomePage/homepage.dart';
import 'package:flutter_avisena/const.dart';
import 'package:flutter_avisena/l10n/localization.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:http/http.dart' as http;

class ListDependants extends StatefulWidget {
  ListDependants({Key? key, required this.name, required this.email, required this.phone}) : super(key: key);
  String name;
  String email;
  String phone;

  @override
  State<ListDependants> createState() => _ListDependantsState();
}

class _ListDependantsState extends State<ListDependants> {

  dynamic _height;
  dynamic _width;

  var dataList = [];

  bool selected = false;

  @override
  void initState() {
    _getData();
    super.initState();
  }

  _getData() async {
    try{
      final response = await http.post(
        Uri.parse('http://10.10.0.11/trakcare/web/his/app/API/general.csp'),
        body: {
          'passCode' : 'Avi@2024',
          'reqNumber' : '8',
          'icAccHolder' : '970617016588'
        },
      );
      final responseBody = response.body;
      final responseData = jsonDecode(responseBody);
      final dataCode = responseData['code'];
      print('ADAM $responseBody');
      print('Hillman $responseData');
      print('Tya $dataCode');
      if(dataCode == "F01") {
        setState(() {
          dataList = responseData['list'];
        });
        print('Didi $dataList');
        print('Atan');
      } else {
        AwesomeDialog(
          padding: const EdgeInsets.all(20),
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.topSlide,
          showCloseIcon: true,
          title: "Registration dependent fail!",
          btnOkColor: violet,
          btnOkText: "Okay",
          desc:
          "Please fill correct number",
          btnOkOnPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListDependants(name: widget.name, email: widget.email, phone: widget.phone)),
            );
          },
        ).show();
        print('Gebu');
      }
    } catch(e) {
      AwesomeDialog(
        padding: const EdgeInsets.all(20),
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        title: "Fail!",
        btnOkColor: violet,
        btnOkText: "Okay",
        desc:
        "Please fill correct number",
        btnOkOnPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddDependants(name: widget.name, email: widget.email, phone: widget.phone)),
          );
        },
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return KeyboardDismisser(
      gestures: const [
        GestureType.onTap,
        GestureType.onPanUpdateDownDirection
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.violet,
          title: Text(
            AppLocalizations.of(context)!.translate('Dependants')!,
            style: TextStyle(
              fontSize: _width * 0.05,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'WorkSans'
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: _width * 0.05,
            ),
          ),
          elevation: 10,
        ),
        backgroundColor : Colors.grey.shade200,
        body: ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (BuildContext context, index) {

            var dependant = dataList[index];

            print('Bacarat $dependant');

            return Padding(
              padding: EdgeInsets.symmetric(vertical: _height * 0.01, horizontal: _width * 0.08),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.white,
                elevation: 5.0,
                child: SizedBox(
                  height: _height * 0.1,
                  child: Row(
                    children: [
                      SizedBox(
                        width: _width * 0.03,
                      ),
                      Icon(
                        CupertinoIcons.person_solid,
                        color: Colors.grey.shade700,
                        size: _width * 0.08,
                      ),
                      SizedBox(
                        width: _width * 0.03,
                      ),
                      SizedBox(
                        width: _width * 0.6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dependant['name'],
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black
                              ),
                            ),
                            SizedBox(
                              height: _height * 0.01,
                            ),
                            Text(
                              dependant['IC'],
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.black
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(bottom: 20, left: 35, right: 35),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddDependants(name: widget.name, email: widget.email, phone: widget.phone)));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add,
                ),
                Text(
                  AppLocalizations.of(context)!.translate('Add New')!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
            style: ElevatedButton.styleFrom(
              elevation: 5,
              primary: Constants.violet,
              padding: EdgeInsets.all(_width * 0.05),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)
              ),
            ),
          ),
        ),
      ),
    );
  }
}
