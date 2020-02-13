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

//This is the mural display widget, it shows the mural photo and its description
  Widget newDisplayModal(BuildContext context) {
    return StreamBuilder(
        stream:
            Firestore.instance.collection("Murals").document(found).snapshots(),
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
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
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
          return SlidingUpPanel(
            panelSnapping: true,
            backdropEnabled: true,
            minHeight: 0,
            maxHeight: MediaQuery.of(context).size.height * 0.95,
            controller: _pc,
            onPanelClosed: () {
              playTTS(context, "");
            },
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
            panelBuilder: (ScrollController sc) => Scaffold(
              body: new CustomScrollView(
                controller: sc,
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 10.0, bottom: 10.0, right: 10, left: 10),
                      child: CustomPaint(
                        painter: PaintRectangle(),
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
                  ),
                  SliverAppBar(
                    backgroundColor: Colors.black,
                    expandedHeight: 256.0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: new FlexibleSpaceBar(
                      centerTitle: true,
                      title: Text(testString(snapshot.data, "title")),
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
                                  testString(snapshot.data, "author")),
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
                              icon: Icon(Icons.headset, color: Colors.purple),
                              highlightColor: Colors.grey,
                              tooltip: "Press to listen to the description",
                              onPressed: () {
                                playTTS(
                                    context, testString(snapshot.data, "desc"));
                              },
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(15),
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
                            padding: const EdgeInsets.all(15),
                            child: RaisedButton.icon(
                              icon: Icon(Icons.share),
                              label: Text("Share"),
                              onPressed: () {
                                // The message that will be shared. This can be a link, some text or contact or anything really
                                Share.share(testString(snapshot.data, "title"));
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: RaisedButton.icon(
                              icon: Icon(Icons.explore),
                              label: Text("Tour Guide"),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ]),
                  )
                ],
              ),
            ),
          );
        });
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

  void runModelThingyTHing() async {
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
      double confidence = double.parse(newStr[1].toString()) * 100;
      if (confidence >= confidenceNumThing) {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text("$label: $confidence \%"),
            duration: Duration(milliseconds: 500),
          ),
        );
        var parsedJson = json.decode(jsonData);
        found = parsedJson[label];
        setState(() {
          processing = false;
        });
        _pc.animatePanelToPosition(1);
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MuralGallery(),
                      ),
                    );

                    //HERE FOR MURAL LIBRARY/MURAL GALLERY
                    // Do nothing for now
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.list, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MuralGallery(),
                    ),
                  );
                  // _neverSatisfied();
                },
              ),
            ],
          ),

          //The middle button that runs the model
          //There are two circle avatars because then the user can touch any part of the button
          Padding(
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
                      // size: 28.0,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      runModelThingyTHing();
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
                    onPressed: () {
                      runModelThingyTHing();
                    },
                  ),
                ),
              ],
            ),
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

// OK, now for the meaty stuff. The main widget here (called "build") is the main homepage widget in the "MainPage" class.
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
          newDisplayModal(context),
        ],
      ),
    );
  }
}
