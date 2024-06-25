import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avisena/Screens/Dependents/list.dart';
import 'package:flutter_avisena/const.dart';
import 'package:flutter_avisena/l10n/localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:http/http.dart' as http;

class AddDependents extends StatefulWidget {
  AddDependents({Key? key, required this.name, required this.email, required this.phone}) : super(key: key);
  String name;
  String email;
  String phone;

  @override
  State<AddDependents> createState() => _AddDependentsState();
}

class _AddDependentsState extends State<AddDependents> {

  TextEditingController controller = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final storage = FlutterSecureStorage();

  dynamic _height;
  dynamic _width;

  String number = '1234';

  List<TextSpan> _getStyledTextSpans() {
    return [
      TextSpan(text: AppLocalizations.of(context)!.translate('Add Dependent Instruction Mandatory')!, style: TextStyle(color: Colors.black, fontFamily:'WorkSans', fontWeight: FontWeight.bold)),
      TextSpan(text: AppLocalizations.of(context)!.translate('Add Dependent Instruction')!, style: TextStyle(color: Colors.black, fontFamily:'WorkSans')),
    ];
  }

  _getData() async {
    try {
      final response = await http.post(
        Uri.parse('http://10.10.0.11/trakcare/web/his/app/API/general.csp'),
        body: {
          'passCode' : 'Avi@2024',
          'reqNumber' : '7',
          'icAccHolder' : '970617016588',
          'icDependent' : controller.text
        },
      );
      final responseBody = response.body;
      final responseData = jsonDecode(responseBody);
      final dataCode = responseData['code'];
      print('A $responseBody');
      print('B $responseData');
      print('C $dataCode');
      if(dataCode == 'E01') {
        print('wohoo');
        Navigator.push(
          context, MaterialPageRoute(
            builder: (context) => ListDependents(name: widget.name, email: widget.email, phone: widget.phone),
          ),
        );
      } else {
        print('Woopd');
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
            Navigator.of(context).pop();
          },
        ).show();
      }
    } catch(e) {
      AwesomeDialog(
        padding: const EdgeInsets.all(20),
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        title: "IC number does not register with our system!",
        btnOkColor: violet,
        btnOkText: "Okay",
        desc:
        "Please register first through our app",
        btnOkOnPress: () {
          Navigator.of(context).pop();
        },
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    TextStyle style = TextStyle(fontSize: _width * 0.04);

    return KeyboardDismisser(
      gestures: const [
        GestureType.onTap,
        GestureType.onPanUpdateDownDirection
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.violet,
          title: Text(
            AppLocalizations.of(context)!.translate('Add Dependent')!,
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
        backgroundColor: Colors.grey.shade200,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  color: Colors.white,
                  elevation: 5.0,
                  child: SizedBox(
                    width: _width * 0.9,
                    height: _height * 0.3,
                    child: Column(
                      children: [
                        SizedBox(
                          height: _height * 0.05,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: _width * 0.08,
                            ),
                            Text(
                              AppLocalizations.of(context)!.translate('Personal Verification List')!,
                              style: TextStyle(
                                fontSize: _width * 0.04,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: _height * 0.01,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: _width * 0.07,
                            ),
                            SizedBox(
                              width: _width * 0.74,
                              height: _height * 0.069,
                              child: Card(
                                color: Colors.grey.shade200,
                                child: TextFormField(
                                  controller: controller,
                                  obscureText: false,
                                  style: style,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(top: _height * 0.02, left: 10),
                                    isDense: true,
                                    hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Roboto', fontSize: _width * 0.033),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: _height * 0.04,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: _width * 0.15),
                          child: RichText(
                            text: TextSpan(
                              children: _getStyledTextSpans(),
                            ),
                            textAlign: TextAlign.center
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
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(bottom: 20, left: 30, right: 30),
          child: ElevatedButton(
            onPressed: () {
              _getData();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.translate('Submit')!,
                  style: const TextStyle(
                      fontSize: 18,
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
