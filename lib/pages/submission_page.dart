import 'package:flutter/material.dart';

class SubmissionPage extends StatefulWidget {
  @override
  _SubmissionPageState createState() => _SubmissionPageState();
}

class _SubmissionPageState extends State<SubmissionPage> {
  String submissionLang = 'ja';

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
                    autofocus: true,
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
                        groupValue: this.submissionLang,
                        onChanged: (value) {
                          setState(() {
                            this.submissionLang = value;
                          });
                        },
                      ),
                      // Text('Vietnamese'),
                      // Radio(
                      //   value: 'vi',
                      //   groupValue: this.submissionLang,
                      //   onChanged: (value) {
                      //     setState(() {
                      //       this.submissionLang = value;
                      //     });
                      //   },
                      // ),
                    ],
                  ),
                ],
              ),
            ),
            RaisedButton(
              child: Text('Submit!'),
              onPressed: () {
                print(
                    '[_SubmissionPageState][RaisedButton][onPressed]: Submit!');
              },
            ),
          ],
        ),
      ),
    );
  }
}
