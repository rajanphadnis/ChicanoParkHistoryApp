part of mainlib;

class PaintRectangle
    extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.white;
    var rect = Rect.fromLTWH(0, 0, 4, 5);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.red;
    double circleRadius = 10;
    double rectRad = 5;
    double timelineShapeWidth = 200;
    var rect = Rect.fromLTRB((size.height / 2) + (rectRad / 2), timelineShapeWidth,
        (size.height / 2) - (rectRad / 2), 0);
    canvas.drawRect(rect, paint);
    paint.color = Colors.red;
    var center = Offset(timelineShapeWidth / 2, size.height / 2);
    canvas.drawCircle(center, circleRadius, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
