import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DictionaryPage extends StatefulWidget {
  Map arguments;
  DictionaryPage({Key key, this.arguments}) : super(key: key);

  @override
  _DictionaryPageState createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  bool _isLoading = true;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dictionary'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(text: 'Jisho'),
              Tab(text: 'Weblio'),
              Tab(text: 'JapanDict'),
              Tab(text: 'Souka'),
            ],
            onTap: (index) {
              print(
                  '[_DictionaryPageState][DefaultTabController][TabBar][onTap]: $index');
              // 防止点击当前 Tab 时出现 CircularProgressIndicator
              if (index != _currentIndex) {
                setState(() {
                  _isLoading = true;
                  _currentIndex = index;
                });
              }
            },
          ),
        ),
        body: TabBarView(
          // 禁止左右滑动切换 Tab
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Stack(
              children: <Widget>[
                WebView(
                  initialUrl:
                      'https://jisho.org/search/${widget.arguments['word']}',
                  javascriptMode: JavascriptMode.unrestricted,
                  onPageFinished: (_) {
                    setState(() {
                      _isLoading = false;
                    });
                  },
                ),
                _isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(),
              ],
            ),
            Stack(
              children: <Widget>[
                WebView(
                  initialUrl:
                      'https://www.weblio.jp/content/${widget.arguments['word']}',
                  javascriptMode: JavascriptMode.unrestricted,
                  onPageFinished: (_) {
                    setState(() {
                      _isLoading = false;
                    });
                  },
                ),
                _isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(),
              ],
            ),
            Stack(
              children: <Widget>[
                WebView(
                  initialUrl:
                      'https://www.japandict.com/${widget.arguments['word']}',
                  javascriptMode: JavascriptMode.unrestricted,
                  onPageFinished: (_) {
                    setState(() {
                      _isLoading = false;
                    });
                  },
                ),
                _isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(),
              ],
            ),
            Stack(
              children: <Widget>[
                WebView(
                  initialUrl:
                      'https://soukaapp.com/dict/${widget.arguments['word']}',
                  javascriptMode: JavascriptMode.unrestricted,
                  onPageFinished: (_) {
                    setState(() {
                      _isLoading = false;
                    });
                  },
                ),
                _isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
