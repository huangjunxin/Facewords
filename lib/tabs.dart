import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:facewords/services/japanese_mecab.dart';
import 'package:facewords/pages/submission_page.dart';
import 'package:facewords/pages/word_list_page.dart';
import 'package:facewords/pages/setting_page.dart';

class Tabs extends StatefulWidget {
  Map arguments;
  Tabs({Key key, this.arguments}) : super(key: key);

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  // 当前选中 Tab 序号
  int _currentIndex;
  // 接收 index 参数，跳转到指定 Tab 内容页
  @override
  void initState() {
    super.initState();
    this._currentIndex = widget.arguments == null
        ? 0 // index 参数默认为 0
        : widget.arguments['index'];
  }

  // 每个 Tab 对应不同的内容页
  List<Widget> _pageList = [
    SubmissionPage(),
    WordListPage(),
    SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Facewords'),
      ),
      // 利用 IndexedStack 防止 Tab 页面重置
      body: IndexedStack(
        index: this._currentIndex,
        children: this._pageList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: this._currentIndex,
        onTap: (int index) {
          print('[_TabsState][BottomNavigationBar][onTap]: 选中Tab$index');
          // 改变状态
          setState(() {
            this._currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Submission',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Word List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
