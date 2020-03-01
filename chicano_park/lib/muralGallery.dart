part of mainlib;

class MuralGallery extends StatefulWidget {
  final ScrollController sc;
  final PanelController _pc;
  MuralGallery(this.sc, this._pc);
  // final PanelController _pc;
  // MuralGallery(this._pc);
  // We want a stateful widget because of all of theredrawing and repainting we are going to be doing. So, we create it (read: start it)
  _MuralGallery createState() => _MuralGallery();
}

class _MuralGallery extends State<MuralGallery> {
  // final PanelController _pc;
  // _MuralGallery(this._pc);
  int gett = 8;
  String getMuralPic(AsyncSnapshot<QuerySnapshot> snapshot, String arg, index) {
    try {
      if (snapshot == null) {
        return "no data";
      } else {
        List<String> imageURLData =
            snapshot.data.documents.map((doc) => doc[arg].toString()).toList();
        gett = imageURLData.length;
        try {
          return imageURLData[index];
        } catch (e) {
          return "Error";
        }
      }
    } catch (e) {
      debugPrint("error1");
      return "Error";
    }
  }

  String getMuralName(AsyncSnapshot<QuerySnapshot> snapshot, index) {
    try {
      List<String> thingh = snapshot.data.documents
          .map((doc) => doc.documentID.toString())
          .toList();
      return thingh[index];
    } catch (ee) {
      debugPrint(ee.toString());
      return "error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      // now add firebase integration. "subscribe" to the data from the firestore database
      stream: Firestore.instance.collection("Murals").snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Text("error");
        } else {
          return Scaffold(
            body: new CustomScrollView(
              physics: BouncingScrollPhysics(),
              controller: widget.sc,
              slivers: <Widget>[
                SliverAppBar(
                  // leading: Icon(Icons.arrow_back_ios),
                  backgroundColor: Colors.black,
                  // expandedHeight: 256.0,
                  floating: false,
                  pinned: true,
                  flexibleSpace: new FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text("Murals"),
                    // background: FittedBox(
                    //   fit: BoxFit.fitHeight,
                    //   child: FadeInImage.memoryNetwork(
                    //     placeholder: kTransparentImage,
                    //     image:
                    //         "https://www.kcet.org/sites/kl/files/atoms/article_atoms/www.kcet.org/socal/departures/landofsunshine/assets_c/2012/11/poetswall-thumb-630x450-39917.jpg",
                    //   ),
                    // ),
                  ),
                ),
                SliverStaggeredGrid.countBuilder(
                  crossAxisCount: 2,
                  staggeredTileBuilder: (_) => StaggeredTile.fit(1),
                  itemBuilder: (context, index) => new Container(
                    // padding: EdgeInsets.all(5),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      elevation: 5.0,
                      borderOnForeground: true,
                      margin: EdgeInsets.all(10),
                      child: InkWell(
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        onTap: () {
                          // widget._pc.animatePanelToPosition(0);
                          found = getMuralName(snapshot, index);
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    MuralPage(found, widget._pc),
                              ));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: getMuralPic(snapshot, "picURL", index),
                          ),
                        ),
                      ),
                    ),
                  ),
                  itemCount: gett,
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
