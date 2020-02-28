part of mainlib;


// This is a custom painter that literally paints a shape on the screen. We call it when we draw the modal above.
class PaintRectangle
    extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Create a paint element
    final paint = Paint();
    // set the paint color to be white (background)
    paint.color = Colors.white;
    // Create a rectangle with size and width same as parent
    var rect = Rect.fromLTWH(0, 0, 4, 5);
    // draw the rectangle
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // set the paint color to be white
    paint.color = Colors.red;
    double circleRadius = 10;
    double rectRad = 5;
    double timelineShapeWidth = 200;
    // Create a rectangle with size and width same as the canvas
    var rect = Rect.fromLTRB((size.height / 2) + (rectRad / 2), timelineShapeWidth,
        (size.height / 2) - (rectRad / 2), 0);
    // var rect = Rect.fromLTRB(0, (size.height / 2) - (rectRad / 2),
    //     timelineShapeWidth, (size.height / 2) + (rectRad / 2));
    // draw the rectangle using the paint
    canvas.drawRect(rect, paint);
    // set the color property of the paint
    paint.color = Colors.red;
    // center of the canvas is (x,y) => (width/2, height/2)
    var center = Offset(timelineShapeWidth / 2, size.height / 2);
    // draw the circle with center having radius 15.0
    canvas.drawCircle(center, circleRadius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
