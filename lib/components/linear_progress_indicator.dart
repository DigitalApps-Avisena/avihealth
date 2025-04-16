import 'package:flutter/material.dart';
import 'dart:async';

class OrderTrackingScreen extends StatefulWidget {
  @override
  _OrderTrackingScreenState createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  int estimatedTime = 20;
  List<String> orderStages = ["Order Placed", "Preparing", "On the Way", "Delivered"];
  int currentStageIndex = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(minutes: 20),
    )..forward();

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    Timer.periodic(Duration(minutes: 5), (timer) {
      if (currentStageIndex < orderStages.length - 1) {
        setState(() {
          currentStageIndex++;
          estimatedTime -= 5;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Tracking"),
        backgroundColor: Colors.pink,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Estimated Arrival Time",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              estimatedTime > 0 ? "Arriving in $estimatedTime min" : "Delivered!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.pink),
            ),
            SizedBox(height: 30),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value: _progressAnimation.value,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
                    minHeight: 12,
                  );
                },
              ),
            ),
            SizedBox(height: 30),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: List.generate(orderStages.length * 2 - 1, (index) {
                    if (index % 2 == 0) {
                      return Icon(
                        Icons.check_circle,
                        color: index ~/ 2 <= currentStageIndex ? Colors.pink : Colors.grey,
                      );
                    } else {
                      return Container(
                        width: 2,
                        height: 30,
                        color: Colors.grey,
                        child: Column(
                          children: List.generate(10, (i) {
                            return Container(
                              width: 2,
                              height: 10,
                              margin: EdgeInsets.symmetric(vertical: 2),
                              color: index ~/ 2 < currentStageIndex ? Colors.pink : Colors.grey,
                            );
                          }),
                        ),
                      );
                    }
                  }),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: orderStages.map((stage) {
                    int index = orderStages.indexOf(stage);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        stage,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: index <= currentStageIndex ? Colors.pink : Colors.grey,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 20),
            Image.asset(
              "assets/images/avisena_healthcare_logo.png",
              height: 150,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}