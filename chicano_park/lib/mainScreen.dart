part of mainlib;

class _MainPageState extends State<MainPage> {
  bool dialVisible = true;
  CameraController controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String muralTitleThing;
  var confidenceThing;
  static const platform = const MethodChannel('samples.flutter.dev/battery');
  var realData;
  int selectedThing = 1;
  PanelController _pc = new PanelController();
  FlutterTts flutterTts = FlutterTts();
  bool fade = true;
  bool dragg = true;
  Future<void> go() async {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  }
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
        dragg = true;
      });
    } else if (index == 2) {
      setState(() {
        one = normal;
        two = selected;
        three = normal;
        four = normal;
        dragg = false;
      });
    } else if (index == 3) {
      setState(() {
        one = normal;
        two = normal;
        three = selected;
        four = normal;
        dragg = false;
      });
    } else if (index == 4) {
      setState(() {
        one = normal;
        two = normal;
        three = normal;
        four = selected;
        dragg = false;
      });
    }
  }
  Widget MainHistory() {
    return Scaffold(
      appBar: new AppBar(
        leading: IconButton(
            icon: Icon(Icons.keyboard_arrow_down),
            onPressed: () {
              _pc.animatePanelToPosition(0);
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
                      onVerticalDragUpdate: (DragUpdateDetails details) async {
                        if (workingOnSomething) {
                          // do nothing
                        } else {
                          if (details.delta.dy > 0) {
                            setState(() {
                              workingOnSomething = true;
                              backItUpBoii = true;
                              pompousAss == 1
                                  ? pompousAss = 1
                                  : pompousAss = pompousAss - 1;
                              pompousAss == 1
                                  ? setColor(1)
                                  : pompousAss == 2
                                      ? setColor(2)
                                      : pompousAss == 3
                                          ? setColor(3)
                                          : pompousAss == 4
                                              ? setColor(4)
                                              : setColor(1);
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
                                  ? pompousAss = 4
                                  : pompousAss = pompousAss + 1;
                              pompousAss == 1
                                  ? setColor(1)
                                  : pompousAss == 2
                                      ? setColor(2)
                                      : pompousAss == 3
                                          ? setColor(3)
                                          : pompousAss == 4
                                              ? setColor(4)
                                              : setColor(1);
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
                                          testString(snapshot.data, "subtitle"),
                                          testString(snapshot.data, "summary"))
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
                                                  testString(
                                                      snapshot.data, "summary"))
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
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<bool> _onWillPop() async {
    // var vlose;
    // await showDialog(
    //   context: context,
    //   builder: (context) => new AlertDialog(
    //     title: new Text('Are you sure?'),
    //     content: new Text('Do you want to exit the app?'),
    //     actions: <Widget>[
    //       new FlatButton(
    //         onPressed: () {
    //           Navigator.of(context).pop(false);
    //           setState(() {
    //             vlose = false;
    //           });
    //           return false;
    //         },
    //         child: new Text('No'),
    //       ),
    //       new FlatButton(
    //         onPressed: () {
    //           Navigator.of(context).pop(true);
    //           setState(() {
    //             vlose = true;
    //           });
    //           return true;
    //         },
    //         child: new Text('Yes'),
    //       ),
    //     ],
    //   ),
    // );
    // _pc.animatePanelToPosition(0);
    return false;
  }

  Future<void> _getBatteryLevel(String path2) async {
    String batteryLevel;
    try {
      debugPrint("running");
      var result = await platform.invokeMethod('runModel', <String, dynamic>{
        'path': path2,
      });

      batteryLevel = result.toString();
      debugPrint(result.toString());
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      muralTitleThing = batteryLevel;
      processing = false;
    });
  }

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.ultraHigh);
    try {
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Widget cameraPreview(size, controller) {
    return ClipRect(
      child: Container(
        child: Transform.scale(
          scale: controller.value.aspectRatio / size.aspectRatio,
          child: Center(
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: CameraPreview(controller),
            ),
          ),
        ),
      ),
    );
  }

  void log(double av, double confidence, double number,
      FirebaseAnalytics analytics) async {
    final DocumentReference postRef =
        Firestore.instance.collection("Murals").document(found);
    Firestore.instance.runTransaction((transaction) async {
      await transaction.update(postRef, {
        'views': FieldValue.increment(1),
        'avg': ((av * number) + confidence) / (1 + number)
      });
    });
  }

  void runModelThingyTHing(double av, double number) async {
    setState(() {
      processing = true;
    });
    final path2 = join(
      (await getTemporaryDirectory()).path,
      '${DateTime.now()}.png',
    );
    await controller.takePicture(path2);
    print(path2);
    await _getBatteryLevel(path2);
    var stringSplit = muralTitleThing;
    var newStr = stringSplit.split(":");
    if (newStr.isEmpty) {
      setState(() {
        processing = false;
      });
    } else {
      var label = newStr[0];
      double confidence = double.parse(newStr[1].toString()) * 100;
      if (confidence >= confidenceNumThing) {
        var parsedJson = json.decode(jsonData);
        found = parsedJson[label];
        final DocumentReference postRef =
            Firestore.instance.collection("Murals").document(found);
        try {
          postRef == null
              ? DoNothingAction()
              : postRef.updateData({
                  'views': FieldValue.increment(1),
                  'avg': (((av * number) + confidence) / (1 + number))
                });
        } catch (e) {
          debugPrint("error analytics");
        }
        debugPrint("done thing");
        setState(() {
          processing = false;
          selectedThing = 2;
          found = parsedJson[label];
        });
        _pc.animatePanelToPosition(1);
      } else {
        setState(() {
          processing = false;
        });
      }
    }
  }

  Widget theBottomButtonNavigation() {
    return Container(
      padding: EdgeInsets.all(15.0),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                selectedThing = 1;
              });
              _pc.animatePanelToPosition(1);
            },
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 18.0,
                  child: IconButton(
                    icon: Icon(Icons.list, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        selectedThing = 1;
                      });
                      _pc.animatePanelToPosition(1);
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.list, color: Colors.black),
                  onPressed: () {
                    setState(() {
                      selectedThing = 1;
                    });
                    _pc.animatePanelToPosition(1);
                  },
                ),
              ],
            ),
          ),
          StreamBuilder(
            stream: Firestore.instance
                .collection("Murals")
                .document(found)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 40.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 38.0,
                        child: IconButton(
                          icon: Icon(
                            Icons.add_circle,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            runModelThingyTHing(
                                0.0, testDouble(snapshot.data, "views"));
                          },
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 33.0,
                        child: IconButton(
                          icon: processing
                              ? CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : Icon(
                                  Icons.camera_alt,
                                  size: 28.0,
                                  color: Colors.grey,
                                ),
                          onPressed: () {
                            runModelThingyTHing(
                                0.0, testDouble(snapshot.data, "views"));
                          },
                        ),
                      ),
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
              return Padding(
                padding: EdgeInsets.only(bottom: 40.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 38.0,
                      child: IconButton(
                        icon: Icon(
                          Icons.add_circle,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          runModelThingyTHing(testDouble(snapshot.data, "avg"),
                              testDouble(snapshot.data, "views"));
                        },
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 33.0,
                      child: IconButton(
                        icon: processing
                            ? CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              )
                            : Icon(
                                Icons.camera_alt,
                                size: 28.0,
                                color: Colors.grey,
                              ),
                        onPressed: () {
                          runModelThingyTHing(testDouble(snapshot.data, "avg"),
                              testDouble(snapshot.data, "views"));
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 18.0,
                child: IconButton(
                  icon: Icon(Icons.list, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      selectedThing = 3;
                    });
                    _pc.animatePanelToPosition(1);
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.explore, color: Colors.black),
                onPressed: () {
                  setState(() {
                    selectedThing = 3;
                  });
                  _pc.animatePanelToPosition(1);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (!controller.value.isInitialized) {
      return new GestureDetector(
        onTap: () {
          controller = CameraController(cameras[0], ResolutionPreset.ultraHigh);
          controller.initialize().then((_) {
            if (!mounted) {
              return;
            }
            setState(() {});
          });
        },
        child: FlareActor("assets/Camera.flr",
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: "loop"),
      );
    }
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        key: _scaffoldKey,
        body: SlidingUpPanel(
          panelSnapping: true,
          backdropEnabled: true,
          backdropOpacity: 0.8,
          // Experiment with this
          // renderPanelSheet: false,
          // parallaxEnabled: false,
          // parallaxOffset: 0.6,
          // ----
          minHeight: 0,
          maxHeight: MediaQuery.of(context).size.height * 1,
          controller: _pc,
          isDraggable: dragg,
          onPanelOpened: () {
            if (selectedThing == 3) {
              setState(() {
                dragg = false;
              });
            }
            else {
              // do nothing
            }
          },
          onPanelClosed: () {
            if (selectedThing == 3) {
              setState(() {
                dragg = true;
              });
            }
          },
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          panelBuilder: (ScrollController sc) => (selectedThing == 1)
              ? MuralGallery(_pc, sc)
              : (selectedThing == 2) ? MuralPage(found, _pc, false, sc) : (selectedThing == 3) ? MainHistory() : MuralGallery(_pc, sc),
          body: Stack(
            children: <Widget>[
              cameraPreview(size, controller),
              theBottomButtonNavigation(),
            ],
          ),
        ),
      ),
    );
  }
}
