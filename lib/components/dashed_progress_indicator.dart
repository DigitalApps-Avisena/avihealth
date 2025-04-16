import 'package:flutter/material.dart';
import 'package:flutter_avisena/const.dart';

class DashedProgressIndicator extends StatefulWidget {
  final double progress;

  DashedProgressIndicator({required this.progress});

  @override
  _DashedProgressIndicatorState createState() => _DashedProgressIndicatorState();
}

class _DashedProgressIndicatorState extends State<DashedProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();

    // Animation for the moving violet effect
    _waveController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Speed of violet movement inside the dash
    )..repeat(); // Keeps repeating
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        return CustomPaint(
          size: Size(double.infinity, 10),
          painter: _DashedProgressPainter(widget.progress, _waveController.value),
        );
      },
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }
}

class _DashedProgressPainter extends CustomPainter {
  final double progress;
  final double waveProgress;

  _DashedProgressPainter(this.progress, this.waveProgress);

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = Colors.grey[300]! // Grey background dashes
      ..strokeWidth = size.height
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Paint progressPaint = Paint()
      ..color = Constants.violet // Completed progress dashes
      ..strokeWidth = size.height
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Paint movingPaint = Paint()
      ..color = Constants.violet.withOpacity(0.5) // Moving violet effect
      ..strokeWidth = size.height
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double dashWidth = 30, dashSpace = 13;
    double totalWidth = size.width;
    double progressWidth = totalWidth * progress;
    double startX = 0;

    List<double> dashPositions = [];

    // Draw Grey Background Dashes
    while (startX < totalWidth) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        backgroundPaint,
      );
      dashPositions.add(startX);
      startX += dashWidth + dashSpace;
    }

    startX = 0; // Reset for progress

    // Draw Completed Violet Dashes
    for (double pos in dashPositions) {
      if (pos + dashWidth <= progressWidth) {
        canvas.drawLine(
          Offset(pos, size.height / 2),
          Offset(pos + dashWidth, size.height / 2),
          progressPaint,
        );
      }
    }

    // Stop the moving effect when progress reaches 100%
    if (progress < 1.0) {
      // Find the current dash that is incomplete
      for (double pos in dashPositions) {
        if (pos + dashWidth > progressWidth) {
          double movingStart = pos;
          double movingEnd = pos + (waveProgress * dashWidth); // Moves inside current dash

          // Only draw moving violet effect inside the current grey dash
          if (movingEnd <= pos + dashWidth) {
            canvas.drawLine(
              Offset(movingStart, size.height / 2),
              Offset(movingEnd, size.height / 2),
              movingPaint,
            );
          }
          break; // Stop after finding the first incomplete dash
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
