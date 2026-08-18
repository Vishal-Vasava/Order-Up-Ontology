import 'package:flutter/material.dart';
import 'package:orderly_ecom/src/theme/colors.dart';

class DashedLinePainter extends CustomPainter {
  DashedLinePainter({
    this.dashWidth = 9,
    this.dashSpace = 5,
    this.startX = 0,
    this.lineColor = AppColor.greyDarkColor,
  });

  final double dashWidth;
  final double dashSpace;
  final double startX;
  final Color lineColor;
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = this.dashWidth,
        dashSpace = this.dashSpace,
        startX = this.startX;
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1;
    while (startX < size.width - 10) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
