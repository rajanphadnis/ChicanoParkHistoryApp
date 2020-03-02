part of mainlib;

String dictLookUp(String label) {
  return parsedJson[label];
}

// Make sure that all of the strings return a string from the database, and show an error if the entry doesn't exist in the database
String testString(DocumentSnapshot doc, String val) {
  try {
    if (doc == null) {
      return "error! DB not found!";
    }
    if (doc[val] == null) {
      return "'" + val + "' doesn't exist in DB";
    }
    return doc[val];
  } catch (e) {
    return "Error: something went wrong";
  }
}

double testDouble(DocumentSnapshot doc, String val) {
  try {
    if (doc == null) {
      return 0.0;
    }
    if (doc[val] == null) {
      return 0.0;
    }
    return doc[val].toDouble();
  } catch (e) {
    return 0.0;
  }
}

String testUndString(DocumentSnapshot doc, String val) {
  try {
    if (doc is! DocumentSnapshot || doc == null || doc.data == null) {
      return "undefined";
    } else if (doc[val] == null) {
      return "undefined";
    } else {
      return doc[val];
    }
  } catch (e) {
    return "Error: something went wrong";
  }
}

// Same thing as the string version, but instead with a loading circle and images
Widget getImage(DocumentSnapshot docs, String url, BuildContext context) {
  try {
    if (docs == null) {
      return Stack(
        children: <Widget>[
          Center(
            child: Text("Error: Snapshot is null"),
          ),
        ],
      );
    } else if (docs[url] == null) {
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
        Container(
          padding: const EdgeInsets.all(25),
          child: Center(child: CircularProgressIndicator()),
        ),
        Container(
          alignment: Alignment.center,
          child: ClipRRect(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: docs[url],
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ],
    );
  } catch (e) {
    return Stack(
      children: <Widget>[
        Center(
          child: Text("Error: Something went wrong"),
        ),
      ],
    );
  }
}

// This function could have been embedded in the build() widget, but its easier to see when its separated out here
DocumentSnapshot getMuralData(String nameMatch) {
  DocumentSnapshot doc;
  Firestore.instance
      .collection('Murals')
      .document(nameMatch)
      .get()
      .then((DocumentSnapshot ds) {
    doc = ds;

    // use ds as a snapshot
  });
  debugPrint(doc.toString());
  return doc;
}

Widget muralGrid(BuildContext context) {
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

void launchURL(String urll) async {
  debugPrint(urll);
  if (await canLaunch(urll)) {
    debugPrint(urll);
    await launch(urll);
  } else {
    debugPrint(urll);
    throw 'Could not launch $urll';
  }
}

Widget inte(String data) {
  if (data == "undefined") {
    return Container();
  } else {
    return InkWell(
      onTap: () {
        launchURL(data);
      },
      child:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Text("Watch Interview"),
        IconButton(
          icon: Icon(Icons.ondemand_video, color: Colors.black),
          highlightColor: Colors.grey,
          tooltip: "",
          onPressed: () {
            launchURL(data);
          },
        ),
      ]),
    );
  }
}

// Widget aud(
//     String data, String name, BuildContext context, DocumentSnapshot pic) {
//   if (data == "undefined" || data == null) {
//     return Container();
//   } else {
//     return InkWell(
//       onTap: () {
//         Navigator.push(
//           context,
//           CupertinoPageRoute(
//             builder: (context) => AudioPage(data, name, pic),
//           ),
//         );
//       },
//       child:
//           Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
//         Text("Audio Tour"),
//         IconButton(
//           icon: Icon(Icons.play_circle_outline, color: Colors.black),
//           highlightColor: Colors.grey,
//           tooltip: "",
//           onPressed: () {
//             Navigator.push(
//               context,
//               CupertinoPageRoute(
//                 builder: (context) => AudioPage(data, name, pic),
//               ),
//             );
//           },
//         ),
//       ]),
//     );
//   }
// }

Widget buildPara(String text) {
  var split = text.split('\\n').map((i) {
    debugPrint("halooo");
    if (i == "") {
      return Divider();
    } else {
      return Container(
          padding: new EdgeInsets.only(
            bottom: 15,
          ),
          child: Text(
            i,
            style: TextStyle(fontSize: 20),
          ));
    }
  }).toList();
  return ListView(
      physics: BouncingScrollPhysics(),
      padding: new EdgeInsets.only(right: 15, left: 15, top: 10),
      children: split);
}

Widget buildTextP(int number) {
  return StreamBuilder(
    stream: Firestore.instance
        .collection("History")
        .document(number.toString())
        .snapshots(),
    builder: (context, snapshot) {
      // if (snapshot.connectionState == ConnectionState.done) {
        // Do some basic error processing
        if (!snapshot.hasData) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Can't connect to the internet. Retrying..."),
                CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                )
              ],
            ),
          );
        }
        if (snapshot == null || snapshot.data == null) {
          return const Text("Something went seriously wrong! Sorry!");
        }
        if (snapshot.hasError) {
          return const Text("error!");
        }
        return buildPara(
          testString(snapshot.data, "para"),
        );
      // } else {
      //   return Container(
      //     width: MediaQuery.of(context).size.width,
      //     height: MediaQuery.of(context).size.height,
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       children: <Widget>[
      //         Text("Loading..."),
      //         CircularProgressIndicator(
      //           valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
      //         )
      //       ],
      //     ),
      //   );
      // }
    },
  );
}
