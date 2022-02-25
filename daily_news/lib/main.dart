import 'package:daily_news/model/article.dart';
import 'package:daily_news/model/source.dart';
import 'package:daily_news/view/screens/home_page.dart';
import 'package:daily_news/viewmodel/article_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as p; 


void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<Article>(ArticleAdapter());
  Hive.registerAdapter<Source>(SourceAdapter());
  await Hive.openBox<Article>('articles');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ArticleViewModel()),
      ], 
      child:  MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Daily News',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: const HomePage(),
      ),
    );
  }
}
