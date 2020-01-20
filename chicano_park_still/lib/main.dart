import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';
// part 'slide.dart';

List<CameraDescription> cameras;
var found = "";
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chicano Park',
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],

        // Define the default font family.
        fontFamily: 'Georgia',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      home: CameraApp(),
    );
  }
}

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  CameraController controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      key: _scaffoldKey,
      body:
          // Expanded(
          //   child:
          Stack(
        children: <Widget>[
          ClipRect(
            child: Container(
              child: Transform.scale(
                // scale: (controller.value.aspectRatio / (size.width / size.height)) * (size.height / 391.332),
                scale: controller.value.aspectRatio / size.aspectRatio,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: CameraPreview(controller),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(15.0),
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Icon(Icons.list),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 28.0,
                  child: IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                      // size: 28.0,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      // if (!_isRecordingMode) {
                      //   _captureImage();
                      // } else {
                      //   if (_isRecording) {
                      //     stopVideoRecording();
                      //   } else {
                      //     startVideoRecording();
                      //   }
                      // }
                      showTheModalThingWhenTheButtonIsPressed();
                    },
                  ),
                ),
                Icon(Icons.explore),
              ],
            ),
          ),
        ],
      ),
      // )
    );
  }
  // Make sure that all of the strings return a string from the database, and show an error if the entry doesn't exist in the database
  String testString(DocumentSnapshot doc, String val) {
    if (doc == null) {
      return "error! DB not found!";
    }
    return doc[val];
  }

  // Same thing as the string version, but instead with a loading circle and images
  Widget getImage(DocumentSnapshot docs, String url) {
    if (docs[url] == null) {
      return Stack(
        children: <Widget>[
          Center(
            child: Text("Error: Picture not found"),
          ),
        ],
      );
    }
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(25),
          child: Center(child: CircularProgressIndicator()),
        ),
        Center(
          child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: docs[url],
          ),
        ),
      ],
    );
  }

  // This function could have been embedded in the build() widget, but its easier to see when its separated out here
  void showTheModalThingWhenTheButtonIsPressed() {
    // Obviously show the bottom sheet
    showModalBottomSheet(
      // we want it be dismissable when you swipe down
      isScrollControlled: true,
      // Add the corner radii
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      // Background color of the bottom sheet
      backgroundColor: Colors.white,
      // Choose which "navigator" to put the modal in. We just choose the general "context", which is the main, root navigator
      context: context,
      // now we supply the modal with the widget inside of the modal
      builder: (context) => Wrap(
        // Wrap the text and stuff so that nothing gets cut off
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: StreamBuilder(
              // now add firebase integration. "subscribe" to the data from the firestore database
              stream: Firestore.instance
                  .collection("Murals")
                  // get the document that has the title of the mural that was just scanned: "found"
                  .document(found)
                  .snapshots(),
              builder: (context, snapshot) {
                // Do some basic error processing
                if (!snapshot.hasData) {
                  return const Text("Loading data...");
                }
                if (snapshot.hasError) {
                  return const Text("error!");
                }
                if (snapshot == null || snapshot.data == null) {
                  return const Text("Can't find mural in our database! Sorry!");
                }
                // If there is no error, continue building the widgets
                return Center(
                  child: Column(
                    children: <Widget>[
                      // This is the "pill" shape at the top of the modal. See the class at the bottom of the file.
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: CustomPaint(
                          painter:
                              PaintSomeRandomShapeThatIsProbablyARectangleWithSomeRadius(),
                          child: Container(
                            decoration: BoxDecoration(
                                border: new Border.all(color: Colors.white),
                                borderRadius:
                                    new BorderRadius.all(Radius.circular(2.5)),
                                color: Colors.grey),
                            height: 5,
                            width: 40,
                          ),
                        ),
                      ),
                      // This is the title for the modal. get the data from the database
                      Text(
                        testString(snapshot.data, "title"),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                      // Add the image
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: getImage(snapshot.data, "picUrl"),
                      ),
                      Text(
                        "By: Artist Name",
                        style: TextStyle(fontSize: 20),
                      ),
                      // add scrollable description that fills up the rest of the available space in the modal
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(testString(snapshot.data, "desc")),
                          ),
                        ),
                      ),
                      // Just your average share button. and a tour button that collapses the modal bottom sheet
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: RaisedButton.icon(
                              icon: Icon(Icons.share),
                              label: Text("Share"),
                              onPressed: () {
                                // The message that will be shared. This can be a link, some text or contact or anything really
                                Share.share("Hello there!");
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: RaisedButton.icon(
                              icon: Icon(Icons.explore),
                              label: Text("Tour Guide"),
                              onPressed: () {
                                // Remember navigator? We just "pop" it to get rid of it.
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ).whenComplete(() {
      Future.delayed(const Duration(milliseconds: 500), () {
        // differentMural = true;
      });
    });
  }

  void showHistoryBottomSheet() {
    // Obviously show the bottom sheet
    showModalBottomSheet(
      // we want it be dismissable when you swipe down
      isScrollControlled: true,
      // Add the corner radii
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      // Background color of the bottom sheet
      backgroundColor: Colors.white,
      // Choose which "navigator" to put the modal in. We just choose the general "context", which is the main, root navigator
      context: context,
      // now we supply the modal with the widget inside of the modal
      builder: (context) => Wrap(
        // Wrap the text and stuff so that nothing gets cut off
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: StreamBuilder(
              // now add firebase integration. "subscribe" to the data from the firestore database
              stream: Firestore.instance
                  .collection("History")
                  // get the document that has the title of the mural that was just scanned: "found"
                  .document("index")
                  .snapshots(),
              builder: (context, snapshot) {
                // Do some basic error processing
                if (!snapshot.hasData) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Text("Getting Data..."),
                  );
                }
                if (snapshot == null || snapshot.data == null) {
                  return const Text("Something went seriously wrong! Sorry!");
                }
                if (snapshot.hasError) {
                  return const Text("error!");
                }
                // If there is no error, continue building the widgets
                return Center(
                  child: Column(
                    children: <Widget>[
                      // This is the "pill" shape at the top of the modal. See the class at the bottom of the file.
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: CustomPaint(
                          painter:
                              PaintSomeRandomShapeThatIsProbablyARectangleWithSomeRadius(),
                          child: Container(
                            decoration: BoxDecoration(
                                border: new Border.all(color: Colors.white),
                                borderRadius:
                                    new BorderRadius.all(Radius.circular(2.5)),
                                color: Colors.grey),
                            height: 5,
                            width: 40,
                          ),
                        ),
                      ),
                      // This is the title for the modal. get the data from the database
                      Text(
                        "Chicano Park: History",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                      // SingleChildScrollView(
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(15),
                      //     child: Text(
                      //       testString(snapshot.data, "basicDescription"),
                      //       textAlign: TextAlign.center,
                      //     ),
                      //   ),
                      // ),
                      Center(
                        child: Text(
                          "Timeline:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      Center(
                        child: Text(
                          "Tap a date to learn more",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                      ),
                      timeline(context),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ).whenComplete(() {
      Future.delayed(const Duration(milliseconds: 500), () {
        // differentMural = true;
      });
    });
  }
  Widget gridThing() {
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(
        4,
        (iter) {
          return Center(
            child: Text(
              'Item $iter',
              style: Theme.of(context).textTheme.headline,
            ),
          );
        },
      ),
    );
  }

  Widget timeline(BuildContext context) {
    return Container(
      height: 200,
      child: ListView(
        padding: const EdgeInsets.all(8),
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          InkWell(
            // onTap: () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => InfoPage("Part 1: The Takeover", 1),
            //     ),
            //   );
            // },
            child: Container(
              width: 200,
              child: Column(
                children: <Widget>[
                  Card(
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Text("1800s - 1972:"),
                            Text("The Takeover")
                          ],
                        )),
                    elevation: 3,
                  ),
                  CustomPaint(
                    painter: ShapesPainter(),
                    child: Container(
                      width: 200,
                      height: 80,
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            // onTap: () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => InfoPage("Part 2: Murals Appeared", 2),
            //     ),
            //   );
            // },
            child: Container(
              width: 200,
              child: Column(
                children: <Widget>[
                  Card(
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Text("1960 - 1983:"),
                            Text("Murals Appeared")
                          ],
                        )),
                    elevation: 3,
                  ),
                  CustomPaint(
                    painter: ShapesPainter(),
                    child: Container(
                      width: 200,
                      height: 80,
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            // onTap: () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => InfoPage("Part 3: Restoration", 3),
            //     ),
            //   );
            // },
            child: Container(
              width: 200,
              child: Column(
                children: <Widget>[
                  Card(
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Text("1986 - Present:"),
                            Text("Restoration")
                          ],
                        )),
                    elevation: 3,
                  ),
                  CustomPaint(
                    painter: ShapesPainter(),
                    child: Container(
                      width: 200,
                      height: 80,
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            // onTap: () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => InfoPage("Part 4: Present Day", 4),
            //     ),
            //   );
            // },
            child: Container(
              width: 200,
              child: Column(
                children: <Widget>[
                  Card(
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Text("Present Day:"),
                            Text("Current State")
                          ],
                        )),
                    elevation: 3,
                  ),
                  CustomPaint(
                    painter: ShapesPainter(),
                    child: Container(
                      width: 200,
                      height: 80,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
    paint.color = Colors.white;
    // Create a rectangle with size and width same as parent
    var rect = Rect.fromLTWH(0, 0, size.width, size.height);
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
    // var rect = Rect.fromLTWH(0, 0, 10, size.height / 3);
    var rect = Rect.fromLTRB(0, (size.height / 2) - (rectRad / 2),
        timelineShapeWidth, (size.height / 2) + (rectRad / 2));
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