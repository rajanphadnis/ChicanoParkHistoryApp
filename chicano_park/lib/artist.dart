part of mainlib;

class ArtistPage extends StatelessWidget {
  final String author;
  ArtistPage(this.author);
  List<String> itemsTHing = List();
  SliverGrid muralGrid() {
    return SliverGrid(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                // color: Colors.grey,
                height: 130.0,
                width: double.infinity,
                decoration: new BoxDecoration(
                  image: DecorationImage(
                    image: new NetworkImage(
                        "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350"),
                    fit: BoxFit.fill,
                  ),
                  // shape: BoxShape.circle,
                ),
              ),
              Text("hello there $index",
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .merge(TextStyle(fontSize: 14.0)))
            ],
          ),
        );
      }, childCount: 8),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      // now add firebase integration. "subscribe" to the data from the firestore database
      stream: Firestore.instance
          .collection("Artists")
          // get the document that has the title of the mural that was just scanned: "found"
          .document(author)
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
        return Scaffold(
          body: new CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.black,
                expandedHeight: 512.0,
                floating: false,
                pinned: true,
                flexibleSpace: new FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(author),
                  background: Image.network(
                    snapshot.data["picURL"],
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
                      IconButton(
                        icon: Icon(IconData(0xf4ca,
                            fontFamily: CupertinoIcons.iconFont,
                            fontPackage: CupertinoIcons.iconFontPackage)),
                        tooltip: 'Share',
                        onPressed: () {
                          Share.share(author);
                        },
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
                child: Padding(
                  padding: new EdgeInsets.only(
                    top: 20.0,
                    bottom: 20.0,
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: Text(
                    "Murals",
                    style: TextStyle(
                      fontSize: 30.0,
                    ),
                  ),
                ),
              ),
              muralGrid(),
            ],
          ),
        );
      },
    );
  }


}
