part of mainlib;

void showHistoryBottomSheet(BuildContext context) {
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("Getting Data..."),
                      CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.black),
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
              // If there is no error, continue building the widgets
              return Center(
                child: Column(
                  children: <Widget>[
                    // This is the "pill" shape at the top of the modal. See the class at the bottom of the file.
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: CustomPaint(
                        painter:
                            PaintRectangle(),
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
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
  );
}
