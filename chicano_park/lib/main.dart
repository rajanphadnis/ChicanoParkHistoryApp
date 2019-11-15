// Import required packages
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras;
// set app starting page and then run app
Future<void> main() async {
  cameras = await availableCameras();
  runApp(MyApp());
}
// void main() => runApp(MyApp());

// Create the main page element
class MyApp extends StatelessWidget {
  // build the main page element (render)
  @override
  Widget build(BuildContext context) {
    // set to use material theming
    return MaterialApp(
      // Set title and theme data
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Baskerville',
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      // set home page content to be the MainHomePage element defined in another class. You could get rid of the class and just add it here, but its easier to organize if you split into classes
      home: MainHomePage(title: 'Chicano Park History App Thingy'),
    );
  }
}

// Create a "redirect" element
class MainHomePage extends StatefulWidget {
  MainHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CameraController controller;
  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _showBottomSheetCallback() {
    _scaffoldKey.currentState.showBottomSheet<void>((BuildContext context) {
      return Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
              // border: Border(top: BorderSide(color: Colors.black)),
              borderRadius: new BorderRadius.only(
                topLeft: new Radius.circular(10),
                topRight: new Radius.circular(10),
              ),
              color: Colors.grey),
          child: Column(
            children: <Widget>[
              new Padding(
                  padding: const EdgeInsets.all(10),
                  child: new CustomPaint(
                    painter:
                        PaintSomeRandomShapeThatIsProbablyARectangleWithSomeRadius(),
                    child: Container(
                      decoration: BoxDecoration(
                          border: new Border.all(color: Colors.grey),
                          borderRadius:
                              new BorderRadius.all(Radius.circular(2.5)),
                          color: Colors.white),
                      height: 5,
                      width: 40,
                    ),
                  )),
              new Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  'Drag to dismiss',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                ),
              ),
            ],
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        // appBar: AppBar(
        //   title: const Text('Persistent bottom sheet')
        // ),
        body: 
        // Column(
        //   children: <Widget>[
            Center(
              child: RaisedButton(
                onPressed: _showBottomSheetCallback,
                child: const Text('Show Persistent Bottom Sheet'),
              ),
            ),
            // if (!controller.value.isInitialized) {
            //   new Container()
            // }
            // else {
            //   AspectRatio(
            //     aspectRatio: controller.value.aspectRatio,
            //     child: CameraPreview(controller),),}
          // ],
        // ),
        // Get rid of fab onpress: https://medium.com/flutter-community/flutter-beginners-guide-to-using-the-bottom-sheet-b8025573c433
        floatingActionButton: FloatingActionButton(
      onPressed: _showBottomSheetCallback,
      child: Icon(Icons.navigation),
      backgroundColor: Colors.green,
    ),
      ),
    );
  }
}

class PaintSomeRandomShapeThatIsProbablyARectangleWithSomeRadius
    extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Create a paint element
    final paint = Paint();
    // set the paint color to be white (background)
    paint.color = Colors.grey;
    // Create a rectangle with size and width same as parent
    var rect = Rect.fromLTWH(0, 0, size.width, size.height);
    // draw the rectangle
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
