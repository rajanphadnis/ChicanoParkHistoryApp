part of mainlib;
// void infoPage() => runApp(InfoPage());

class InfoPage extends StatelessWidget {
  final String historyNum;
  final int historyCaseNum;
  String desc;
  String muralName;
  InfoPage(this.historyNum, this.historyCaseNum);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'History',
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(historyNum),
        ),
        body: Center(
          child: Container(
            // height: MediaQuery.of(context).size.height * 0.9,
            child: StreamBuilder(
              // now add firebase integration. "subscribe" to the data from the firestore database
              stream: Firestore.instance
                  .collection("History")
                  // get the document that has the title of the mural that was just scanned: "found"
                  .document(historyCaseNum.toString())
                  .snapshots(),
              builder: (context, snapshot) {
                // Do some basic error processing
                if (!snapshot.hasData) {
                  return const Text("Loading data...");
                }
                if (snapshot == null || snapshot.data == null) {
                  return const Text("Something went seriously wrong! Sorry!");
                }
                if (snapshot.hasError) {
                  return const Text("error!");
                }
                // If there is no error, continue building the widgets
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  
                  child: SingleChildScrollView(
                    // child: Html(
                    //   data: snapshot.data["desc"],
                    //   padding:
                    //   EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 0),
                    // ),
                    child: Text(snapshot.data["desc"], textAlign: TextAlign.center, style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 20),),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
