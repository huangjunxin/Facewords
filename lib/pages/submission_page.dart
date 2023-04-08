import 'package:flutter/material.dart';

class SubmissionPage extends StatefulWidget {
  @override
  _SubmissionPageState createState() => _SubmissionPageState();
}

class _SubmissionPageState extends State<SubmissionPage> {
  // 语料语言选择
  String corpusLanguage = 'ja';
  // 语料输入框 controller
  final corpusTextController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    corpusTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          // verticalDirection: VerticalDirection.up,
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: corpusTextController,
                    // autofocus: true,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 10,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter a corpus',
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Language: Japanese'),
                      Radio(
                        value: 'ja',
                        groupValue: this.corpusLanguage,
                        onChanged: (value) {
                          setState(() {
                            this.corpusLanguage = value;
                          });
                        },
                      ),
                      // Text('Vietnamese'),
                      // Radio(
                      //   value: 'vi',
                      //   groupValue: this.corpusLanguage,
                      //   onChanged: (value) {
                      //     setState(() {
                      //       this.corpusLanguage = value;
                      //     });
                      //   },
                      // ),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              child: Text('Submit!'),
              onPressed: () {
                print(
                    '[_SubmissionPageState][RaisedButton][onPressed]: Submit!');
                Navigator.pushNamed(context, '/submit_result_page', arguments: {
                  'submitUrl': 'https://labs.goo.ne.jp/api/morph',
                  'paras': corpusTextController.text,
                  'language': corpusLanguage,
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
