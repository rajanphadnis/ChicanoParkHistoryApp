part of mainlib;

class MainHistory extends StatefulWidget {
  @override
  _MainHistoryState createState() {
    return _MainHistoryState();
  }
}

class _MainHistoryState extends State<MainHistory> {
  SharedAxisTransitionType _transitionType =
      SharedAxisTransitionType.horizontal;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("History"),
      ),
      body: Wrap(
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
                      // Padding(
                      //   padding: const EdgeInsets.all(10),
                      //   child: CustomPaint(
                      //     painter: PaintRectangle(),
                      //     child: Container(
                      //       decoration: BoxDecoration(
                      //           border: new Border.all(color: Colors.white),
                      //           borderRadius:
                      //               new BorderRadius.all(Radius.circular(2.5)),
                      //           color: Colors.grey),
                      //       height: 5,
                      //       width: 40,
                      //     ),
                      //   ),
                      // ),
                      // This is the title for the modal. get the data from the database
                      Text(
                        "Chicano Park: History",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                      Center(
                        child: Padding(
                          child: Text(
                            "Timeline:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          padding: EdgeInsets.only(top: 15),
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
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreditsPage(),
                                ),
                              );
                            },
                            child: Text("Credits"),
                          ),
                        ),
                      ),
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
}
