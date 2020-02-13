part of mainlib;

class MuralGallery extends StatelessWidget {
  String getDataF(snapshot, String arg, index) {
    List thingh = snapshot.data.documents.map((doc) => doc[arg]).toList();
    return thingh[index];
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      // now add firebase integration. "subscribe" to the data from the firestore database
      stream: Firestore.instance.collection("Murals").snapshots(),
      builder: (context, snapshot) {
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
                  title: Text("Murals"),
                  background: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image:
                          "https://www.kcet.org/sites/kl/files/atoms/article_atoms/www.kcet.org/socal/departures/landofsunshine/assets_c/2012/11/poetswall-thumb-630x450-39917.jpg",
                    ),
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
                          child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: getDataF(snapshot, "picURL", index),
                          ),
                        ),
                        //This is the title below the murals
                        Text(
                          getDataF(snapshot, "title", index),
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            // backgroundColor: Colors.black
                          ),
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
