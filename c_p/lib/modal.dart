part of mainlib;

void showTheModalThingWhenTheButtonIsPressed(BuildContext context) {
  var realData;
  Firestore.instance
      .collection('Murals')
      .document(found)
      .get()
      .then((DocumentSnapshot ds) {
    realData = ds;

    // use ds as a snapshot
  });
  // print(realData);
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
          child: Center(
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
                  testString(realData, "title"),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                // Add the image
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: getImage(realData, "picURL"),
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
                      child: Text(testString(realData, "desc")),
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
