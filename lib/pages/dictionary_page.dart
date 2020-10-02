import 'package:facewords/utils/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:facewords/models/corpus.dart';
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
  Future<List<Corpus>> _corpusListFuture;

  @override
  void initState() {
    super.initState();
    _corpusListFuture = getCorpusList();
  }

  Future<List<Corpus>> getCorpusList() async {
    print('[_DictionaryPageState][getCorpusList]');
    final _corpusListData =
        await DBProvider.db.getCorpusByWordId(widget.arguments['wordId']);
    return _corpusListData;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dictionary'),
          bottom: TabBar(
            isScrollable: true,
            tabs: <Widget>[
              Tab(text: 'Custom'),
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
            Scrollbar(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                    child: Text(
                      widget.arguments['word'],
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                    child: Text(
                      widget.arguments['meaning'] == null
                          ? 'No custom definitions yet'
                          : widget.arguments['meaning'],
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder<List>(
                      future: _corpusListFuture,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<dynamic>> snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              Corpus item = snapshot.data[index];
                              return ListTile(
                                leading: Icon(Icons.book, size: 30),
                                title: Text(item.corpus),
                              );
                            },
                          );
                        } else {
                          return Text('No Corpus');
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
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
