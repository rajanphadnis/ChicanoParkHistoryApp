part of mainlib;

class MuralGallery extends StatefulWidget {
  final PanelController _pc;
  MuralGallery(this._pc);
  _MuralGallery createState() => _MuralGallery();
}

class _MuralGallery extends State<MuralGallery> {
  int gett = 7;
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
      stream: Firestore.instance.collection("Murals").snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Text("error");
          } else {
            return Scaffold(
              body: new CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: <Widget>[
                  SliverAppBar(
                    leading: IconButton(
                        icon: Icon(Icons.keyboard_arrow_down,
                            color: Colors.white),
                        onPressed: () {
                          widget._pc.animatePanelToPosition(0);
                        }),
                    backgroundColor: Colors.black,
                    floating: false,
                    pinned: true,
                    flexibleSpace: new FlexibleSpaceBar(
                      centerTitle: true,
                      title: Text("Murals"),
                    ),
                  ),
                  SliverStaggeredGrid.countBuilder(
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,
                    crossAxisCount: 2,
                    staggeredTileBuilder: (_) => StaggeredTile.fit(1),
                    itemBuilder: (context, index) => new Container(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                        elevation: 0.0,
                        borderOnForeground: true,
                        child: InkWell(
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          onTap: () {
                            found = getMuralName(snapshot, index);
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) =>
                                      MuralPage(found, widget._pc, true),
                                ));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(0),
                            child: Image.network(
                              getMuralPic(snapshot, "picURL", index),
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
