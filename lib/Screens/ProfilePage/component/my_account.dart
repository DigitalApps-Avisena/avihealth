import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avisena/Screens/ProfilePage/profilepage.dart';
import 'package:flutter_avisena/const.dart';
import 'package:flutter_avisena/l10n/localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class MyAccount extends StatefulWidget {
  MyAccount({Key? key, required this.name, required this.email, required this.phone, required this.mrn}) : super(key: key);
  String name;
  String email;
  String phone;
  String mrn;

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {

  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();

  File? image;

  dynamic _height;
  dynamic _width;

  var name;
  var email;
  var phone;

  String? selectedImagePath;

  @override
  void initState() {

    super.initState();
    _getData();
  }

  _getData() async {
    FirebaseFirestore.instance.collection('users').doc(widget.mrn).get().then((DocumentSnapshot documentSnapshot) {
      if(documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
        Map<String, dynamic>? data = documentSnapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          name = data['name'];
          email = data['email'];
          phone = data['phone'];
          setState(() {
            controllerName = TextEditingController(text: name);
            controllerEmail = TextEditingController(text: email);
            controllerPhone = TextEditingController(text: phone);
          });
          print('Name: $name, $email, $phone');
        } else {
          print('Document data is null');
        }
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  Future selectImage() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ), //this right here
          child: SizedBox(
            height: 150,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  const Text(
                    'Select Image From :',
                    style: TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.bold
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          selectedImagePath = await _gallery();
                          print('Image_Path:-');
                          print(selectedImagePath);
                          if (selectedImagePath != '') {
                            Navigator.pop(context);
                            setState(() {});
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text("No Image Selected !"),
                            ));
                          }
                        },
                        child: Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: const [
                                // Image.asset(
                                //   'images/gallery.png',
                                //   height: 60,
                                //   width: 60,
                                // ),
                                Text('Gallery'),
                              ],
                            ),
                          )
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          selectedImagePath = await _camera();
                          print('Image_Path:-');
                          print(selectedImagePath);

                          if (selectedImagePath != '') {
                            Navigator.pop(context);
                            setState(() {});
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text("No Image Captured !"),
                            ));
                          }
                        },
                        child: Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: const [
                                // Image.asset(
                                //   'images/camera.png',
                                //   height: 60,
                                //   width: 60,
                                // ),
                                Text('Camera'),
                              ],
                            ),
                          )
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      });
  }

  _gallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70);
    setState(() {
      if(pickedFile != null) {
        image = File(pickedFile.path);
      }
    });
  }

  _camera() async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 70);
    setState(() {
      if(pickedFile != null) {
        image = File(pickedFile.path);
      }
    });
  }

  _postData() async {
    FirebaseFirestore.instance.collection('users').doc(widget.mrn).update({
      "phone" : controllerPhone.text
    });
    Navigator.push(
      context, MaterialPageRoute(
        builder: (context) => ProfilePage(name: widget.name, email: widget.email, phone: widget.phone, mrn: widget.mrn)
      ),
    );
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
          centerTitle: true,
          backgroundColor: violet,
          title: Text(
            AppLocalizations.of(context)!.translate('My Account')!,
            style: TextStyle(
              fontSize: _width * 0.05,
              fontFamily: 'WorkSans',
              fontWeight: FontWeight.bold
            ),
          ),
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: _width * 0.05,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                print('ADIK ${image!.path}');
              },
              icon: Icon(
                Icons.notifications,
                size: _width * 0.06,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: _height * 0.05,
              ),
              Center(
                child: InkWell(
                  onTap: selectImage,
                  child: CircleAvatar(
                    backgroundImage: image == null
                        ? AssetImage('assets/images/profile_ayu.jpg') as ImageProvider
                        : FileImage(image!),
                    radius: 80,
                  ),
                ),
              ),
              SizedBox(
                height: _height * 0.05,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Text('Name'),
                      ],
                    ),
                    SizedBox(
                      height: _height * 0.01,
                    ),
                    TextFormField(
                      controller: controllerName,
                      enabled: false,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade300,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: turquoise,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: Colors.grey.shade500,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: turquoise,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: const [
                        Text('Email'),
                      ],
                    ),
                    SizedBox(
                      height: _height * 0.01,
                    ),
                    TextFormField(
                      controller: controllerEmail,
                      enabled: false,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade300,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: turquoise,
                            width: 2.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: Colors.grey.shade500,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: turquoise,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: const [
                        Text('Phone'),
                      ],
                    ),
                    SizedBox(
                      height: _height * 0.01,
                    ),
                    TextFormField(
                      controller: controllerPhone,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: turquoise,
                            width: 2.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: Colors.grey.shade500,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: turquoise,
                            width: 2.0,
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
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(bottom: 20, left: 35, right: 35),
          child: ElevatedButton(
            onPressed: () {
              _postData();
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddDependents(name: widget.name, email: widget.email, phone: widget.phone)));
            },
            child: Text(
              AppLocalizations.of(context)!.translate('Save')!,
              style: const TextStyle(
                fontWeight: FontWeight.bold
              ),
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