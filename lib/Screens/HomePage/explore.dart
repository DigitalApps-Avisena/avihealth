import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import '../../../const.dart';
import '../../../size_config.dart';

class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> categories = [
      {
        "icon": "assets/icons/worker.svg",
        "text": "Worker \n List",
        // "press": WorkerList()
      },
      {
        "icon": "assets/icons/medical_file.svg",
        "text": "Medical \n Result",
        // "press": MedicalResult()
      },
      {
        "icon": "assets/icons/doctor.svg",
        "text": "Booking \n Doctor",
        // "press": MyBook()
      },
      {
        "icon": "assets/icons/bank.svg",
        "text": "Transaction \n List",
        // "press": TransactionList()
      },
      {
        "icon": "assets/icons/appeal_list.svg",
        "text": "Appeal \n Result",
        // "press": AppealResult()
      },
      {
        "icon": "assets/icons/headset.svg",
        "text": "Contact \n Us",
        // "press": ContactUsScreen()
      },

      // {"icon": "assets/icons/Discover.svg", "text": "More"},
    ];
    return Container(
      child: Padding(
        padding: EdgeInsets.all(getProportionateScreenHeight(4)),
        child: GridView.builder(
          itemCount: categories.length,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, childAspectRatio: 1.2), //jarak cards
          itemBuilder: (context, index) {
            return CategoryCard(
              icon: categories[index]["icon"],
              text: categories[index]["text"],
              press: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => categories[index]["press"]));
              },
            );
          },
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.icon,
    required this.text,
    required this.press,
  }) : super(key: key);

  final String icon, text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.all(
              getProportionateScreenHeight(10), //icon size
            ),
            height: getProportionateScreenHeight(50),
            width: getProportionateScreenWidth(70),
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                  offset: const Offset(5, 10),
                  color: violet.withOpacity(0.23),
                  blurRadius: 5,
                ),
              ],
              color: Color(0xFFf8f8ff),
              borderRadius: BorderRadius.circular(25),
            ),
            child: SvgPicture.asset(icon),
          ),
          SizedBox(height: 5), //text size
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Ubuntu',
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey),
          )
        ],
      ),
    );
  }
}
