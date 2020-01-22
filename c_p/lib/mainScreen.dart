part of mainlib;

class _TheMainAppHomePageState extends State<TheMainAppHomePage> {
  // Define a camera controller. This determines which camera we want to use and when
  bool dialVisible = true;
  CameraController controller;
  TextEditingController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // initialize camera when the app is initialized
  @override
  void initState() {
    super.initState();
    loadModel();
    controller = CameraController(cameras[0], ResolutionPreset.ultraHigh);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }

  // Get rid of the camera controller and access to the camera when the app is closed
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> loadModel() async {
    String dataset = "pens";
    await createLocalFiles(dataset);
    String modelLoadStatus;
    try {
      await AutomlMlkit.loadModelFromCache(dataset: dataset);
      modelLoadStatus = "AutoML model successfully loaded";
    } on PlatformException catch (e) {
      modelLoadStatus = "Error loading model";
      print("error from platform on calling loadModelFromCache");
      print(e.toString());
    }
    setState(() {
      _modelLoadStatus = modelLoadStatus;
    });
  }

  Future<void> createLocalFiles(String folder) async {
    Directory tempDir = await getTemporaryDirectory();
    final Directory modelDir = Directory("${tempDir.path}/$folder");
    if (!modelDir.existsSync()) {
      modelDir.createSync();
    }
    final filenames = ["manifest.json", "model.tflite", "dict.txt"];

    for (String filename in filenames) {
      final File file = File("${modelDir.path}/$filename");
      if (!file.existsSync()) {
        print("Copying file: $filename");
        await copyFileFromAssets(filename, file);
      }
    }
  }

  /// copies file from assets to dst file
  Future<void> copyFileFromAssets(String filename, File dstFile) async {
    ByteData data = await rootBundle.load("assets/ml/$filename");
    final buffer = data.buffer;
    dstFile.writeAsBytesSync(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future<void> _neverSatisfied() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adjust Confidence'),
          content: TextField(
            decoration: new InputDecoration.collapsed(
                hintText: confidenceNumThing.toString()),
            controller: _controller,
            textInputAction: TextInputAction.done,
            onSubmitted: (String valueT) {
              setState(() {
                confidenceNumThing = double.parse(valueT);
                Navigator.of(context).pop();
              });
            },
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                    _neverSatisfied();
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.list, color: Colors.black),
                onPressed: () {
                  _neverSatisfied();
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
                    // Construct the path where the image should be saved using the path
                    // package.
                    final path2 = join(
                      // Store the picture in the temp directory.
                      // Find the temp directory using the `path_provider` plugin thing
                      (await getTemporaryDirectory()).path,
                      '${DateTime.now()}.png',
                    );

                    // Attempt to take a picture and log where it's been saved.
                    await controller.takePicture(path2);

                    print(path2);
                    final results =
                        await AutomlMlkit.runModelOnImage(imagePath: path2);
                    if (results.isEmpty) {
                      setState(() {
                        processing = false;
                      });
                      _scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          content: Text("No labels found"),
                          duration: Duration(milliseconds: 500),
                        ),
                      );
                    } else {
                      print("Got results" + results[0].toString());
                      var label = results[0]["label"];
                      var confidence =
                          (results[0]["confidence"] * 100).toStringAsFixed(2);
                      if ((results[0]["confidence"] * 100) >=
                          confidenceNumThing) {
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
