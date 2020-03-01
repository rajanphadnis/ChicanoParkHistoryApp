part of mainlib;

class MainHistory extends StatefulWidget {
  @override
  _MainHistoryState createState() {
    return _MainHistoryState();
  }
}

class Part1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(right: 70),
        // width: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("1800s - 1972:", style: TextStyle(fontSize: 25)),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text("The Takeover", style: TextStyle(fontSize: 20)),
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
                      builder: (context) => InfoPage("The Takeover", 1),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Part2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(right: 70),
        // width: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("1960 - 1983:", style: TextStyle(fontSize: 25)),
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                right: 0,
              ),
              child: Text("Murals Appeared", style: TextStyle(fontSize: 20)),
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
                      builder: (context) => InfoPage("Murals Appeared", 2),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Part3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(right: 70),
        // width: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("1986 - Present:", style: TextStyle(fontSize: 25)),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text("Restoration", style: TextStyle(fontSize: 20)),
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
                      builder: (context) => InfoPage("Restoration", 3),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Part4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(right: 70),
        // width: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Present Day:", style: TextStyle(fontSize: 25)),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text("Current State", style: TextStyle(fontSize: 20)),
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
                      builder: (context) => InfoPage("Current State", 4),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MainHistoryState extends State<MainHistory>
    with SingleTickerProviderStateMixin {
  int pompousAss = 1;
  bool backItUpBoii = false;
  bool workingOnSomething = false;
  Color selected = Colors.blue;
  Color normal = Colors.purple;
  Color one = Colors.blue;
  Color two = Colors.purple;
  Color three = Colors.purple;
  Color four = Colors.purple;

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
        backgroundColor: Colors.black,
        title: Text("History"),
      ),
      body: Wrap(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: StreamBuilder(
              // now add firebase integration. "subscribe" to the data from the firestore database
              stream: Firestore.instance
                  .collection("History")
                  // get the document that has the title of the mural that was just scanned: "found"
                  .document("index")
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
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.black),
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
                // If there is no error, continue building the widgets
                return Center(
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
                            GestureDetector(
                              onTap: () {
                                setColor(1);
                                setState(() {
                                  pompousAss = 1;
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
                                      color: Colors.purple,
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
                                          color: one,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setColor(2);
                                setState(() {
                                  pompousAss = 2;
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
                                      color: Colors.purple,
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
                                          color: two,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setColor(3);
                                setState(() {
                                  pompousAss = 3;
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
                                      color: Colors.purple,
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
                                          color: three,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onLongPress: () async {
                                if (await Vibration.hasVibrator()) {
                                  Vibration.vibrate(duration: 50);
                                  // if (await Vibration.hasAmplitudeControl()) {
                                  //   Vibration.vibrate(amplitude: 128);
                                  // }
                                }
                                Navigator.push(
                                  context,
                                  FadeRoute(page: CreditsPage()),
                                );
                              },
                              onTap: () {
                                setColor(4);
                                setState(() {
                                  pompousAss = 4;
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
                                      color: Colors.purple,
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
                                          color: four,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
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
                                Future.delayed(
                                    const Duration(milliseconds: 750), () {
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
                                Future.delayed(
                                    const Duration(milliseconds: 750), () {
                                  workingOnSomething = false;
                                });
                              }
                            }
                          },
                          child: new PageTransitionSwitcher(
                            duration: const Duration(milliseconds: 2000),
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
                                ? Part1()
                                : (pompousAss == 2
                                    ? Part2()
                                    : (pompousAss == 3
                                        ? Part3()
                                        : pompousAss == 4 ? Part4() : Part1())),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
