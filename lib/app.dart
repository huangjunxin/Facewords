import 'package:flutter/material.dart';
import 'package:facewords/tabs.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Facewords',
      theme: ThemeData(
        // This is the theme of the application.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // routes: <String, WidgetBuilder> {
      //   "dictionaries": (BuildContext context) => WebviewScaffold(
      //     url: "https://jisho.org/search/%E6%98%A8%E6%97%A5",
      //     appBar: AppBar(
      //       title: Text('Jisho'),
      //       leading: IconButton(
      //         icon: Icon(Icons.arrow_back),
      //         onPressed: () {
      //           Navigator.of(context).pushReplacementNamed('app');
      //         },
      //       )
      //     ),
      //   )
      // },
      home: Tabs(),
    );
  }
}