part of mainlib;

class MuralPage extends StatefulWidget {
  final found;
  MuralPage(this.found);
  // We want a stateful widget because of all of theredrawing and repainting we are going to be doing. So, we create it (read: start it)
  _MuralPageState createState() => _MuralPageState();
}

class _MuralPageState extends State<MuralPage> {
  bool talking = false;
  FlutterTts flutterTts = FlutterTts();
  AudioPlayer audioPlayer = AudioPlayer();
  Duration pos = Duration(milliseconds: 123);
  Duration dur = Duration(milliseconds: 123);
  String url;
  bool playing = false;
  bool expanded = false;
  bool go = false;
  ScrollController sc;
  var top;
  void playTTS(BuildContext context, String talk) {
    if (talking == false && talk != "") {
      flutterTts.speak(talk);
      talking = true;
    } else {
      flutterTts.stop();
      talking = false;
    }
  }

  void play() async {
    int result = await audioPlayer.play(url);
    if (result == 1) {
      setState(() {
        playing = true;
      });
      audioPlayer.onAudioPositionChanged
          .listen((Duration p) => {setState(() => pos = p)});
      audioPlayer.onDurationChanged.listen((Duration d) {
        print('Max duration: $d');
        setState(() => dur = d);
      });
      // success
    }
  }

  @override
  void dispose() async {
    super.dispose();
    await audioPlayer.dispose();
  }

  void pause() async {
    setState(() {
      playing = false;
    });
    await audioPlayer.pause();
  }

  void stop() async {
    setState(() {
      playing = false;
    });
    await audioPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: Firestore.instance
              .collection("Murals")
              .document(widget.found)
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
                // controller: sc,
                slivers: <Widget>[
                  SliverAppBar(
                    // title: Text(
                    //     testString(snapshot.data, "title"),
                    //     style: TextStyle(color: Colors.white),
                    //   ),
                    // textTheme: TextTheme(: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.black,
                    expandedHeight: 256.0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: new FlexibleSpaceBar(
                      // top = constraints.biggest.height;
                      centerTitle: true,
                      title: Text(
                        testString(snapshot.data, "title"),
                        style: TextStyle(color: Colors.white),
                      ),
                      background: FittedBox(
                        child: getImage(snapshot.data, "picURL", context),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    // onStretchTrigger: () {
                    //   sc.addListener(() {

                    //   });
                    // },
                  ),
                  // SliverAppBar(
                  //   // title: Text(
                  //   //     testString(snapshot.data, "title"),
                  //   //     style: TextStyle(color: Colors.white),
                  //   //   ),
                  //   // textTheme: TextTheme(: TextStyle(color: Colors.white)),
                  //   backgroundColor: Colors.black,
                  //   expandedHeight: 256.0,
                  //   floating: false,
                  //   pinned: true,
                  //   flexibleSpace: new FlexibleSpaceBar(
                  //     // top = constraints.biggest.height;

                  //     centerTitle: true,
                  //     title: Text(
                  //       testString(snapshot.data, "title"),
                  //       style: TextStyle(color: Colors.white),
                  //     ),
                  //     background: FittedBox(
                  //       child: getImage(snapshot.data, "picURL", context),
                  //       fit: BoxFit.fitHeight,
                  //     ),
                  //   ),
                  //   // onStretchTrigger: () {
                  //   //   sc.addListener(() {

                  //   //   });
                  //   // },
                  // ),
                  // SliverToBoxAdapter(
                  //   child: IconButton(
                  //     icon: Icon(Icons.headset, color: Colors.purple),
                  //     highlightColor: Colors.grey,
                  //     tooltip: "Press to listen to the description",
                  //     onPressed: () {
                  //       //BUG: ON PRESSED THIS IS CLOSING THE PANEL
                  //       playTTS(context, testString(snapshot.data, "desc"));
                  //     },
                  //   ),
                  // ),
                  SliverToBoxAdapter(
                    child: Column(children: [
                      InkWell(
                        onTap: () {
                          // _pc.animatePanelToPosition(0);
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ArtistPage(
                                  testString(snapshot.data, "author")),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                                child: Container(
                                  padding: new EdgeInsets.only(top: 20),
                                  width: 70.0,
                                  height: 70.0,
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
                                      width: 0,
                                    ),
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage((testUndString(
                                                      snapshot.data,
                                                      "artistPic") ==
                                                  "undefined"
                                              ? "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg"
                                              : testUndString(
                                                  snapshot.data, "picURL"))
                                          // "https://programmingii-367d0.web.app/profile.jpg"
                                          ),
                                    ),
                                  ),
                                ),
                                padding: EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 10)),
                            Container(
                              height: 80,
                              child: 
                            Column(
                              
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  testString(snapshot.data, "author"),
                                  style: TextStyle(fontSize: 18),
                                ),
                                (testUndString(snapshot.data, "audioTour") ==
                                            null ||
                                        testUndString(
                                                snapshot.data, "audioTour") ==
                                            "undefined")
                                    ? Container()
                                    : InkWell(
                                        onTap: () {
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) =>
                                          //         AudioPage(data, name, pic),
                                          //   ),
                                          // );
                                          setState(() {
                                            url = testUndString(
                                                snapshot.data, "audioTour");
                                            expanded = !expanded;
                                            go = !go;
                                          });
                                        },
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text("Audio Tour"),
                                              IconButton(
                                                icon: expanded
                                                    ? Icon(Icons.arrow_drop_up)
                                                    : Icon(
                                                        Icons.arrow_drop_down),
                                                // Icon(Icons.play_circle_outline,
                                                //     color: Colors.black),
                                                highlightColor: Colors.grey,
                                                tooltip: "",
                                                onPressed: () {
                                                  setState(() {
                                                    url = testUndString(
                                                        snapshot.data,
                                                        "audioTour");
                                                    expanded = !expanded;
                                                    go = !go;
                                                  });
                                                  // Navigator.push(
                                                  //   context,
                                                  //   MaterialPageRoute(
                                                  //     builder: (context) =>
                                                  //         AudioPage(data, name, pic),
                                                  //   ),
                                                  // );
                                                },
                                              ),
                                            ]),
                                      ),
                                inte(testUndString(snapshot.data, "interview")),
                              ],
                            ),
                            ),],
                        ),
                      ),
                      expanded
                          ? AnimatedOpacity(
                              // If the widget is visible, animate to 0.0 (invisible).
                              // If the widget is hidden, animate to 1.0 (fully visible).
                              opacity: go ? 1.0 : 0.0,
                              duration: Duration(milliseconds: 1000),
                              // The green box must be a child of the AnimatedOpacity widget.
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          IconButton(
                                              icon: Icon(Icons.pause,
                                                  color: Colors.white),
                                              onPressed: () {
                                                // pause();
                                              }),
                                          playing
                                              ? IconButton(
                                                  iconSize: 40,
                                                  icon: Icon(Icons.pause),
                                                  onPressed: () {
                                                    pause();
                                                  })
                                              : IconButton(
                                                  iconSize: 40,
                                                  icon: Icon(Icons
                                                      .play_circle_outline),
                                                  onPressed: () {
                                                    play();
                                                  }),
                                          playing
                                              ? IconButton(
                                                  icon: Icon(Icons.stop),
                                                  onPressed: () {
                                                    stop();
                                                  })
                                              : IconButton(
                                                  icon: Icon(Icons.stop,
                                                      color: Colors.white),
                                                  onPressed: () {
                                                    // stop();
                                                  }),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                                pos.toString().substring(2, 7)),
                                            Text(
                                                dur.toString().substring(2, 7)),
                                          ],
                                        ),
                                        Padding(
                                            child: SeekBar(
                                              progressColor: Colors.black,
                                              min: 0.0,
                                              max: dur.inMilliseconds ==
                                                      123.toDouble()
                                                  ? 100.toDouble()
                                                  : dur.inSeconds.toDouble(),
                                              value: pos.inMilliseconds ==
                                                      123.toDouble()
                                                  ? 100.toDouble()
                                                  : pos.inSeconds.toDouble(),
                                              onValueChanged: (value) async {
                                                debugPrint(value.toString());

                                                await audioPlayer.seek(Duration(
                                                    seconds: (dur.inSeconds *
                                                            value.progress)
                                                        .round()));
                                              },
                                            ),
                                            padding:
                                                new EdgeInsets.only(top: 10)),
                                      ],
                                    )
                                  ],
                                ),
                              ))
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
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
                                Share.share(testString(snapshot.data, "title"));
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(30),
                            child: RaisedButton.icon(
                              icon: Icon(Icons.explore),
                              label: Text("All Murals"),
                              onPressed: () {
                                // _pc.animatePanelToPosition(0);
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MuralGallery(),
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
      // ),
    );
  }
}
