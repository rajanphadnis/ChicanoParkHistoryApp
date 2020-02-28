part of mainlib;

class MuralGallery extends StatefulWidget {
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
              slivers: <Widget>[
                SliverAppBar(
                  // leading: Icon(Icons.arrow_back_ios),
                  backgroundColor: Colors.black,
                  expandedHeight: 256.0,
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
                          //was 10.0 and 20.0
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            found = getMuralName(snapshot, index);
                          });
                          // Navigator.pop(context);
                          // _pc.animatePanelToPosition(1);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MuralPage(found),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 130,
                              width: MediaQuery.of(context).size.width / 2,
                              child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: getMuralPic(snapshot, "picURL", index),
                              ),
                            ),
                            //This is the title below the murals
                            // Text(
                            //   getMuralPic(snapshot, "title", index),
                            //   textAlign: TextAlign.center,
                            //   style: new TextStyle(
                            //     fontSize: 14.0,
                            //     color: Colors.black,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    );
                  }, childCount: gett),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
