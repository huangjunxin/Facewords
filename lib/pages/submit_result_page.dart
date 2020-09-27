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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result'),
        actions: <Widget>[
          FlatButton(
            child: Text('Continue'),
            textColor: Colors.white,
            color: Color(0x000000),
            onPressed: this._resultList.length == 0 // 若请求 api 未获取到结果
                ? null // 则使按钮 disabled
                : () { // 否则，下方为点击按钮所做的操作
                    print(
                        '[_SubmitResultPageState][FlatButton][onPressed]: Continue');
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                      (route) => route == null,
                      arguments: {
                        'index': 0,
                        // 'wordList': this._selectedList,
                      },
                    );
                    for (var item in _selectedList) {
                      var newDBWord = Word(
                        word: item['baseform'],
                        language: 'ja',
                        pos: item['pos'],
                        meaning: null,
                        count: 1,
                      );
                      DBProvider.db.newWord(newDBWord);
                    }
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
