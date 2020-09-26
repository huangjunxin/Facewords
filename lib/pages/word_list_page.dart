import 'package:flutter/material.dart';
import 'package:facewords/services/japanese_mecab.dart';

class WordListPage extends StatefulWidget {
  @override
  _WordListPageState createState() => _WordListPageState();
}

class _WordListPageState extends State<WordListPage> {
  // 格式化 wordList
  List<Widget> _formatWordList() {
    print('[_WordListPageState][_formatWordList]');
    List<Widget> tempList = [];
    for (var item in wordList) {
      if (item['pos'] == '記号') {
        // 若当前项为符号，则忽略此项
      } else {
        // 否则则直接显示
        tempList.add(ListTile(
          leading: Icon(Icons.book, size: 30),
          title: Text(item['baseform']),
        ));
      }
    }
    return tempList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(10),
        children: _formatWordList(),
      ),
    );
  }
}
