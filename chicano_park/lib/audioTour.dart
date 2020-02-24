part of mainlib;

class AudioPage extends StatefulWidget {
  final String url;

  const AudioPage(this.url);
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
      audioPlayer.onAudioPositionChanged.listen(
          (Duration p) => {debugPrint(p.toString()), setState(() => pos = p)});
      audioPlayer.onDurationChanged.listen((Duration d) {
        print('Max duration: $d');
        setState(() => dur = d);
      });
      // success
    }
  }

  void pause() async {
    await audioPlayer.pause();
  }

  void stop() async {
    await audioPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Audio Tour"),
      ),
      body: Column(
        children: <Widget>[
          Text("player"),
          MaterialButton(
            child: Text("play"),
            onPressed: () {
              play();
            },
          ),
          MaterialButton(
            child: Text("pause"),
            onPressed: () {
              pause();
            },
          ),
          MaterialButton(
            child: Text("stop"),
            onPressed: () {
              stop();
            },
          ),
          FAProgressBar(
            progressColor: Colors.black,
            animatedDuration: Duration(milliseconds: 500),
            maxValue: dur.inMilliseconds == 123 ? 100 : dur.inSeconds,
            currentValue: pos.inMilliseconds == 123 ? 100 : pos.inSeconds,
            displayText: pos.inMilliseconds == 123 ? "" : 's',
          )
        ],
      ),
    );
  }
}
