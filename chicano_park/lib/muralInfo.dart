part of mainlib;

class MuralPage extends StatefulWidget {
  final String found;
  final PanelController pc;
  final bool fromGallery;
  final ScrollController sc;
  MuralPage(this.found, this.pc, this.fromGallery, this.sc);
  _MuralPageState createState() => _MuralPageState();
}

class _MuralPageState extends State<MuralPage>
    with SingleTickerProviderStateMixin {
  bool talking = false;
  FlutterTts flutterTts = FlutterTts();
  AudioPlayer audioPlayer = AudioPlayer();
  Duration pos = Duration(milliseconds: 123);
  Duration dur = Duration(milliseconds: 123);
  String url;
  bool playing = false;
  bool expanded = false;
  bool go = false;
  // ScrollController sc;
  AnimationController _animationController;
  Animation _animation;
  int fadeAnimDur = 500;
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

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: fadeAnimDur));
    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
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
    stop();
    super.dispose();
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

  void closeAndPause() async {
    _animationController.reverse();
    pause();
    await Future.delayed(Duration(milliseconds: fadeAnimDur), () {
      setState(() {
        expanded = !expanded;
      });
    });
    // OR, uncomment the lines below
    // setState(() {
    //     expanded = !expanded;
    //   });
  }

  void openThing(AsyncSnapshot<dynamic> snapshot) {
    _animationController.forward();
    url = testUndString(snapshot.data, "audioTour");
    expanded = !expanded;
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
          //If the program cannot connect to firebase,
          //display a container saying so
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

          //Using willPopScope as oppose to a container 
          //Lets us exit the main container without closing the app
          return WillPopScope(
            onWillPop: () async {
              stop();
              return true;
            },
            //The actual mural info page
            child: Scaffold(
              body: CustomScrollView(
                physics: BouncingScrollPhysics(),
                controller: widget.sc,
                slivers: <Widget>[
                  SliverAppBar(
                    forceElevated: true,
                    elevation: 1,
                    leading: !widget.fromGallery
                        ? IconButton(
                            icon: Icon(Icons.keyboard_arrow_down,
                                color: Colors.white),
                            onPressed: () {
                              widget.pc.animatePanelToPosition(0);
                            })
                        : IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                    centerTitle: true,
                    title: Text(
                      testString(snapshot.data, "title"),
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.black,
                    expandedHeight: 256.0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: new FlexibleSpaceBar(
                      background: FittedBox(
                        child: getImage(snapshot.data, "picURL", context),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  //Go to author page button
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 0, bottom: 0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => ArtistPage(
                                    testString(snapshot.data, "authorFile"),
                                    testString(snapshot.data, "author"),
                                  ),
                                ),
                              );
                            },
                            //The row of buttons below the bigger picture
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                    child: Container(
                                      width: 70.0,
                                      height: 70.0,
                                      decoration: new BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 0,
                                        ),
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                          fit: BoxFit.cover,
                                          //Show the artist's picture
                                          image: NetworkImage((testUndString(
                                                      snapshot.data,
                                                      "artistPic") ==
                                                  "undefined"
                                              ? "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg"
                                              : testUndString(
                                                  snapshot.data, "artistPic"))),
                                        ),
                                      ),
                                    ),
                                    padding: EdgeInsets.only(
                                        top: 10,
                                        left: 10,
                                        right: 10,
                                        bottom: 10)),
                                //Link to audio tour page
                                Container(
                                  height: 80,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        testString(snapshot.data, "author"),
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      (testUndString(snapshot.data,
                                                      "audioTour") ==
                                                  null ||
                                              testUndString(snapshot.data,
                                                      "audioTour") ==
                                                  "undefined")
                                          ? Container(height: 0)
                                          : InkWell(
                                              onTap: () {
                                                setState(() async {
                                                  expanded
                                                      ? closeAndPause()
                                                      : openThing(snapshot);
                                                });
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text("Audio Tour"),
                                                  IconButton(
                                                    icon: expanded
                                                        ? Icon(
                                                            Icons.arrow_drop_up)
                                                        : Icon(Icons
                                                            .arrow_drop_down),
                                                    highlightColor: Colors.grey,
                                                    tooltip: "",
                                                    onPressed: () {
                                                      setState(() {
                                                        expanded
                                                            ? closeAndPause()
                                                            : openThing(
                                                                snapshot);
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                      inte(testUndString(
                                          snapshot.data, "interview")),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        expanded
                              //Audio player, which fades in on use. 
                            ? FadeTransition(
                                opacity: _animation,
                                child: Container(
                                  padding: EdgeInsets.only(bottom: 20),
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                                onPressed: () {}),
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
                                                    onPressed: () {}),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(pos
                                                  .toString()
                                                  .substring(2, 7)),
                                              Text(dur
                                                  .toString()
                                                  .substring(2, 7)),
                                            ],
                                          ),
                                          Padding(
                                              child: SeekBar(
                                                backgroundColor: Colors.grey,
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
                                ),
                              )
                            : Container(),
                        // Expanded(child: buildPara(testString(snapshot.data, "desc"),),
                        // ),
                        //Mural description 
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 0,
                            bottom: 15,
                            right: 15,
                            left: 15,
                          ),
                          child: Text(
                            testString(snapshot.data, "desc"),
                            style: TextStyle(fontSize: 18),
                          ),
                        ),

                        //Share button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: RaisedButton.icon(
                                highlightColor: Colors.white,
                                icon: Icon(IconData(0xf4ca,
                                    fontFamily: CupertinoIcons.iconFont,
                                    fontPackage:
                                        CupertinoIcons.iconFontPackage)),
                                label: Text("Share"),
                                onPressed: () {
                                  // TODO: change this value
                                  Share.share(
                                      testString(snapshot.data, "title") +
                                          " is a cool mural in Chicano Park!");
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
