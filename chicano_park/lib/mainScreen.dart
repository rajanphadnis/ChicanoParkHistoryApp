part of mainlib;

class _MainPageState extends State<MainPage> {
  // Define a camera controller. This determines which camera we want to use and when
  bool dialVisible = true;
  CameraController controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String muralTitleThing;
  var confidenceThing;
  static const platform = const MethodChannel('samples.flutter.dev/battery');
  var realData;
  PanelController _pc = new PanelController();
  FlutterTts flutterTts = FlutterTts();
  bool talking = false;
  Future<void> go() async {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  }

  Future<bool> _onWillPop() async {
    if (_pc.isPanelOpen) {
      _pc.animatePanelToPosition(0);
      return false;
    } else {
      return (await showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Are you sure?'),
              content: new Text('Do you want to exit the app?'),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text('No'),
                ),
                new FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: new Text('Yes'),
                ),
              ],
            ),
          )) ??
          false;
    }
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

  void playTTS(BuildContext context, String talk) {
    if (talking == false && talk != "") {
      flutterTts.speak(talk);
      talking = true;
    } else {
      flutterTts.stop();
      talking = false;
    }
  }

  // initialize camera when the app is initialized
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

  // Get rid of the camera controller and access to the camera when the app is closed
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  //Display the camera
  Widget cameraPreview(size, controller) {
    return ClipRect(
      child: Container(
        child: Transform.scale(
          scale: controller.value.aspectRatio / size.aspectRatio,
          child: Center(
            child: AspectRatio(
              //The actual camera
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
        postRef.updateData({
          'views': FieldValue.increment(1),
          'avg': (((av * number) + confidence) / (1 + number))
        });
        // log(av, confidence, analytics);
        debugPrint("done thing");
        setState(() {
          processing = false;
        });
        _pc.animatePanelToPosition(1);
      } else {
        setState(() {
          processing = false;
        });
      }
    }
  }

  void launchGame() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 250);
      if (await Vibration.hasAmplitudeControl()) {
        Vibration.vibrate(amplitude: 128);
      }
    }
    Util flameUtil = Util();
    await flameUtil.fullScreen();
    await flameUtil.setOrientation(DeviceOrientation.portraitUp);

    SharedPreferences storage = await SharedPreferences.getInstance();
    GameController gameController = GameController(storage);
    runApp(gameController.widget);

    TapGestureRecognizer tapper = TapGestureRecognizer();
    tapper.onTapDown = gameController.onTapDown;
    flameUtil.addGestureRecognizer(tapper);
  }

  Widget theBottomButtonNavigation() {
    return Container(
      padding: EdgeInsets.all(15.0),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          //MURAL GALLERY/LIBRARY
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MuralGallery(_pc),
                ),
              );
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MuralGallery(_pc),
                        ),
                      );
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.list, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MuralGallery(_pc),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          //The middle button that runs the model
          //There are two circle avatars because then the user can touch any part of the button
          StreamBuilder(
              stream: Firestore.instance
                  .collection("Murals")
                  .document(found)
                  .snapshots(),
              builder: (context, snapshot) {
                // Do some basic error processing
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
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
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
                            runModelThingyTHing(
                                testDouble(snapshot.data, "avg"),
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
                            runModelThingyTHing(
                                testDouble(snapshot.data, "avg"),
                                testDouble(snapshot.data, "views"));
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }),
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 18.0,
                child: IconButton(
                  icon: Icon(Icons.list, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainHistory(),
                            ),
                          );
                    // showHistoryBottomSheet(context);
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.explore, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainHistory(),
                            ),
                          );
                  // showHistoryBottomSheet(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

// OK, now for the meaty stuff. The main widget here (called "build") is the main homepage widget in the "MainPage" class.
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // First, make sure that we have initialized the camera and the app (corner case: some devices run slower, so this makes sure that the camera is running before we show the camera to the user)
    if (!controller.value.isInitialized) {
      // If its not initialized, we let the user know with the following helpful message
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
    // When the camera is initialized (Stateful widget, so it is constantly re-checking the state), show the main app ui
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
          parallaxEnabled: true,
          parallaxOffset: 0.6,
          // ----
          minHeight: 0,
          maxHeight: MediaQuery.of(context).size.height * 0.95,
          controller: _pc,
          onPanelClosed: () {
            playTTS(context, "");
          },
          padding:
              const EdgeInsets.only(top: 20.0, bottom: 0.0, right: 0, left: 0),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          panelBuilder: (ScrollController sc) => StreamBuilder(
              stream: Firestore.instance
                  .collection("Murals")
                  .document(found)
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
                        Text("Can't connect to the internet. Retrying..."),
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
                return Scaffold(
                  body: CustomScrollView(
                    controller: sc,
                    slivers: <Widget>[
                      SliverAppBar(
                        backgroundColor: Colors.white,
                        expandedHeight: 256.0,
                        floating: false,
                        pinned: true,
                        flexibleSpace: new FlexibleSpaceBar(
                          centerTitle: true,
                          title: Text(
                            testString(snapshot.data, "title"),
                            style: TextStyle(color: Colors.black),
                          ),
                          background: FittedBox(
                            child: getImage(snapshot.data, "picURL", context),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Column(children: [
                          InkWell(
                            onTap: () {
                              _pc.animatePanelToPosition(0);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ArtistPage(
                                      testString(snapshot.data, "author"), _pc),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  testString(snapshot.data, "author"),
                                  style: TextStyle(fontSize: 20),
                                ),
                                IconButton(
                                  icon:
                                      Icon(Icons.headset, color: Colors.purple),
                                  highlightColor: Colors.grey,
                                  tooltip: "Press to listen to the description",
                                  onPressed: () {
                                    //BUG: ON PRESSED THIS IS CLOSING THE PANEL
                                    playTTS(context,
                                        testString(snapshot.data, "desc"));
                                  },
                                ),
                              ],
                            ),
                          ),
                          inte(testUndString(snapshot.data, "interview")),
                          aud(
                              testUndString(snapshot.data, "audioTour"),
                              testString(snapshot.data, "title"),
                              context,
                              snapshot.data),
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 15,
                              right: 15,
                              left: 15,
                            ),
                            child: Text(
                              testString(snapshot.data, "desc"),
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          // Just your average share button. and a tour button that collapses the modal bottom sheet
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(30),
                                child: RaisedButton.icon(
                                  icon: Icon(Icons.share),
                                  label: Text("Share"),
                                  onPressed: () {
                                    // The message that will be shared. This can be a link, some text or contact or anything really
                                    Share.share(
                                        testString(snapshot.data, "title"));
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(30),
                                child: RaisedButton.icon(
                                  icon: Icon(Icons.explore),
                                  label: Text("All Murals"),
                                  onPressed: () {
                                    _pc.animatePanelToPosition(0);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MuralGallery(_pc),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ]),
                      )
                    ],
                  ),
                );
              }),
          body: Stack(
            children: <Widget>[
              //This is the camera
              cameraPreview(size, controller),
              theBottomButtonNavigation(),
            ],
          ),
        ),
      ),
    );
  }
}
