part of mainlib;

class AudioPage extends StatefulWidget {
  final String url;
  // final String name;
  // final DocumentSnapshot pic;

  const AudioPage(this.url);
  // We want a stateful widget because of all of theredrawing and repainting we are going to be doing. So, we create it (read: start it)
  _AudioPageState createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  AudioPlayer audioPlayer = AudioPlayer();
  Duration pos = Duration(milliseconds: 123);
  Duration dur = Duration(milliseconds: 123);
  bool playing = false;
  void play() async {
    int result = await audioPlayer.play(widget.url);
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
    return WillPopScope(
      onWillPop: () async {
        await audioPlayer.stop();
        await audioPlayer.release();
        await audioPlayer.dispose();
        return true;
      },
      child: Scaffold(
        // appBar: new AppBar(
        //   backgroundColor: Colors.black,
        //   title: Text("Audio Tour: " + widget.name),
        // ),
        body: Container(
          width: MediaQuery.of(context).size.width * 0.75,
          padding: EdgeInsets.only(
            right: 10,
            left: 10,
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Padding(
              //   padding: EdgeInsets.only(top: 15),
              //   child: FittedBox(
              //     child: getImage(widget.pic, "picURL", context),
              //     fit: BoxFit.fitHeight,
              //   ),
              // ),
              // Padding(
              //   padding: EdgeInsets.only(
              //     bottom: 0,
              //     top: 10,
              //   ),
              //   child: Text(testString(widget.pic, "audioDesc")),
              // ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.pause, color: Colors.white),
                        onPressed: () {
                          // pause();
                        }),
                    playing
                        ? IconButton(
                            iconSize: 60,
                            icon: Icon(Icons.pause),
                            onPressed: () {
                              pause();
                            })
                        : IconButton(
                            iconSize: 60,
                            icon: Icon(Icons.play_circle_outline),
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
                            icon: Icon(Icons.stop, color: Colors.white),
                            onPressed: () {
                              // stop();
                            }),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(pos.toString().substring(2, 7)),
                      Text(dur.toString().substring(2, 7)),
                    ],
                  ),
                  Padding(
                      child: SeekBar(
                        progressColor: Colors.black,
                        min: 0.0,
                        max: dur.inMilliseconds == 123.toDouble()
                            ? 100.toDouble()
                            : dur.inSeconds.toDouble(),
                        value: pos.inMilliseconds == 123.toDouble()
                            ? 100.toDouble()
                            : pos.inSeconds.toDouble(),
                        onValueChanged: (value) async {
                          debugPrint(value.toString());

                          await audioPlayer.seek(Duration(
                              seconds:
                                  (dur.inSeconds * value.progress).round()));
                        },
                      ),
                      padding: new EdgeInsets.only(top: 10)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
