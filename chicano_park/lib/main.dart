// First, you want to import all of the packages. Material is standard.
import 'package:firebase_livestream_ml_vision/firebase_livestream_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:camera/camera.dart';
import 'dart:async';
import 'package:transparent_image/transparent_image.dart';
import 'package:share/share.dart';
import 'dart:convert';

// Next, create a list of cameras so that we know which one is the "back" one
// Start the app asynchronously because we want to make sure that the cameras are turned on and we have access to them before we show a cmera feed to the user
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

// This variable is a string that will contain a descriptor for the mural we found when scanned
var found = "";
String textl = "quite literally nothing";
double confidence = 0.0;
bool differentMural = true;
var jsonData =
    '{ "roses" : "Mural1", "daisy" : "Mural2", "tulips" : "Mural3"  }';
var parsedJson = json.decode(jsonData);

// Create the app class and basic Material design structure
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // We can end up changing a bunch of values in here
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
  FirebaseVision _vision;
  dynamic _scanResults;
  // initialize camera when the app is initialized
  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    List<FirebaseCameraDescription> cameras = await camerasAvailable();
    _vision = FirebaseVision(cameras[0], ResolutionSetting.high);
    _vision.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
      runDetector();
    });
  }

  // Get rid of the camera controller and access to the camera when the app is closed
  @override
  void dispose() {
    _vision.dispose().then((_) {
      _vision.visionEdgeImageLabeler.close();
    });
    super.dispose();
  }

  // OK, now for the meaty stuff. The main widget here (called "build") is the main homepage widget in the "TheMainAppHomePage" class
  @override
  Widget build(BuildContext context) {
    // First, make sure that we have initialized the camera and the app (corner case: some devices run slower, so this makes sure that the camera is running before we show the camera to the user)
    if (_vision == null) {
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
    // When the camera is initialized (Stateful widget, so it is constantly re-checking the state), show the main app ui
    return Column(
      // Center things with a "Column" widget
      children: <Widget>[
        // Stack(
        //       fit: StackFit.expand,
        //       children: <Widget>[
        //         FirebaseCameraPreview(_vision),
        //       ],
        //     ),
        // Display the camera viewfinder
        AspectRatio(
          // Make sure it has the right aspect ratio
          aspectRatio: _vision.value.aspectRatio,
          child: FirebaseCameraPreview(_vision),
        ),
        Container(
          color: Colors.white,
          child: Column(
            // Center the rest of the widgets in a column
            children: <Widget>[
              Text(
                textl + ":" + (confidence * 100).toStringAsPrecision(3) + "%",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String dictLookUp(String label) {
    return parsedJson[label];
  }

  void listenForModelCalls(List<VisionEdgeImageLabel> data) {
    print("Listened: " + data.toString());
    setState(() {
      if (data.toList().length == 0) {
        textl = "none";
        confidence = 0;
        print("none");
      } else {
        for (VisionEdgeImageLabel label in data) {
          textl = label.text;
          confidence = label.confidence;
          print(textl + confidence.toString());
        }
        if (confidence >= 0.7) {
          if (differentMural) {
            found = dictLookUp(textl);
            showTheModalThingWhenTheButtonIsPressed();
            differentMural = false;
          } else {
            print("Found a Mural but not showing modal");
          }
        } else {
          print("confidence level not met");
        }
      }
    });
  }

  void runDetector() {
    print("Got Some Data1");
    //This is the actual machine learning algorithm
    _vision
        .addVisionEdgeImageLabeler('ml', ModelLocation.Local,
            VisionEdgeImageLabelerOptions(confidenceThreshold: 0.65))
        .then((onValue) {
      onValue.listen(
        (onData) => listenForModelCalls(onData),
      );
    });
  }

  // Make sure that all of the strings return a string from the database, and show an error if the entry doesn't exist in the database
  String testString(DocumentSnapshot doc, String val) {
    if (doc == null) {
      return "error! DB not found!";
    }
    return doc[val];
  }

  // Same thing as the string version, but instead with a loading circle and images
  Widget testImage(DocumentSnapshot docs) {
    if (docs["picURL"] == null) {
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
            image: docs["picURL"],
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
                        child: testImage(snapshot.data),
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
        differentMural = true;
      });
    });
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
