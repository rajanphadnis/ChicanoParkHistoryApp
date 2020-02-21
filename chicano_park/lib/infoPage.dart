part of mainlib;

class InfoPage extends StatelessWidget {
  final String historyNum;
  final int historyCaseNum;
  InfoPage(this.historyNum, this.historyCaseNum);
  @override
  Widget build(BuildContext context) {
    print(historyNum);
    print(historyCaseNum);
    return Scaffold(
      appBar: new AppBar(
        title: Text(historyNum),
      ),
      body: buildTextP(historyCaseNum),
    );
  }
}
