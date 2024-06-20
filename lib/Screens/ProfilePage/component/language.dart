import 'package:flutter/material.dart';
import 'package:flutter_avisena/const.dart';
import 'package:flutter_avisena/l10n/localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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

  @override
  void initState() {
    defaultLang();
    super.initState();
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

  changeLanguage(language, global) async {
    await storage.write(key: 'language', value: language);
    await storage.write(key: 'global', value: global);
  }

  defaultLang() async {
    var lang = await storage.read(key: 'language');
    setState(() {
      if(lang == 'en') {
        languages[0]['press'] = true;
      } else {
        languages[1]['press'] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: violet,
        title: Text(
          AppLocalizations.of(context)!.translate('Language')!,
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
        itemCount: languages.length,
        itemBuilder: (BuildContext context, int index) {

          var listLanguage = languages[index];

          return InkWell(
            onTap: () {
              setState(() {
                for(var i = 0; i < languages.length; i++) {
                  languages[i]['press'] = i == index;
                }
                changeLanguage(listLanguage['language'], listLanguage['global']);
              });
            },
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(_width * 0.07),
                child: Row(
                  children: [
                    Text(listLanguage['title']),
                    SizedBox(
                      width: _width * 0.1,
                    ),
                    Icon(
                      Icons.task_alt,
                      color: listLanguage['press'] ? turquoise : Colors.transparent,
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