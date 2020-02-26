part of mainlib;

class CreditsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreditsPageState();
  }
}

class _CreditsPageState extends State<CreditsPage> {
  bool _slideVisible = false;
  bool _fadeVisible = false;
  bool _fade2Visible = false;
  bool _main = false;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  void time(int milli) async {
    await Future.delayed(Duration(milliseconds: milli), () {
      addUser();
    });
  }

  List<String> listData = [
    // "Built with Pride by:"
  ];
  List<String> names = [
    "Built With Pride by:",
    "Rajan Phadnis",
    "Evan",
    "Elisse",
    "Jordan",
    "Sloane",
    "Matthew",
    "Ishan",
    "Mr. Pashkow",
    "Mr. Hobbs",
  ];
  void addUser() {
    int index = listData.length;
    listData.add(names[index]);
    _listKey.currentState
        .insertItem(index, duration: Duration(milliseconds: 1000));
  }

  void animateTHing() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _main = true;
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            _slideVisible = true;
            Future.delayed(const Duration(milliseconds: 2000), () {
              setState(() {
                _fadeVisible = true;
                Future.delayed(const Duration(milliseconds: 2000), () {
                  setState(() {
                    _fade2Visible = true;
                    Future.delayed(const Duration(milliseconds: 1000), () {
                      addUser();
                      Future.delayed(const Duration(milliseconds: 1000), () {
                        addUser();
                        Future.delayed(const Duration(milliseconds: 1000), () {
                          addUser();
                          Future.delayed(const Duration(milliseconds: 1000),
                              () {
                            addUser();
                            Future.delayed(const Duration(milliseconds: 1000),
                                () {
                              addUser();
                              Future.delayed(const Duration(milliseconds: 1000),
                                  () {
                                addUser();
                                Future.delayed(
                                    const Duration(milliseconds: 1000), () {
                                  addUser();
                                  Future.delayed(
                                      const Duration(milliseconds: 1000), () {
                                    addUser();
                                    Future.delayed(
                                        const Duration(milliseconds: 1000), () {
                                      addUser();
                                    });
                                  });
                                });
                              });
                            });
                          });
                        });
                      });
                    });
                  });
                });
              });
            });
          });
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    animateTHing();
    // _list = ListModel<int>(
    //   listKey: _listKey,
    //   initialItems: <int>[0, 1, 2],
    //   removedItemBuilder: _buildRemovedItem,
    // );
    // _nextItem = 3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        title: Text('About', style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: ListView(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          AnimatedOpacity(
            // If the widget is visible, animate to 0.0 (invisible).
            // If the widget is hidden, animate to 1.0 (fully visible).
            opacity: _main ? 1.0 : 0.0,
            duration: Duration(milliseconds: 1000),
            // The green box must be a child of the AnimatedOpacity widget.
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                  boxShadow: [
                    new BoxShadow(
                      color: Colors.black26,
                      offset: new Offset(0.0, 2.0),
                      blurRadius: 25.0,
                    )
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32))),
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 16, top: 32),
                    child: AnimatedOpacity(
                      // If the widget is visible, animate to 0.0 (invisible).
                      // If the widget is hidden, animate to 1.0 (fully visible).
                      opacity: _slideVisible ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 1000),
                      // The green box must be a child of the AnimatedOpacity widget.
                      child: Text(
                        'Chicano Park Explorer',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 16, top: 8),
                    child: AnimatedOpacity(
                      // If the widget is visible, animate to 0.0 (invisible).
                      // If the widget is hidden, animate to 1.0 (fully visible).
                      opacity: _fadeVisible ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 1000),
                      // The green box must be a child of the AnimatedOpacity widget.
                      child: Center(
                        child: Text(
                          "Presented by Pacific Ridge School and Chicano Park",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        // child: RichText(
                        //   text: TextSpan(children: <TextSpan>[
                        //     TextSpan(
                        //       text: 'Presented by ',
                        //       style:
                        //           TextStyle(fontSize: 18, color: Colors.black),
                        //     ),
                        //     TextSpan(
                        //       text: 'Pacific Ridge School',
                        //       style: TextStyle(
                        //           fontSize: 20,
                        //           color: Colors.blue[300],
                        //           fontWeight: FontWeight.bold),
                        //     ),
                        //     TextSpan(
                        //       text: ' and ',
                        //       style:
                        //           TextStyle(fontSize: 18, color: Colors.black),
                        //     ),
                        //     TextSpan(
                        //       text: 'Chicano Park',
                        //       style: TextStyle(
                        //           fontSize: 20,
                        //           color: Colors.blue[300],
                        //           fontWeight: FontWeight.bold),
                        //     ),
                        //   ]),
                        // ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  AnimatedOpacity(
                    opacity: _fade2Visible ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 1000),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            padding: new EdgeInsets.only(top: 20),
                            width: 110.0,
                            height: 110.0,
                            decoration: new BoxDecoration(
                              boxShadow: [
                                new BoxShadow(
                                  color: Colors.black26,
                                  offset: new Offset(0.0, 2.0),
                                  blurRadius: 25.0,
                                )
                              ],
                              border: Border.all(
                                color: Colors.white,
                                width: 8,
                              ),
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new NetworkImage(
                                    "https://programmingii-367d0.web.app/profile.jpg"),
                              ),
                            ),
                          ),
                          Container(
                            padding: new EdgeInsets.only(top: 20),
                            width: 110.0,
                            height: 110.0,
                            decoration: new BoxDecoration(
                              boxShadow: [
                                new BoxShadow(
                                  color: Colors.black26,
                                  offset: new Offset(0.0, 2.0),
                                  blurRadius: 25.0,
                                )
                              ],
                              border: Border.all(
                                color: Colors.white,
                                width: 8,
                              ),
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new NetworkImage(
                                    "https://programmingii-367d0.web.app/profile.jpg"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 300,
            child: AnimatedOpacity(
              opacity: _fade2Visible ? 1.0 : 0.0,
              duration: Duration(milliseconds: 1000),
              child: AnimatedList(
                key: _listKey,
                initialItemCount:
                    (listData.length == null || listData.length == 0)
                        ? 1
                        : listData.length,
                itemBuilder: (context, int i, Animation<double> doub) {
                  return FadeTransition(
                    opacity: doub,
                    child: ListTile(
                      title: Center(
                        child: Text(names[i].toString()),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // MaterialButton(
          //   child: Text("hello there"),
          //   onPressed: () {
          //     animateTHing();
          //   },
          // ),
          // MaterialButton(
          //   child: Text("out"),
          //   onPressed: () {
          //     setState(() {
          //       _slideVisible = false;
          //       _fadeVisible = false;
          //       _fade2Visible = false;
          //       _main = false;
          //     });
          //   },
          // ),
        ],
      ),
    );
  }
}
