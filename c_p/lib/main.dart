// First, you want to import all of the packages. Material is standard.
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:transparent_image/transparent_image.dart';
import 'dart:convert';
import 'package:camera/camera.dart';

// Next, create a list of cameras so that we know which one is the "back" one
// Start the app asynchronously because we want to make sure that the cameras are turned on and we have access to them before we show a cmera feed to the user
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

// This variable is a string that will contain a descriptor for the mural we found when scanned
var found = "";
String textl = "quite literally nothing";
double confidence = 0.0;
bool differentMural = true;
var jsonData =
    '{ "All_The_Way_To_The_Bay" : "Mural1", "Colossus" : "Mural2", "Los_Grandes" : "grandes", "Cuauhtemoc_Aztec_Warrior" : "aztec_dude" }';
var parsedJson = json.decode(jsonData);
String data = "no error";
final double confidenceThresh = 0.65;
List<CameraDescription> cameras;
// Create the app class and basic Material design structure
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // We can end up changing a bunch of values in here: https://api.flutter.dev/flutter/material/Colors-class.html
        primarySwatch: Colors.blue,
      ),
      // Tell the app that the homepage is TheMainAppHomePage()
      home: TheMainAppHomePage(),
    );
  }
}

class TheMainAppHomePage extends StatefulWidget {
  // We want a stateful widget because of all of theredrawing and repainting we are going to be doing. So, we create it (read: start it)
  _TheMainAppHomePageState createState() => _TheMainAppHomePageState();
}

class _TheMainAppHomePageState extends State<TheMainAppHomePage> {
  // Define a camera controller. This determines which camera we want to use and when
  // FirebaseVision _vision;
  bool dialVisible = true;
  CameraController controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // initialize camera when the app is initialized
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
    // _initializeCamera();
  }

  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }

  // Find icons from here: https://api.flutter.dev/flutter/material/Icons-class.html
  // SpeedDial buildSpeedDial() {
  //   return SpeedDial(
  //     overlayColor: Colors.transparent,
  //     overlayOpacity: 0,
  //     animatedIcon: AnimatedIcons.menu_close,
  //     animatedIconTheme: IconThemeData(size: 22.0),
  //     child: Icon(Icons.add),
  //     onOpen: () {
  //       // print('OPENING DIAL');
  //       setState(() {
  //         differentMural = false;
  //       });
  //     },
  //     onClose: () {
  //       // print('DIAL CLOSED');
  //       // setState(() {

  //       differentMural = true;
  //       // });
  //     },
  //     visible: dialVisible,
  //     curve: Curves.bounceIn,
  //     children: [
  //       SpeedDialChild(
  //         child: Icon(Icons.history, color: Colors.white),
  //         backgroundColor: Colors.deepOrange,
  //         onTap: () {
  //           // print('FIRST CHILD');
  //           // found = "History";
  //           setState(() {
  //             Future.delayed(const Duration(milliseconds: 500), () {
  //               differentMural = false;
  //             });
  //             // differentMural = false;
  //           });
  //           // differentMural = false;
  //           showHistoryBottomSheet();
  //         },
  //         label: 'History',
  //         labelStyle: TextStyle(fontWeight: FontWeight.w500),
  //         labelBackgroundColor: Colors.deepOrangeAccent,
  //       ),
  //       SpeedDialChild(
  //         child: Icon(Icons.explore, color: Colors.white),
  //         backgroundColor: Colors.green,
  //         onTap: () {
  //           setState(() {
  //             Future.delayed(const Duration(milliseconds: 500), () {
  //               differentMural = false;
  //             });
  //             data = "opened tours";
  //           });
  //         },
  //         label: 'Tours',
  //         labelStyle: TextStyle(fontWeight: FontWeight.w500),
  //         labelBackgroundColor: Colors.green,
  //       ),
  //     ],
  //   );
  // }

  // void _initializeCamera() async {
  //   List<FirebaseCameraDescription> cameras = await camerasAvailable();
  //   _vision = FirebaseVision(cameras[0], ResolutionSetting.high);
  //   _vision.initialize().then((_) {
  //     if (!mounted) {
  //       return;
  //     }
  //     setState(() {});
  //     // runDetector();
  //   });
  // }

  // Get rid of the camera controller and access to the camera when the app is closed
  @override
  void dispose() {
    controller?.dispose();
    // _vision.dispose().then((_) {
    //   _vision.visionEdgeImageLabeler.close();
    // });
    super.dispose();
  }

  // OK, now for the meaty stuff. The main widget here (called "build") is the main homepage widget in the "TheMainAppHomePage" class
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // First, make sure that we have initialized the camera and the app (corner case: some devices run slower, so this makes sure that the camera is running before we show the camera to the user)
    if (!controller.value.isInitialized) {
      // If its not initialized, we let the user know with the following helpful message
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // We can add more here, but this is a basic template that I made
              Text(
                  "You must enable camera and recording/audio persmissions in order to use this app")
            ],
          ),
        ),
      );
    }
    // double scale() {
    //   // print(_vision.value.aspectRatio);
    //   // print(deviceRatio);
    //   // print(size.height);
    //   return (_vision.value.aspectRatio / deviceRatio) * 1;
    //   // (size.height / 391.332);
    //   // (size.height / 1);
    // }

    // When the camera is initialized (Stateful widget, so it is constantly re-checking the state), show the main app ui
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
    // return Scaffold(
    //   body: Column(
    //     // Center things with a "Column" widget
    //     children: <Widget>[
    //       Transform.scale(
    //         scale: scale(),
    //         child: new AspectRatio(
    //           aspectRatio: _vision.value.aspectRatio,
    //           child: new FirebaseCameraPreview(_vision),
    //         ),
    //       ),
    //     ],
    //   ),
    //   floatingActionButton: buildSpeedDial(),
    // );
  }

  String dictLookUp(String label) {
    return parsedJson[label];
  }

  // void listenForModelCalls(List<VisionEdgeImageLabel> data) {
  //   // print("Listened: " + data.toString());
  //   print(differentMural);
  //   setState(() {
  //     if (data.toList().length == 0) {
  //       textl = "none";
  //       confidence = 0;
  //       print("none");
  //     } else {
  //       if (differentMural) {
  //         for (VisionEdgeImageLabel label in data) {
  //           textl = label.text;
  //           confidence = label.confidence;
  //           print(textl + confidence.toString());
  //         }
  //         found = dictLookUp(textl);
  //         showTheModalThingWhenTheButtonIsPressed();
  //         differentMural = false;
  //       } else {
  //         print("Found a Mural but not showing modal");
  //       }
  //     }
  //   });
  // }

  // void runDetector() {
  //   print("Got Some Data1");
  //   //This is the actual machine learning algorithm
  //   _vision
  //       .addVisionEdgeImageLabeler(
  //           'ml',
  //           ModelLocation.Local,
  //           VisionEdgeImageLabelerOptions(
  //               confidenceThreshold: confidenceThresh))
  //       .then((onValue) {
  //     onValue.listen(
  //       (onData) => listenForModelCalls(onData),
  //     );
  //   });
  // }
  // void runDetector() {
  //   print("Got Some Data1");
  //   //This is the actual machine learning algorithm
  //   _vision
  //       .addVisionEdgeImageLabeler(
  //           'ml',
  //           ModelLocation.Local,
  //           VisionEdgeImageLabelerOptions(
  //               confidenceThreshold: confidenceThresh))
  //       .then((onValue) {
  //     onValue.listen(
  //       (onData) => listenForModelCalls(onData),
  //     );
  //   });
  // }

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
                                // Share.share("Hello there!");
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
        differentMural = true;
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
        differentMural = true;
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
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => InfoPage("Part 1: The Takeover", 1),
              //   ),
              // );
            },
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
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => InfoPage("Part 2: Murals Appeared", 2),
              //   ),
              // );
            },
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
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => InfoPage("Part 3: Restoration", 3),
              //   ),
              // );
            },
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
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => InfoPage("Part 4: Present Day", 4),
              //   ),
              // );
            },
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

// This is a custom painter that literally paints a shape on the screen. We call it when we draw the modal above.
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
