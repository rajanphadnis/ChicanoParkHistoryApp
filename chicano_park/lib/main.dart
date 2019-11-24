import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:camera/camera.dart';

// List<CameraDescription> cameras;
// Future<void> main() async {
//   cameras = await availableCameras();
//   runApp(MyApp());
// }
void main() => runApp(MyApp());
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              onChanged: (text) {
                found = text;
              },
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: "name of Mural"),
            ),
            RaisedButton(
              child: Text('Recognize'),
              onPressed: () => showTheModalThingWhenTheButtonIsPressed(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAListViewItem(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      title: Column(
        children: <Widget>[
          Text(document["title"]),
          Text(document["desc"]),
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
                stream: Firestore.instance
                    .collection("Murals")
                    .document(found)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Text("Loading data...");
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
                        Text(snapshot.data["title"]),
                        Text(snapshot.data["desc"]),
                        Text("Picture will go here eventually"),
                        Text(
                            "share buttons, carousel of actions will go here with some nice cupertino icons"),
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
