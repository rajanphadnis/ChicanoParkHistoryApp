part of mainlib;

class CreditsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreditsPageState();
  }
}

class _CreditsPageState extends State<CreditsPage>
    with TickerProviderStateMixin {
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

  List<String> listData = [];
  List<String> names = [
    "Rajan Phadnis",
    "Evan Mickelson",
    "Jordan Wood",
    "Elisse Chow",
    "Sloane McGuire",
    "Matthew Peng",
    "Ishan Seendripu",
    "Mr. Pashkow",
    "Mr. Hobbs",
  ];
  List<String> titles = [
    "Technical Lead",
    "Cheif Technical Consultant",
    "UI/UX",
    "Operations",
    "Project Lead",
    "Graphics",
    "?",
    "Got all the Data",
    "Teacher"
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
      body: Column(
        children: <Widget>[
          AnimatedOpacity(
            opacity: _main ? 1.0 : 0.0,
            duration: Duration(milliseconds: 1000),
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
                      opacity: _slideVisible ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 1000),
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
                      opacity: _fadeVisible ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 1000),
                      child: Center(
                        child: Text(
                          "Presented by Pacific Ridge School and Chicano Park",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  GestureDetector(
                    onLongPress: () async {
                      if (await Vibration.hasVibrator()) {
                        Vibration.vibrate(duration: 100);
                      }
                      Util flameUtil = Util();
                      await flameUtil.fullScreen();
                      await flameUtil
                          .setOrientation(DeviceOrientation.portraitUp);

                      SharedPreferences storage =
                          await SharedPreferences.getInstance();
                      GameController gameController = GameController(storage);
                      runApp(gameController.widget);

                      TapGestureRecognizer tapper = TapGestureRecognizer();
                      tapper.onTapDown = gameController.onTapDown;
                      flameUtil.addGestureRecognizer(tapper);
                    },
                    child: AnimatedOpacity(
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
                  ),
                ],
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: _fade2Visible ? 1.0 : 0.0,
            duration: Duration(milliseconds: 1000),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Center(
                child: Text(
                  "Built with pride by:",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 300,
              child: AnimatedOpacity(
                opacity: _fade2Visible ? 1.0 : 0.0,
                duration: Duration(milliseconds: 1000),
                child: AnimatedList(
                  physics: BouncingScrollPhysics(),
                  key: _listKey,
                  initialItemCount: listData.length,
                  itemBuilder: (context, int i, Animation<double> doub) {
                    return SlideTransition(
                        position: doub.drive(Tween<Offset>(
                          begin: const Offset(15, 0.0),
                          end: Offset.zero,
                        )),
                        child: ListTile(
                          subtitle: Text(titles[i].toString()),
                          title: Text(names[i].toString()),
                        ));
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
