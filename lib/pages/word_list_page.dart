import 'package:facewords/models/word.dart';
import 'package:facewords/utils/database.dart';
import 'package:flutter/material.dart';
import 'package:facewords/services/japanese_mecab.dart';

class WordListPage extends StatefulWidget {
  @override
  _WordListPageState createState() => _WordListPageState();
}

class _WordListPageState extends State<WordListPage> {
  Map<String, dynamic> newWord = {};
  Future<List<Word>> _wordListFuture;

  @override
  void initState() {
    super.initState();
    _wordListFuture = getWordList();
  }

  Future<List<Word>> getWordList() async {
    print('[_WordListPageState][getWordList]');
    final _wordListData = await DBProvider.db.getWordList();
    return _wordListData;
  }

  // 格式化 wordList
  // List<Widget> _formatWordList() {
  //   print('[_WordListPageState][_formatWordList]');
  //   List<Widget> tempList = [];
  //   for (var item in wordList) {
  //     if (item['pos'] == '記号') {
  //       // 若当前项为符号，则忽略此项
  //     } else {
  //       // 否则则直接显示
  //       tempList.add(ListTile(
  //         leading: Icon(Icons.book, size: 30),
  //         title: Text(item['baseform']),
  //       ));
  //     }
  //   }
  //   return tempList;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: ListView(
      //   padding: EdgeInsets.all(10),
      //   children: _formatWordList(),
      // ),
      body: FutureBuilder<List>(
        // 获取 wordList 中所有内容
        future: _wordListFuture,
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          // 若有数据则用列表显示
          if (snapshot.hasData) {
            return Scrollbar(
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  Word item = snapshot.data[index];
                  return Dismissible(
                    background: Container(color: Colors.red), // 项被滑出时显示红色背景
                    key: Key(item.wordId.toString()),
                    onDismissed: (direction) async {
                      print('[_WordListPageState][ListView][Dismissible][onDismissed]: ${item.word}(id: ${item.wordId}) is dismissed');
                      DBProvider.db.deleteWord(item.wordId);
                      // 刷新状态，以防出现 A dismissed Dismissible widget is still part of the tree 报错
                      // https://stackoverflow.com/questions/58583950/how-to-resolve-issue-a-dismissed-dismissible-widget-is-still-part-of-the-tree
                      setState(() {
                        _wordListFuture.then((value) {
                          value.remove(item);
                        });
                      });
                      // 删除成功后显示下方提示栏
                      Scaffold.of(context).hideCurrentSnackBar();
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('"${item.word}" is deleted'),
                      ));
                    },
                    child: ListTile(
                      leading: Icon(Icons.book, size: 30),
                      title: Text(item.word),
                    ),
                  );
                },
              ),
            );
          } else {
            // 若无数据
            return Center(
              child: Text('No data'),
            );
          }
        },
      ),
    );
  }
}
