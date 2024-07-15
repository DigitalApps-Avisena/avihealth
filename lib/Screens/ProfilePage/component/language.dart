import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avisena/const.dart';
import 'package:flutter_avisena/components/localization_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class Language extends StatefulWidget {
  Language({Key? key, required this.name, required this.email, required this.phone}) : super(key: key);
  String name;
  String email;
  String phone;

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {

  final storage = const FlutterSecureStorage();

  dynamic _height;
  dynamic _width;
  dynamic language;
  dynamic global;

  String? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
  }

  void _loadSelectedLanguage() async {
    _selectedLanguage = await storage.read(key: 'language') ?? LocalizationService.langs[0];
    setState(() {});
  }

  List<Map<String, dynamic>> languages = [
    {
      "title" : "English",
      "language" : "en",
      "global" : "US",
      "press" : false
    },
    {
      "title" : "Malay",
      "language" : "ms",
      "global" : "MY",
      "press" : false
    }
  ];

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: violet,
        title: Text(
          'Language'.tr,
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
      ),
      body: ListView.builder(
        itemCount: LocalizationService.langs.length,
        itemBuilder: (BuildContext context, int index) {

          var language = LocalizationService.langs[index];

          return InkWell(
            onTap: () async {
              LocalizationService.instance.changeLocale(LocalizationService.langs[index]);
              await storage.write(key: 'language', value: LocalizationService.langs[index]);
              AwesomeDialog(
                padding: const EdgeInsets.all(20),
                context: context,
                dialogType: DialogType.success,
                animType: AnimType.topSlide,
                showCloseIcon: true,
                title: "Language Changed".tr,
                btnOkColor: violet,
                btnOkText: "Okay",
                btnOkOnPress: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Language(name: widget.name, email: widget.email, phone: widget.phone)),
                  );
                },
              ).show();
            },
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(_width * 0.07),
                child: Row(
                  children: [
                    Text(language),
                    SizedBox(
                      width: _width * 0.1,
                    ),
                    Icon(
                      Icons.task_alt,
                      color: _selectedLanguage == language ? turquoise : Colors.transparent,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}