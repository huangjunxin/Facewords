import 'package:facewords/utils/database.dart';
import 'package:flutter/material.dart';
import 'package:facewords/models/word.dart';

class EditWordPage extends StatefulWidget {
  Map arguments;
  EditWordPage({Key key, this.arguments}) : super(key: key);

  @override
  _EditWordPageState createState() => _EditWordPageState();
}

class _EditWordPageState extends State<EditWordPage> {
  // 释义输入框 controller
  final meaningTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    meaningTextController.text = widget.arguments['meaning'];
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
        title: Text(widget.arguments['word']),
        actions: <Widget>[
          FlatButton(
            child: Text('Edit'),
            textColor: Colors.white,
            color: Color(0x000000),
            onPressed: () async {
              // 否则，下方为点击按钮所做的操作
              print('[_EditWordPageState][FlatButton][onPressed]: Edit');
              Word updatedWord = Word(
                wordId: widget.arguments['wordId'],
                word: widget.arguments['word'],
                language: widget.arguments['language'],
                pos: widget.arguments['pos'],
                meaning: meaningTextController.text,
                count: widget.arguments['count'],
              );
              await DBProvider.db.updateWord(updatedWord);
              jumpToWordListPage();
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: meaningTextController,
                autofocus: true,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 10,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText:
                      'Customize the meaning of the word "${widget.arguments['word']}"',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
