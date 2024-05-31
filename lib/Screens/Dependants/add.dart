import 'package:flutter/material.dart';
import 'package:flutter_avisena/Screens/Dependants/list.dart';
import 'package:flutter_avisena/const.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class AddDependants extends StatefulWidget {
  const AddDependants();

  @override
  State<AddDependants> createState() => _AddDependantsState();
}

class _AddDependantsState extends State<AddDependants> {

  TextEditingController controller = TextEditingController();

  final formKey = GlobalKey<FormState>();

  dynamic _height;
  dynamic _width;

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
          backgroundColor: Colors.transparent,
          title: Row(
            children: [
              SizedBox(
                width: _width * 0.13,
              ),
              Text(
                "Add Dependant",
                style: TextStyle(
                    fontSize: _width * 0.05,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'WorkSans'
                ),
              ),
            ],
          ),
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
                Icons.arrow_back_rounded,
                color: Colors.black,
                size: _width * 0.07
            ),
          ),
          elevation: 0,
        ),
        backgroundColor: Colors.grey.shade200,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // SizedBox(
              //   height: _height * 0.05,
              // ),
              // Row(
              //   children: [
              //     IconButton(
              //       onPressed: () => Navigator.of(context).pop(),
              //       icon: Icon(
              //         Icons.arrow_back_rounded,
              //         color: Colors.black,
              //         size: _width * 0.07
              //       ),
              //     ),
              //     SizedBox(
              //       width: _width * 0.2,
              //     ),
              //     Text(
              //       "Add Dependent",
              //       style: TextStyle(
              //         fontSize: _width * 0.05,
              //         color: Colors.black,
              //         fontWeight: FontWeight.bold,
              //         fontFamily: 'WorkSans'
              //       ),
              //       maxLines: 5,
              //       overflow: TextOverflow.ellipsis,
              //     ),
              //   ],
              // ),
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
                    // height: 500,
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
                              'IC Number',
                              style: TextStyle(
                                fontSize: _width * 0.045,
                                fontWeight: FontWeight.bold,
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
                        const Text(
                          'Please bring the physical IC card\nfor the review and approvsl\nprocess​',
                          textAlign: TextAlign.center,
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
          margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context, MaterialPageRoute(
                  builder: (context) => ListDependants(),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Submit',
                  style: TextStyle(
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
                borderRadius: BorderRadius.circular(10)
              ),
            ),
          ),
        ),
      ),
    );
  }
}
