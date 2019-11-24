import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

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
            RaisedButton(
              child: Text('Show'),
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
                    .document("Mural1")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Text("Loading data...");
                  }
                  return Center(
                    child: Column(
                      children: <Widget>[
                        Text(snapshot.data["title"]),
                        Text(snapshot.data["desc"]),
                        Text("Picture will go here eventually"),
                        Text("share buttons, carousel of actions will go here with some nice cupertino icons"),
                      ],
                    ),
                  );
                  //
                },
              )
              // Text("gonna fill this out with firebase stuff for ish to fill out later"),
              )
        ],
      ),
    );
  }
}
