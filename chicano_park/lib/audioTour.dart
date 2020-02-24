part of mainlib;

class AudioPage extends StatefulWidget {
  final String url;
  final String name;

  const AudioPage(this.url, this.name);
  // We want a stateful widget because of all of theredrawing and repainting we are going to be doing. So, we create it (read: start it)
  _AudioPageState createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  AudioPlayer audioPlayer = AudioPlayer();
  Duration pos = Duration(milliseconds: 123);
  Duration dur = Duration(milliseconds: 123);
  void play() async {
    int result = await audioPlayer.play(widget.url);
    if (result == 1) {
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
    await audioPlayer.dispose();
    super.dispose();
  }

  void pause() async {
    await audioPlayer.pause();
  }

  void stop() async {
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
        appBar: new AppBar(
          backgroundColor: Colors.black,
          title: Text("Audio Tour"),
        ),
        body: Padding(
          padding: EdgeInsets.only(
            right: 10,
            left: 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Audio Tour: " + widget.name),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.play_arrow),
                      onPressed: () {
                        play();
                      }),
                  IconButton(
                      icon: Icon(Icons.pause),
                      onPressed: () {
                        pause();
                      }),
                  IconButton(
                      icon: Icon(Icons.stop),
                      onPressed: () {
                        stop();
                      }),
                ],
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
                      child: LinearPercentIndicator(
                        width: MediaQuery.of(context).size.width - 20,
                        lineHeight: 5.0,
                        percent:
                            ((pos.inMilliseconds == 123 ? 100 : pos.inSeconds) /
                                    (dur.inMilliseconds == 123
                                        ? 100
                                        : dur.inSeconds))
                                .toDouble(),
                        center: Text(""),
                        progressColor: Colors.red,
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
