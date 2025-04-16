import 'package:flutter/material.dart';

class DottedInitialPath extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 1.5;
    double dashSpace = 2;
    double startY = 5;
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1;

    while (startY < size.height - 5) {
      canvas.drawCircle(Offset(0, startY), 2, paint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class DottedMiddlePath extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 3;
    double dashSpace = 4;
    double startY = 10;
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1;

    while (startY < size.height - 5) {
      canvas.drawCircle(Offset(size.width / 5, startY), 2, paint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class SideCutsDesign extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var h = size.height;
    var w = size.width;

    canvas.drawArc(
        Rect.fromCircle(center: Offset(0, h / 2), radius: 8), //top-center
        0,
        10,
        false,
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.white);
    canvas.drawArc(
        Rect.fromCircle(center: Offset(w, h / 2), radius: 12), //arc at the most right
        0,
        10,
        false,
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.white);
    canvas.drawArc(
        Rect.fromCircle(center: Offset(w / 5, h), radius: 4), //2
        0,
        10,
        false,
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.white);
    canvas.drawArc(
        Rect.fromCircle(center: Offset(w / 5, 0), radius: 4), //4
        0,
        10,
        false,
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.white);
    canvas.drawArc(
        Rect.fromCircle(center: Offset(0, h), radius: 5), //1
        0,
        10,
        false,
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.white);
    canvas.drawArc(
        Rect.fromCircle(center: Offset(0, 0), radius: 5),//3
        0,
        10,
        false,
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}