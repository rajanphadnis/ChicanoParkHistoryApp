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

  Future<bool> _onWillPop() async {
    var vlose;
    await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit the app?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              Navigator.of(context).pop(false);
              setState(() {
                vlose = false;
              });
              return false;
            },
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              setState(() {
                vlose = true;
              });
              return true;
            },
            child: new Text('Yes'),
          ),
        ],
      ),
    );
    return vlose;
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
              : (selectedThing == 2) ? MuralPage(found, _pc, false) : (selectedThing == 3) ? MainHistory(_pc, sc) : MuralGallery(_pc, sc),
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
