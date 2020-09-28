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
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Word item = snapshot.data[index];
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    print('[_WordListPageState][ListView][Dismissible][onDismissed]');
                    DBProvider.db.deleteWord(item.wordId);
                  },
                  child: ListTile(
                    leading: Icon(Icons.book, size: 30),
                    title: Text(item.word),
                  ),
                );
              },
            );
          } else {
            // 若未获取到数据，则显示缓冲动画
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
