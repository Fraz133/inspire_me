import 'package:flutter/material.dart';

class GoogleLogoWidget extends StatelessWidget {
  final double size;
  const GoogleLogoWidget({super.key, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: GoogleLogoPainter(),
      ),
    );
  }
}

class GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double r = w / 2;
    final center = Offset(w / 2, h / 2);
    
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.225
      ..strokeCap = StrokeCap.butt;

    // Red arc: top
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r - paint.strokeWidth / 2),
      -2.45,
      2.05,
      false,
      paint,
    );

    // Yellow arc: left
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r - paint.strokeWidth / 2),
      2.2,
      1.63,
      false,
      paint,
    );

    // Green arc: bottom
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r - paint.strokeWidth / 2),
      0.57,
      1.63,
      false,
      paint,
    );

    // Blue arc: right/middle
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r - paint.strokeWidth / 2),
      -0.4,
      0.97,
      false,
      paint,
    );

    // Horizontal bar for 'G'
    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;
    final rect = Rect.fromLTWH(
      w / 2,
      h / 2 - paint.strokeWidth / 2,
      w / 2 - w * 0.05,
      paint.strokeWidth,
    );
    canvas.drawRect(rect, barPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
