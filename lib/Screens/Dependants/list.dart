import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avisena/const.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class ListDependants extends StatefulWidget {
  const ListDependants();

  @override
  State<ListDependants> createState() => _ListDependantsState();
}

class _ListDependantsState extends State<ListDependants> {

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
                width: _width * 0.17,
              ),
              Text(
                "Dependant",
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
        backgroundColor : Colors.grey.shade200,
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
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
                //     ),
                //   ],
                // ),
                Padding(
                  padding: EdgeInsets.all(_width * 0.08),
                  child: Column(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
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
                                width: _width * 0.5,
                                child: const Text(
                                  'Roberto Anderson Allison Martin Odegaard Erling Haaland Cristiano Ronaldo',
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: _height * 0.02
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
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
                                width: _width * 0.5,
                                child: const Text(
                                  'Mark Ali Qayyum bin Mark Isa Zafir',
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                          height: _height * 0.02
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
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
                                width: _width * 0.5,
                                child: const Text(
                                  'Mad Nor bin Mad Din',
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                          height: _height * 0.02
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
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
                                width: _width * 0.5,
                                child: const Text(
                                  'Mad Nor bin Mad Din',
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                          height: _height * 0.02
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
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
                                width: _width * 0.5,
                                child: const Text(
                                  'Mad Nor bin Mad Din',
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                          height: _height * 0.02
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
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
                                width: _width * 0.5,
                                child: const Text(
                                  'Mad Nor bin Mad Din',
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                          height: _height * 0.02
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
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
                                width: _width * 0.5,
                                child: const Text(
                                  'Mad Nor bin Mad Din',
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                          height: _height * 0.02
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
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
                                width: _width * 0.5,
                                child: const Text(
                                  'Mad Nor bin Mad Din',
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                          height: _height * 0.02
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
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
                                width: _width * 0.5,
                                child: const Text(
                                  'Mad Nor bin Mad Din',
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                          height: _height * 0.02
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
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
                                width: _width * 0.5,
                                child: const Text(
                                  'Mad Nor bin Mad Din',
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                          height: _height * 0.02
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
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
                                width: _width * 0.5,
                                child: const Text(
                                  'Mad Nor bin Mad Din',
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                          height: _height * 0.02
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
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
                                width: _width * 0.5,
                                child: const Text(
                                  'Mad Nor bin Mad Din',
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          child: ElevatedButton(
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.add,
                ),
                Text(
                  'Add New',
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
