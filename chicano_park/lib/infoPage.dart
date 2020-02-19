part of mainlib;
class InfoPage extends StatelessWidget {
  final String historyNum;
  final int historyCaseNum;
  InfoPage(this.historyNum, this.historyCaseNum);
  @override
  Widget build(BuildContext context) {
    print(historyNum);
    print(historyCaseNum);
    return WebviewScaffold(
      url: "https://programmingii-367d0.web.app/" + historyCaseNum.toString() + ".html",
      hidden: true,
      appBar: AppBar(title: Text(historyNum)),
    );
  }
}
