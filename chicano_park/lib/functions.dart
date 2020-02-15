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
          //width: MediaQuery.of(context).size.width,
          //height: MediaQuery.of(context).size.height,
          child: ClipRRect(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: docs[url],
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          /*decoration: BoxDecoration(
          color: Colors.blueGrey, 
        ),*/
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
  if (await canLaunch(urll)) {
    await launch(urll);
  } else {
    throw 'Could not launch $urll';
  }
}


// void playTTS(BuildContext context, String talk) {
//     if (talking == false && talk != "") {
//       flutterTts.speak(talk);
//       talking = true;
//     } else {
//       flutterTts.stop();
//       talking = false;
//     }
//   }