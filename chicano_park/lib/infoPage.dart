part of mainlib;

class InfoPage extends StatelessWidget {
  final String historyNum;
  final int historyCaseNum;
  InfoPage(this.historyNum, this.historyCaseNum);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.black,
        title: Text(historyNum),
      ),
      body: buildTextP(historyCaseNum),
    );
  }
}
