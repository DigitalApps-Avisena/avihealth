import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avisena/Screens/Dependants/list.dart';
import 'package:flutter_avisena/const.dart';
import 'package:flutter_avisena/l10n/localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class AddDependants extends StatefulWidget {
  AddDependants({Key? key, this.name}) : super(key: key);
  String? name;

  @override
  State<AddDependants> createState() => _AddDependantsState();
}

class _AddDependantsState extends State<AddDependants> {

  TextEditingController controller = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final storage = FlutterSecureStorage();

  dynamic _height;
  dynamic _width;

  String number = '1234';

  List<TextSpan> _getStyledTextSpans() {
    return [
      TextSpan(text: AppLocalizations.of(context)!.translate('Add Dependant Instruction Mandatory')!, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      TextSpan(text: AppLocalizations.of(context)!.translate('Add Dependant Instruction')!, style: TextStyle(color: Colors.black)),
    ];
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
            AppLocalizations.of(context)!.translate('Add Dependant')!,
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
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: _width * 0.06
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
              if(controller.text == number) {
                Navigator.push(
                  context, MaterialPageRoute(
                    builder: (context) => ListDependants(name: widget.name),
                  ),
                );
              } else {
                AwesomeDialog(
                  padding: const EdgeInsets.all(20),
                  context: context,
                  dialogType: DialogType.warning,
                  animType: AnimType.topSlide,
                  showCloseIcon: true,
                  title: "Number Not Register",
                  btnOkColor: violet,
                  btnOkText: "Okay",
                  desc:
                  "Please register new dependant at Avisena Healthcare registration counter.",
                  btnOkOnPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddDependants(name: widget.name,)),
                    );
                  },
                ).show();
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.translate('Submit')!,
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
