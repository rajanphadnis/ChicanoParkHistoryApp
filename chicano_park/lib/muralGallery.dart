part of mainlib;

class MuralGallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      // now add firebase integration. "subscribe" to the data from the firestore database
      stream: Firestore.instance
          .collection("Murals")
          // get the document that has the title of the mural that was just scanned: "found"
          // .document("index")
          .snapshots(),
      builder: (context, snapshot) {
        // Do some basic error processing
        // if (!snapshot.hasData) {
        //   return Container(
        //     width: MediaQuery.of(context).size.width,
        //     height: MediaQuery.of(context).size.height,
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: <Widget>[
        //         Text("Getting Data..."),
        //         CircularProgressIndicator(
        //           valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
        //         )
        //       ],
        //     ),
        //   );
        // }
        // if (snapshot == null || snapshot.data == null) {
        //   return const Text("Something went seriously wrong! Sorry!");
        // }
        // if (snapshot.hasError) {
        //   return const Text("error!");
        // }
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
                  title: Text("Murals\nClick to learn more!"),
                  background: Image.network(
                    "https://www.kcet.org/sites/kl/files/atoms/article_atoms/www.kcet.org/socal/departures/landofsunshine/assets_c/2012/11/poetswall-thumb-630x450-39917.jpg", //snapshot.data["picURL"],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Grid of all the murals
              SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 130.0,
                          width: double.infinity,
                          decoration: new BoxDecoration(
                            image: DecorationImage(
                              image: new NetworkImage(
                                snapshot.data[
                                    "picURL"],
                              ),
                            ),
                          ),
                        ),
                        //This is the title below the murals
                        Text(
                          "hi",
                          // testString(snapshot.data, "title"),
                          //"hello there $index",
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                              backgroundColor: Colors.black),
                        ),
                      ],
                    ),
                  );
                }, childCount: 8),
              )
            ],
          ),
        );
      },
    );
  }
}

// void showMuralGallery(BuildContext context) {

//   // Obviously show the bottom sheet
//   showMuralGallery(
//     muralGrid(),
//   );

// }
