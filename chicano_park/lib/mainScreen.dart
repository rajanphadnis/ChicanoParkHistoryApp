part of mainlib;

class _TheMainAppHomePageState extends State<TheMainAppHomePage> {
  // Define a camera controller. This determines which camera we want to use and when
  bool dialVisible = true;
  CameraController controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String muralTitleThing;
  var confidenceThing;
  static const platform = const MethodChannel('samples.flutter.dev/battery');
  var realData;

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

  void showTheModalThingWhenTheButtonIsPressed(BuildContext context) {
    // Obviously show the bottom sheet
    showModalBottomSheet(
      // we want it be dismissable when you swipe down
      isScrollControlled: true,
      // Add the corner radii
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      // Background color of the bottom sheet
      backgroundColor: Colors.white,
      // Choose which "navigator" to put the modal in. We just choose the general "context", which is the main, root navigator
      context: context,
      // now we supply the modal with the widget inside of the modal
      builder: (context) => Wrap(
        // Wrap the text and stuff so that nothing gets cut off
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Center(
              child: Column(
                children: <Widget>[
                  // This is the "pill" shape at the top of the modal. See the class at the bottom of the file.
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: CustomPaint(
                      painter:
                          PaintSomeRandomShapeThatIsProbablyARectangleWithSomeRadius(),
                      child: Container(
                        decoration: BoxDecoration(
                            border: new Border.all(color: Colors.white),
                            borderRadius:
                                new BorderRadius.all(Radius.circular(2.5)),
                            color: Colors.grey),
                        height: 5,
                        width: 40,
                      ),
                    ),
                  ),
                  // This is the title for the modal. get the data from the database
                  Text(
                    testString(realData, "title"),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  // Add the image
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: getImage(realData, "picURL"),
                  ),
                  Text(
                    "By: Artist Name",
                    style: TextStyle(fontSize: 20),
                  ),
                  // add scrollable description that fills up the rest of the available space in the modal
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(testString(realData, "desc")),
                      ),
                    ),
                  ),
                  // Just your average share button. and a tour button that collapses the modal bottom sheet
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: RaisedButton.icon(
                          icon: Icon(Icons.share),
                          label: Text("Share"),
                          onPressed: () {
                            // The message that will be shared. This can be a link, some text or contact or anything really
                            // Share.share("Hello there!");
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: RaisedButton.icon(
                          icon: Icon(Icons.explore),
                          label: Text("Tour Guide"),
                          onPressed: () {
                            // Remember navigator? We just "pop" it to get rid of it.
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // initialize camera when the app is initialized
  @override
  void initState() {
    super.initState();
    // loadModel();
    controller = CameraController(cameras[0], ResolutionPreset.ultraHigh);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  // Get rid of the camera controller and access to the camera when the app is closed
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
              //The actual camera
              aspectRatio: controller.value.aspectRatio,
              child: CameraPreview(controller),
            ),
          ),
        ),
      ),
    );
  }

  Widget theBottomButtonNavigation() {
    return Container(
      padding: EdgeInsets.all(15.0),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 18.0,
                child: IconButton(
                  icon: Icon(Icons.list, color: Colors.white),
                  onPressed: () {
                    // _neverSatisfied();
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.list, color: Colors.black),
                onPressed: () {
                  // _neverSatisfied();
                },
              ),
            ],
          ),
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 38.0,
                child: IconButton(
                  icon: Icon(
                    Icons.add_circle,
                    // size: 28.0,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // Do nothing
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
                              new AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Icon(
                          Icons.camera_alt,
                          size: 28.0,
                          color: Colors.grey,
                        ),
                  onPressed: () async {
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
                      _scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          content: Text("No labels found"),
                          duration: Duration(milliseconds: 750),
                        ),
                      );
                    } else {
                      var label = newStr[0];
                      double confidence =
                          double.parse(newStr[1].toString()) * 100;
                      if (confidence >= confidenceNumThing) {
                        _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text("$label: $confidence \%"),
                            duration: Duration(milliseconds: 500),
                          ),
                        );
                        var parsedJson = json.decode(jsonData);
                        found = parsedJson[label];
                        Firestore.instance
                            .collection('Murals')
                            .document(found)
                            .get()
                            .then((DocumentSnapshot ds) {
                          setState(() {
                            realData = ds;
                          });
                          realData = ds;
                        });
                        setState(() {
                          processing = false;
                        });
                        showTheModalThingWhenTheButtonIsPressed(context);
                      } else {
                        setState(() {
                          processing = false;
                        });
                        _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text("$label: $confidence \%"),
                            duration: Duration(milliseconds: 500),
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
            ],
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
                    showHistoryBottomSheet(context);
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.explore, color: Colors.black),
                onPressed: () {
                  showHistoryBottomSheet(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

// OK, now for the meaty stuff. The main widget here (called "build") is the main homepage widget in the "TheMainAppHomePage" class
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // First, make sure that we have initialized the camera and the app (corner case: some devices run slower, so this makes sure that the camera is running before we show the camera to the user)
    if (!controller.value.isInitialized) {
      // If its not initialized, we let the user know with the following helpful message
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // We can add more here, but this is a basic template that I made
              Text(
                  "You must enable camera and recording/audio persmissions in order to use this app")
            ],
          ),
        ),
      );
    }
    // When the camera is initialized (Stateful widget, so it is constantly re-checking the state), show the main app ui
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          //This is the camera
          cameraPreview(size, controller),
          theBottomButtonNavigation(),
        ],
      ),
    );
  }
}
