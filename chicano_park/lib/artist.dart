part of mainlib;

class ArtistPage extends StatelessWidget {
  final String authorFile;
  final String author;
  // final PanelController _pc;
  ArtistPage(this.authorFile, this.author);
  final List<String> itemsTHing = List();

  String loadImage(AsyncSnapshot<dynamic> snapshot) {
    try {
      return (testUndString(snapshot.data, "picURL") == "undefined"
          ? "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg"
          : testUndString(snapshot.data, "picURL"));
    } catch (e) {
      return "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg";
    }
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      // now add firebase integration. "subscribe" to the data from the firestore database
      stream: Firestore.instance
          .collection("Artists")
          // get the document that has the title of the mural that was just scanned: "found"
          .document(authorFile)
          .snapshots(),
      builder: (context, snapshot) {
          // Do some basic error processing
          if (!snapshot.hasData) {
            return Scaffold(
              appBar: new AppBar(
                backgroundColor: Colors.black,
                title: Text("Loading..."),
              ),
              body: Container(
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
              ),
            );
          }
          if (snapshot == null || snapshot.data == null) {
            return Scaffold(
              appBar: new AppBar(
                title: Text("Error"),
              ),
              body: Text("Something went seriously wrong! Sorry!"),
            );
          }
          if (snapshot.hasError) {
            return Scaffold(
              appBar: new AppBar(
                title: Text("Error"),
              ),
              body: Text("error!"),
            );
          }
          return Scaffold(
            body: new CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: Colors.black,
                  expandedHeight: 512.0,
                  floating: false,
                  pinned: true,
                  flexibleSpace: new FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(author),
                    background: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: loadImage(snapshot),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: new EdgeInsets.only(
                      top: 20.0,
                      left: 20.0,
                      right: 20.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Bio",
                          style: TextStyle(
                            fontSize: 30.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: new EdgeInsets.all(20.0),
                      child: Text(testString(snapshot.data, "desc")),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: RaisedButton.icon(
                          icon: Icon(IconData(0xf4ca,
                              fontFamily: CupertinoIcons.iconFont,
                              fontPackage: CupertinoIcons.iconFontPackage)),
                          label: Text("Share"),
                          onPressed: () {
                            // The message that will be shared. This can be a link, some text or contact or anything really
                            // TODO: change this value
                            Share.share(author + " is an artist whose work is in Chicano Park!");
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        
      },
    );
  }
}
