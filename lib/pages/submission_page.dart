import 'package:flutter/material.dart';

class SubmissionPage extends StatefulWidget {
  @override
  _SubmissionPageState createState() => _SubmissionPageState();
}

class _SubmissionPageState extends State<SubmissionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            TextField(
              autofocus: true,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 15,
              decoration: InputDecoration(
                labelText: 'Enter a corpus:'
              ),
            ),
            RaisedButton(
              child: Text('Submit!'),
              onPressed: () {
                print('[_SubmissionPageState][RaisedButton][onPressed]: Submit!');
              },
            )
          ]
        )
      )
    );
  }
}
