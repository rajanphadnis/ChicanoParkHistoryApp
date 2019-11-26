import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'package:transparent_image/transparent_image.dart';
import 'package:share/share.dart';

List<CameraDescription> cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

var found = "";

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TheMainAppHomePage(),
    );
  }
}

class TheMainAppHomePage extends StatefulWidget {
  _TheMainAppHomePageState createState() => _TheMainAppHomePageState();
}

class _TheMainAppHomePageState extends State<TheMainAppHomePage> {
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
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                  "You must enable camera and recording/audio persmissions in order to use this app")
            ],
          ),
        ),
      );
    }
    return Column(
      children: <Widget>[
        AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(controller),
        ),
        Container(
          child: Column(
            children: <Widget>[
              // Material(
              //   child: TextField(
              //     onChanged: (text) {
              //       found = text;
              //     },
              //     decoration: InputDecoration(
              //         border: InputBorder.none, hintText: "name of Mural"),
              //   ),
              // ),
              RaisedButton(
                child: Text('Mural1'),
                onPressed: () => {
                  found = "Mural1",
                  showTheModalThingWhenTheButtonIsPressed(),
                },
              ),
              RaisedButton(
                child: Text('img error'),
                onPressed: () => {
                  found = "Mural2",
                  showTheModalThingWhenTheButtonIsPressed(),
                },
              ),
              RaisedButton(
                child: Text('DB Error'),
                onPressed: () => {
                  found = "Mural3",
                  showTheModalThingWhenTheButtonIsPressed(),
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  String testString(DocumentSnapshot doc, String val) {
    if (doc == null) {
      return "error! DB not found!";
    }
    return doc[val];
  }

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

  Widget buildAListViewItem(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      title: Column(
        children: <Widget>[
          Text(testString(document, "title")),
          Text(testString(document, "desc")),
        ],
      ),
    );
  }

  void showTheModalThingWhenTheButtonIsPressed() {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (context) => Wrap(
        children: <Widget>[
          Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: StreamBuilder(
                stream: 
                // testStream(),
                Firestore.instance
                      .collection("Murals")
                      .document(found)
                      .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Text("Loading data...");
                  }
                  if (snapshot.hasError) {
                    return const Text("error!");
                  }
                  if (snapshot == null || snapshot.data == null) {
                    return const Text(
                        "Can't find mural in our database! Sorry!");
                  }
                  return Center(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: CustomPaint(
                            painter:
                                PaintSomeRandomShapeThatIsProbablyARectangleWithSomeRadius(),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: new Border.all(color: Colors.white),
                                  borderRadius: new BorderRadius.all(
                                      Radius.circular(2.5)),
                                  color: Colors.grey),
                              height: 5,
                              width: 40,
                            ),
                          ),
                        ),
                        Text(
                          testString(snapshot.data, "title"),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: testImage(snapshot.data),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(testString(snapshot.data, "desc")),
                            ),
                          ),
                        ),
                        RaisedButton.icon(
                          icon: Icon(Icons.share),
                          label: Text("Share"),
                          onPressed: () {
                            Share.share("Hello there!");
                          },
                        ),
                      ],
                    ),
                  );
                },
              )),
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
