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
  // Future<JapaneseMecab> resultData;
  List resultData;

  @override
  void initState() {
    super.initState();
    _getSubmitResult();
  }

  // get 请求 api 分词结果
  _getSubmitResult() async {
    var res = await http
        .get(widget.arguments['submitUrl'] + widget.arguments['paras']);
    if (res.statusCode == 200) {
      setState(() {
        this.resultData = jsonDecode(res.body)['items'][0]['words'];
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
      body: Column(
        children: <Widget>[
          Text(widget.arguments['submitUrl'] + widget.arguments['paras']),
          Text(this.resultData.toString()),
          // RaisedButton(
          //   child: Text('Submit!'),
          //   onPressed: _getSubmitResult,
          // )
        ],
      ),
    );
  }
}
