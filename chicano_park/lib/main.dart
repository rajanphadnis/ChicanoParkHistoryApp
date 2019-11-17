// Import required packages
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<CameraDescription> cameras;
// set app starting page and then run app

// void main() => runApp(MyApp());
void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

// String title;
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
        primarySwatch: Colors.orange,
        brightness: Brightness.dark,
      ),
      // set home page content to be the MainHomePage element defined in another class. You could get rid of the class and just add it here, but its easier to organize if you split into classes
      home: MainHomePage(title: 'Chicano Park History App Thingy'),
    );
  }
}

Future<void> main() async {
  // Fetch the available cameras before initializing the app.
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
  // Run the actual app
  runApp(MyApp());
}

// Create a "redirect" element
class MainHomePage extends StatefulWidget {
  MainHomePage({Key key, this.title}) : super(key: key);
  // String title = this.title;
  final String title;
  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class FabFunctionToCallJustToCleanThingsUpAndMakeItEasierToSeeStuff
    extends StatefulWidget {
  _FabFunctionToCallJustToCleanThingsUpAndMakeItEasierToSeeStuff
      createState() =>
          _FabFunctionToCallJustToCleanThingsUpAndMakeItEasierToSeeStuff();
}

class _FabFunctionToCallJustToCleanThingsUpAndMakeItEasierToSeeStuff
    extends State<
        FabFunctionToCallJustToCleanThingsUpAndMakeItEasierToSeeStuff> {
  bool showFab = true;
  @override
  Widget build(BuildContext context) {
    return showFab
        ? FloatingActionButton(
            onPressed: () {
              var bottomSheetController = showBottomSheet(
                  context: context,
                  builder: (context) => Container(
                        color: Colors.transparent,
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.9,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: new BorderRadius.only(
                                topLeft: new Radius.circular(10),
                                topRight: new Radius.circular(10),
                              ),
                              color: Colors.grey),
                          child: Column(
                            // TODO: throws "hassize error here for some reason"
                            children: <Widget>[
                              new Padding(
                                padding: const EdgeInsets.all(10),
                                child: new CustomPaint(
                                  painter:
                                      PaintSomeRandomShapeThatIsProbablyARectangleWithSomeRadius(),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border:
                                            new Border.all(color: Colors.grey),
                                        borderRadius: new BorderRadius.all(
                                            Radius.circular(2.5)),
                                        color: Colors.white),
                                    height: 5,
                                    width: 40,
                                  ),
                                ),
                              ),
                              new Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: Firestore.instance
                                        .collection('text')
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasError)
                                        return new Text(
                                            'Error: ${snapshot.error}');
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.waiting:
                                          return new Text('Loading...');
                                        default:
                                        // TODO: throws "hassize error here for some reason"
                                          return Column(
                                            children: <Widget>[
                                              ListView(
                                                children: snapshot
                                                    .data.documents
                                                    .map((DocumentSnapshot
                                                        document) {
                                                  return new ListTile(
                                                    title: new Text(
                                                        document['title']),
                                                    subtitle: new Text(
                                                        document['content']),
                                                  );
                                                }).toList(),
                                              )
                                            ],
                                          );
                                      }
                                    },
                                  )
                                  // Text(
                                  //   'Drag to dismiss',
                                  //   textAlign: TextAlign.center,
                                  //   style: TextStyle(
                                  //     fontSize: 24.0,
                                  //     fontFamily: "Baskerville",
                                  //   ),
                                  // ),
                                  ),
                            ],
                          ),
                        ),
                      ));
              showFAB(false);
              bottomSheetController.closed.then((value) {
                showFAB(true);
              });
            },
            // child: Icon(Icons.apps),
            // child: Icon(Icons.art_track),
            // child: Icon(Icons.assistant),
            // child: Icon(Icons.burst_mode),
            // child: Icon(Icons.camera_enhance),
            // child: Icon(Icons.dashboard),
            // child: Icon(Icons.dns),
            // child: Icon(Icons.filter_list),
            child: Icon(Icons.explore),
            // child: Icon(Icons.search),
            backgroundColor: Colors.orangeAccent,
          )
        : Container();
  }

  void showFAB(bool value) {
    setState(() {
      showFab = value;
    });
  }
}

class _MainHomePageState extends State<MainHomePage> {
  // setup basic variables
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CameraController controller;
  bool showFab = true;
  // set app behavior when app initializes from cold start
  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.ultraHigh);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  // get rid of camera controller when app is no longer in focus
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          title: Center(
            child: Text(widget.title),
          ),
        ),
        body: new Container(
          child: _cameraPreviewWidget(),
        ),
        // _cameraPreviewWidget(),
        // Get rid of fab onpress: https://medium.com/flutter-community/flutter-beginners-guide-to-using-the-bottom-sheet-b8025573c433
        floatingActionButton:
            FabFunctionToCallJustToCleanThingsUpAndMakeItEasierToSeeStuff(),
      ),
    );
    // )
  }

  void showFAB(bool value) {
    setState(() {
      showFab = value;
    });
  }

  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'No Camera found',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      );
    }
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
