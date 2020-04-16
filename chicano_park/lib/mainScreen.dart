// Add this file to the mainlib library
part of mainlib;
// Create a stateful widget to change on-the-fly
class _MainPageState extends State<MainPage> {
  // Initialize and set all the variables we need
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
  // Make sure the cameras are initialized before continuing
  Future<void> go() async {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  }
  // Init more variables
  int historyPageIndex = 1;
  bool allowSwipeOnce = false;
  bool swiping = false;
  // Set some colors
  Color selected = Colors.black;
  Color normal = Colors.grey;
  Color one = Colors.black;
  Color two = Colors.grey;
  Color three = Colors.grey;
  Color four = Colors.grey;
  double historyTimelineIndex = 40.0;
  final int reactionDelay = 300;
  int transitionSpeed = 500;
  // Create the side timeline widget function
  Widget lineCircleThingBuilder(int intTHing) {
    // Add a GestureDetector to detect swipes
    return GestureDetector(
      // Trigger game if long-press on the 4th node
      onLongPress: () async {
        if (intTHing == 4) {
          // Vibrate (haptic feedback)
          if (await Vibration.hasVibrator()) {
            Vibration.vibrate(duration: 25);
          }
          // Navigate to CreditsPage
          Navigator.push(
            context,
            FadeRoute(page: CreditsPage()),
          );
        }
      },
      // When user taps on timeline node, set the color of that node to "Active" and change the history index to that node's index. This will display the correct history text and trigger the animation
      onTap: () {
        setColor(intTHing);
        setState(() {
          historyPageIndex = intTHing;
        });
      },
      // Here are the nodes in the timeline view
      child: Stack(
        children: <Widget>[
          // Do not remove. Does not work without this for some reason. It is an empty green container
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
          // Node background color/circle
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
// Node "active" color
          new Positioned(
            top: 50.0,
            left: 15.0,
            // Node "active" color circle
            child: new Container(
              height: 30.0,
              width: 30.0,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              // Node Text (depends on the node number - fed from the function)
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
// This is the actual history content - the stuff that is shown on the right of the screen. It is a function because we want it to be dynamic
  Widget part(
      int historyTimelineIndex, double size, String title, String subtitle, String summary) {
        // First, make it "Tappable"
    return InkWell(
      key: ValueKey<int>(historyTimelineIndex),
      onTap: () {},
      child: Container(
        // Add some padding to make it look nice
        padding: EdgeInsets.only(right: 70),
        // width: 200,
        child: Column(
          // align things properly
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // The top-most item is an icon that points up
            Container(
              padding: EdgeInsets.all(20),
              child: Opacity(
                opacity: 0.4,
                child: IconButton(
                    enableFeedback: false,
                    icon: Icon(Icons.keyboard_arrow_up,
                    // Make the icon the same color as the background if there is no other page above it
                        color: (historyTimelineIndex == 1) ? Colors.white : Colors.grey,
                        size: size),
                    onPressed: () {}),
              ),
            ),
            // Add the "Text" part
            Column(children: <Widget>[
              // add the title
              Text(title, style: TextStyle(fontSize: 25)),
              // Add some padding and the subtitle under the Title
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(subtitle, style: TextStyle(fontSize: 20)),
              ),
              // Add some more padding and the summary text
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
              // Add some more padding and a button to redirect to the correct InfoPage
              Padding(
                padding: EdgeInsets.only(top: 20),
                // Create the Button
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
                            historyTimelineIndex,
                          ),
                        ));
                  },
                ),
              ),
            ]),
            // Add the bottom icon if there is a page below
            Container(
              padding: EdgeInsets.all(20),
              child: Opacity(
                opacity: 0.4,
                child: IconButton(
                    enableFeedback: false,
                    icon: Icon(Icons.keyboard_arrow_down,
                        color: (historyTimelineIndex == 4) ? Colors.white : Colors.grey,
                        size: size),
                    onPressed: () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
// Create a function to easily set the color of a timeline Node to "Active"
  void setColor(int index) async {
    if (index == 1) {
      setState(() {
        one = selected;
        two = normal;
        three = normal;
        four = normal;
      });
      // this prevents an edge case where the user tries to "Drag" a node instead of the swipe.
      await Future.delayed(Duration(milliseconds: reactionDelay), () {
        setState(() {
          dragg = true;
        });
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
  //  Create the main widget
  Widget mainHistory() {
    // Use a scaffold so that we can reference it later
    return Scaffold(
      // Use an appbar at the top
      appBar: new AppBar(
        leading: IconButton(
            icon: Icon(Icons.keyboard_arrow_down),
            onPressed: () {
              // If "minimized", animate the widget away.
              _pc.animatePanelToPosition(0);
            }),
        backgroundColor: Colors.black,
        title: Text("History"),
      ),
      // This is the main content of this page
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
                        if (swiping) {
                          // do nothing
                        } else {
                          if (details.delta.dy > 0) {
                            setState(() {
                              swiping = true;
                              allowSwipeOnce = true;
                              historyPageIndex == 1
                                  ? historyPageIndex = 1
                                  : historyPageIndex = historyPageIndex - 1;
                              historyPageIndex == 1
                                  ? setColor(1)
                                  : historyPageIndex == 2
                                      ? setColor(2)
                                      : historyPageIndex == 3
                                          ? setColor(3)
                                          : historyPageIndex == 4
                                              ? setColor(4)
                                              : setColor(1);
                            });
                            Future.delayed(
                                Duration(milliseconds: reactionDelay), () {
                              swiping = false;
                            });
                          } else if (details.delta.dy < 0) {
                            setState(() {
                              swiping = true;
                              allowSwipeOnce = false;
                              historyPageIndex == 4
                                  ? historyPageIndex = 4
                                  : historyPageIndex = historyPageIndex + 1;
                              historyPageIndex == 1
                                  ? setColor(1)
                                  : historyPageIndex == 2
                                      ? setColor(2)
                                      : historyPageIndex == 3
                                          ? setColor(3)
                                          : historyPageIndex == 4
                                              ? setColor(4)
                                              : setColor(1);
                            });
                            Future.delayed(
                                Duration(milliseconds: reactionDelay), () {
                              swiping = false;
                            });
                          }
                        }
                      },
                      child: StreamBuilder(
                          stream: Firestore.instance
                              .collection("History")
                              .document(historyPageIndex.toString())
                              .snapshots(),
                          builder: (context, snapshot) {
                            return PageTransitionSwitcher(
                              duration: Duration(milliseconds: transitionSpeed),
                              reverse: allowSwipeOnce,
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
                              child: historyPageIndex == 1
                                  ? part(
                                      1,
                                      historyTimelineIndex,
                                      testString(snapshot.data, "title"),
                                      testString(snapshot.data, "subtitle"),
                                      testString(snapshot.data, "summary"))
                                  : (historyPageIndex == 2
                                      ? part(
                                          2,
                                          historyTimelineIndex,
                                          testString(snapshot.data, "title"),
                                          testString(snapshot.data, "subtitle"),
                                          testString(snapshot.data, "summary"))
                                      : (historyPageIndex == 3
                                          ? part(
                                              3,
                                              historyTimelineIndex,
                                              testString(
                                                  snapshot.data, "title"),
                                              testString(
                                                  snapshot.data, "subtitle"),
                                              testString(
                                                  snapshot.data, "summary"))
                                          : historyPageIndex == 4
                                              ? part(
                                                  4,
                                                  historyTimelineIndex,
                                                  testString(
                                                      snapshot.data, "title"),
                                                  testString(snapshot.data,
                                                      "subtitle"),
                                                  testString(
                                                      snapshot.data, "summary"))
                                              : part(
                                                  1,
                                                  historyTimelineIndex,
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
// Build the app
  @override
  Widget build(BuildContext context) {
    // get the dimensionos of the device
    final size = MediaQuery.of(context).size;
    // If the camera is not ready, show the "camera not ready" flar animation. Make it tappable so that the user can grant camera permissions
    if (!controller.value.isInitialized) {
      // Make it tappable
      return new GestureDetector(
        onTap: () {
          controller = CameraController(cameras[0], ResolutionPreset.ultraHigh);
          // Request camera permissions
          controller.initialize().then((_) {
            if (!mounted) {
              return;
            }
            setState(() {});
          });
        },
        // Add flare animation
        child: FlareActor("assets/Camera.flr",
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: "loop"),
      );
    }
    // Prevent Android users from using the back button to exit the app
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        // Set app background color
        backgroundColor: Theme.of(context).backgroundColor,
        key: _scaffoldKey,
        // add the sliding panel and its properties
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
            } else {
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
              : (selectedThing == 2)
                  ? MuralPage(found, _pc, false, sc)
                  : (selectedThing == 3)
                      ? mainHistory()
                      : MuralGallery(_pc, sc),
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
