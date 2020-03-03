part of mainlib;

class MainHistory extends StatefulWidget {
  final PanelController pc;
  final ScrollController sc;
  MainHistory(this.pc, this.sc);
  @override
  _MainHistoryState createState() {
    return _MainHistoryState();
  }
}

class _MainHistoryState extends State<MainHistory>
    with SingleTickerProviderStateMixin {
  int pompousAss = 1;
  bool backItUpBoii = false;
  bool workingOnSomething = false;
  Color selected = Colors.black;
  Color normal = Colors.grey;
  Color one = Colors.black;
  Color two = Colors.grey;
  Color three = Colors.grey;
  Color four = Colors.grey;
  double bigPP = 40.0;
  Widget lineCircleThingBuilder(int intTHing) {
    return GestureDetector(
      onLongPress: () async {
        if (intTHing == 4) {
          if (await Vibration.hasVibrator()) {
            Vibration.vibrate(duration: 25);
          }
          Navigator.push(
            context,
            FadeRoute(page: CreditsPage()),
          );
        }
      },
      onTap: () {
        setColor(intTHing);
        setState(() {
          pompousAss = intTHing;
        });
      },
      child: Stack(
        children: <Widget>[
          // Do not remove. Does not work without this
          new Padding(
            padding: const EdgeInsets.only(left: 50.0),
            child: new Card(
              margin: new EdgeInsets.all(20.0),
              child: new Container(
                width: 0,
                height: 100,
                color: Colors.green,
              ),
            ),
          ),
          // ----
          new Positioned(
            top: 0.0,
            bottom: 0.0,
            left: 30.0,
            child: new Container(
              height: 100,
              width: 1.0,
              color: Colors.grey,
            ),
          ),
          new Positioned(
            top: 50.0,
            left: 15.0,
            child: new Container(
              height: 30.0,
              width: 30.0,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: new Container(
                margin: new EdgeInsets.all(5.0),
                height: 25.0,
                width: 25.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  color: (intTHing == 1)
                      ? one
                      : (intTHing == 2)
                          ? two
                          : (intTHing == 3)
                              ? three
                              : (intTHing == 4) ? four : one,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget part(
      int bigPP, double size, String title, String subtitle, String summary) {
    return InkWell(
      key: ValueKey<int>(bigPP),
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(right: 70),
        // width: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              child: Opacity(
                opacity: 0.4,
                child: IconButton(
                    enableFeedback: false,
                    icon: Icon(Icons.keyboard_arrow_up,
                        color: (bigPP == 1) ? Colors.white : Colors.grey,
                        size: size),
                    onPressed: () {}),
              ),
            ),
            Column(children: <Widget>[
              Text(title, style: TextStyle(fontSize: 25)),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(subtitle, style: TextStyle(fontSize: 20)),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30, bottom: 0),
                child: Center(
                  child: Text(
                    summary,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: MaterialButton(
                  child: Text(
                    "Learn More",
                    style: TextStyle(color: Colors.lightBlue),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => InfoPage(
                            subtitle,
                            bigPP,
                          ),
                        ));
                  },
                ),
              ),
            ]),
            Container(
              padding: EdgeInsets.all(20),
              child: Opacity(
                opacity: 0.4,
                child: IconButton(
                    enableFeedback: false,
                    icon: Icon(Icons.keyboard_arrow_down,
                        color: (bigPP == 4) ? Colors.white : Colors.grey,
                        size: size),
                    onPressed: () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setColor(int index) {
    if (index == 1) {
      setState(() {
        one = selected;
        two = normal;
        three = normal;
        four = normal;
      });
    } else if (index == 2) {
      setState(() {
        one = normal;
        two = selected;
        three = normal;
        four = normal;
      });
    } else if (index == 3) {
      setState(() {
        one = normal;
        two = normal;
        three = selected;
        four = normal;
      });
    } else if (index == 4) {
      setState(() {
        one = normal;
        two = normal;
        three = normal;
        four = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        leading:
            IconButton(icon: Icon(Icons.keyboard_arrow_down), onPressed: () {
              widget.pc.animatePanelToPosition(0);
            }),
        backgroundColor: Colors.black,
        title: Text("History"),
      ),
      body: Wrap(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 70,
                    // height: ,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        lineCircleThingBuilder(1),
                        lineCircleThingBuilder(2),
                        lineCircleThingBuilder(3),
                        lineCircleThingBuilder(4),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                        onVerticalDragUpdate:
                            (DragUpdateDetails details) async {
                          if (workingOnSomething) {
                            // do nothing
                          } else {
                            if (details.delta.dy > 0) {
                              setState(() {
                                workingOnSomething = true;
                                backItUpBoii = true;
                                pompousAss == 1
                                    ? pompousAss == 1
                                    : pompousAss = pompousAss - 1;
                                pompousAss == 1
                                    ? setColor(1)
                                    : (pompousAss == 2
                                        ? setColor(2)
                                        : (pompousAss == 3
                                            ? setColor(3)
                                            : pompousAss == 4
                                                ? setColor(4)
                                                : normal));
                              });
                              Future.delayed(const Duration(milliseconds: 300),
                                  () {
                                workingOnSomething = false;
                              });
                            } else if (details.delta.dy < 0) {
                              setState(() {
                                workingOnSomething = true;
                                backItUpBoii = false;
                                pompousAss == 4
                                    ? pompousAss == 4
                                    : pompousAss = pompousAss + 1;
                                pompousAss == 1
                                    ? setColor(1)
                                    : (pompousAss == 2
                                        ? setColor(2)
                                        : (pompousAss == 3
                                            ? setColor(3)
                                            : pompousAss == 4
                                                ? setColor(4)
                                                : normal));
                              });
                              Future.delayed(const Duration(milliseconds: 300),
                                  () {
                                workingOnSomething = false;
                              });
                            }
                          }
                        },
                        child: StreamBuilder(
                            stream: Firestore.instance
                                .collection("History")
                                .document(pompousAss.toString())
                                .snapshots(),
                            builder: (context, snapshot) {
                              return PageTransitionSwitcher(
                                duration: const Duration(milliseconds: 500),
                                reverse: backItUpBoii,
                                transitionBuilder: (
                                  Widget child,
                                  Animation<double> animation,
                                  Animation<double> secondaryAnimation,
                                ) {
                                  return SharedAxisTransition(
                                    child: child,
                                    animation: animation,
                                    secondaryAnimation: secondaryAnimation,
                                    transitionType:
                                        SharedAxisTransitionType.vertical,
                                  );
                                },
                                child: pompousAss == 1
                                    ? part(
                                        1,
                                        bigPP,
                                        testString(snapshot.data, "title"),
                                        testString(snapshot.data, "subtitle"),
                                        testString(snapshot.data, "summary"))
                                    : (pompousAss == 2
                                        ? part(
                                            2,
                                            bigPP,
                                            testString(snapshot.data, "title"),
                                            testString(
                                                snapshot.data, "subtitle"),
                                            testString(
                                                snapshot.data, "summary"))
                                        : (pompousAss == 3
                                            ? part(
                                                3,
                                                bigPP,
                                                testString(
                                                    snapshot.data, "title"),
                                                testString(
                                                    snapshot.data, "subtitle"),
                                                testString(
                                                    snapshot.data, "summary"))
                                            : pompousAss == 4
                                                ? part(
                                                    4,
                                                    bigPP,
                                                    testString(
                                                        snapshot.data, "title"),
                                                    testString(snapshot.data,
                                                        "subtitle"),
                                                    testString(snapshot.data,
                                                        "summary"))
                                                : part(
                                                    1,
                                                    bigPP,
                                                    testString(
                                                        snapshot.data, "title"),
                                                    testString(snapshot.data,
                                                        "subtitle"),
                                                    testString(snapshot.data,
                                                        "summary")))),
                              );
                            })),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
