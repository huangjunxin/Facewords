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
      if (item['pos'] == '1記号') {
        // 若当前项为 符号，则忽略此项
        // 将默认全选后的 _selectedList 的 符号 也删去
        // _selectedList.remove(item);
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
        // // 默认全选
        // this._selectedList = List.generate(
        //   this._resultList.length,
        //   (index) => this._resultList[index],
        // );
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
        ),
        body: this._resultList.length > 0
            ? Scrollbar(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Wrap(
                      spacing: 5.0,
                      runSpacing: 3.0,
                      children: _formatWordList,
                    ),
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
