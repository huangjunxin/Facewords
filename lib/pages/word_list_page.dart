import 'package:facewords/models/word.dart';
import 'package:facewords/utils/database.dart';
import 'package:flutter/material.dart';

class WordListPage extends StatefulWidget {
  @override
  _WordListPageState createState() => _WordListPageState();
}

class _WordListPageState extends State<WordListPage> {
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

  // 滑动 word 项后的右侧背景（删除 word 项）
  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            Text(
              " Edit",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  // 滑动 word 项后的左侧背景（自定义单词释义）
  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

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
                  return GestureDetector(
                    // 当长按 word 项时，则跳转至单词查询界面
                    onLongPress: () {
                      print(
                          '[_WordListPageState][ListView][GestureDetector][onLongPress]: ${item.word}(id: ${item.wordId}) is long pressed');
                      Navigator.pushNamed(
                        context,
                        '/dictionary_page',
                        arguments: item.toJson(), // 传整个 item 过去
                      );
                    },
                    child: Dismissible(
                      background: slideRightBackground(), // 项被从右到左滑出
                      secondaryBackground: slideLeftBackground(), // 项被从左到右滑出
                      key: Key(item.wordId.toString()),
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.endToStart) {
                          // 若滑动方向为从右到左，则做：删除 word 项
                          return true;
                        } else if (direction == DismissDirection.startToEnd) {
                          // 若滑动方向为从左到右，则做：跳转至单词释义修改页面
                          Navigator.pushNamed(
                            context,
                            '/edit_word_page',
                            arguments: item.toJson(), // 传整个 item 过去
                          );
                          // Dismiss 不进行删除
                          return false;
                        } else {
                          return false;
                        }
                      },
                      onDismissed: (direction) async {
                        // 若滑动方向为从右到左，则做：删除 word 项
                        if (direction == DismissDirection.endToStart) {
                          print(
                              '[_WordListPageState][ListView][Dismissible][onDismissed]: ${item.word}(id: ${item.wordId}) is dismissed');
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
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text('"${item.word}" is deleted'),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () async {
                                  // 撤销删除
                                  print(
                                      '[_WordListPageState][ListView][SnackBar][onPressed]: ${item.word}(id: ${item.wordId}) is restored');
                                  await DBProvider.db.newWord(item);
                                  setState(() {
                                    _wordListFuture = getWordList();
                                  });
                                },
                              ),
                            ),
                          );
                        }
                      },
                      child: ListTile(
                        leading: Icon(Icons.book, size: 30),
                        title: Text(item.word),
                        subtitle: (item.meaning != null)
                            ? ((item.meaning.length !=
                                    0) // 当 meaning 不为 null 也不为 空字符串 时才显示
                                ? Text(item.meaning)
                                : null)
                            : null,
                      ),
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
