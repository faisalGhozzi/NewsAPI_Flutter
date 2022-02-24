import 'package:hive/hive.dart';
import 'package:daily_news/model/article.dart';
import 'package:sqflite/sqflite.dart';

class Boxes {
  static Box<Article> getFavorites() => 
    Hive.box<Article>('articles');
}