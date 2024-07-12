import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_avisena/const.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:pdfx/pdfx.dart';

class PdfTermsofUse extends StatefulWidget {
  final  url;
  final String? title;

  const PdfTermsofUse({Key? key, this.url, this.title}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<PdfTermsofUse> {
  // Load from URL
  late PdfControllerPinch pdfControllerPinch;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pdfControllerPinch = PdfControllerPinch(document: PdfDocument.openAsset('assets/pdf/Terms_of_Use.pdf'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: Text(
            "Terms of Use",
            style: TextStyle(
              fontSize: 17,
              fontFamily: 'WorkSans',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
            ),
          ),
          backgroundColor: Constants.violet, //bg color for appbar
        ),
        backgroundColor: Colors.white, //bg color for body
        body: _buildUI(),
    );
  }

  Widget _buildUI(){
    return Column(
      children: [
        _pdfView(),
      ],
    );
  }

  Widget _pdfView(){
    return Expanded(child: PdfViewPinch(
      scrollDirection: Axis.vertical,
      controller: pdfControllerPinch,
    ));
  }
}