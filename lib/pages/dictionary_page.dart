import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DictionaryPage extends StatefulWidget {
  Map arguments;
  DictionaryPage({Key key, this.arguments}) : super(key: key);

  @override
  _DictionaryPageState createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dictionary'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(text: 'Jisho'),
              Tab(text: 'Kotobank'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            WebView(
              initialUrl:
                  'https://jisho.org/search/${widget.arguments['word']}',
              javascriptMode: JavascriptMode.unrestricted,
            ),
            WebView(
              initialUrl:
                  'https://kotobank.jp/gs/?q=${widget.arguments['word']}',
              javascriptMode: JavascriptMode.unrestricted,
            ),
          ],
        ),
      ),
    );
  }
}
