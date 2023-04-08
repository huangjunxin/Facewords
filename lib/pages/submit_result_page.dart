import 'package:facewords/models/corpus.dart';
import 'package:facewords/models/word.dart';
import 'package:facewords/utils/database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SubmitResultPage extends StatefulWidget {
  Map arguments;
  SubmitResultPage({Key key, this.arguments}) : super(key: key);

  @override
  _SubmitResultPageState createState() => _SubmitResultPageState();
}

class _SubmitResultPageState extends State<SubmitResultPage> {
  // 从 api 获取到的结果 List
  List _resultList = [];
  // 选中项 List
  List _selectedList = [];

  @override
  void initState() {
    super.initState();
    _getSubmitResult();
  }

  // 格式化 wordList
  List<Widget> get _formatWordList {
    print('[_SubmitResultPageState][_formatWordList]');
    List<Widget> tempList = [];
    for (var item in _resultList) {
      if (item['pos'] == '記号') {
        // 若当前项为 符号，则此项不允许被选中
        tempList.add(ChoiceChip(
          label: Text(item['surface']),
          selected: _selectedList.contains(item),
        ));
      } else {
        // 否则则直接显示
        tempList.add(ChoiceChip(
          label: Text(item['surface']),
          selected: _selectedList.contains(item), // 判定是否选中
          onSelected: (selected) {
            setState(() {
              _selectedList.contains(item)
                  ? _selectedList.remove(item)
                  : _selectedList.add(item);
            });
          },
        ));
      }
    }
    return tempList;
  }

  // get 请求 api 分词结果
  _getSubmitResult() async {
    print('[_SubmitResultPageState][_getSubmitResult]: Started');
    var res = await http
        .get(widget.arguments['submitUrl'] + widget.arguments['paras']);
    if (res.statusCode == 200) {
      print('[_SubmitResultPageState][_getSubmitResult]: Succeed');
      setState(() {
        this._resultList =
            jsonDecode(utf8.decode(res.bodyBytes))['items'][0]['words'];
      });
    } else {
      throw Exception('failed');
    }
  }

  // 跳转至 Word List
  jumpToWordListPage() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (route) => route == null,
      arguments: {
        'index': 1, // 跳转到 Word List 页
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result'),
        actions: <Widget>[
          TextButton(
            child: Text('Continue'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
            // textColor: Colors.white,
            // color: Color(0x000000),
            onPressed: this._resultList.length == 0 // 若请求 api 未获取到结果
                ? null // 则使按钮 disabled
                : () async {
                    // 否则，下方为点击按钮所做的操作
                    print(
                        '[_SubmitResultPageState][FlatButton][onPressed]: Continue');
                    for (var item in _selectedList) {
                      var wordFuture =
                          await DBProvider.db.getWordByWord(item['baseform']);

                      if (wordFuture != null) {
                        // 若数据库中已存在当前项，则只将其count值加1
                        print(
                            '[_SubmitResultPageState][FlatButton][onPressed]: ${item['baseform']} already exists');
                        wordFuture.count++;
                        await DBProvider.db.updateWord(wordFuture);
                      } else {
                        // 若数据库中不存在当前项，则新增项目
                        print(
                            '[_SubmitResultPageState][FlatButton][onPressed]: ${item['baseform']} does not exist');
                        var newDBWord = Word(
                          word: item['baseform'],
                          language: 'ja',
                          pos: item['pos'],
                          meaning: null,
                          count: 1,
                        );
                        // 将新单词增加至数据库
                        await DBProvider.db.newWord(newDBWord);
                        // 再重新查一次以获取 wordId
                        wordFuture =
                            await DBProvider.db.getWordByWord(item['baseform']);
                        var newDBCorpus = Corpus(
                          corpus: widget.arguments['paras'],
                          language: widget.arguments['language'],
                          wordId: wordFuture.wordId,
                        );
                        // 将新语料增加至数据库
                        await DBProvider.db.newCorpus(newDBCorpus);
                      }
                    }
                    jumpToWordListPage();
                  },
          )
        ],
      ),
      body: this._resultList.length > 0 // 若请求 api 获取到结果
          ? Scrollbar(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Wrap(
                    spacing: 5.0,
                    runSpacing: 2.0,
                    children: _formatWordList,
                  ),
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
