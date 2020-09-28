import 'package:facewords/pages/dictionary_page.dart';
import 'package:facewords/pages/submit_result_page.dart';
import 'package:facewords/pages/word_list_page.dart';
import 'package:flutter/material.dart';
import 'package:facewords/tabs.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // 命名路由配置
  final routes = {
    '/': (context, {arguments}) => Tabs(arguments: arguments),
    '/submit_result_page': (context, {arguments}) =>
        SubmitResultPage(arguments: arguments),
    '/dictionary_page': (context, {arguments}) =>
        DictionaryPage(arguments: arguments),
  };

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
      // 利用初始路由加载 Tabs：'/': (context) => Tabs()
      initialRoute: '/',
      // 命名路由统一传参处理方法 onGenerateRoute
      // ignore: missing_return
      onGenerateRoute: (RouteSettings settings) {
        final String name = settings.name;
        final Function pageContentBuilder = this.routes[name];
        if (pageContentBuilder != null) {
          if (settings.arguments != null) {
            final Route route = MaterialPageRoute(
                builder: (context) =>
                    pageContentBuilder(context, arguments: settings.arguments));
            return route;
          } else {
            final Route route = MaterialPageRoute(
                builder: (context) => pageContentBuilder(context));
            return route;
          }
        }
      },
    );
  }
}
