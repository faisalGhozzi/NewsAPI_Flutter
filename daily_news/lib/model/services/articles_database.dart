import 'dart:async';
import 'dart:io';

import 'package:daily_news/model/article_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';

class ArticlesDatabase{
  static final ArticlesDatabase instance = ArticlesDatabase._init();

  static Database? _database;

  ArticlesDatabase._init();

  Future<Database> get database async {
    return _database != null ? _database! : await _initDB('favorites.db');
  }

  Future<Database> _initDB(String file) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, file);

    return await openDatabase(path, onCreate: _createDB, version: 1);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE articles (
        _id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        url TEXT NOT NULL,
        urlToImage TEXT NOT NULL,
        publishedAt TEXT NOT NULL,
        content TEXT NOT NULL,
        author TEXT NOT NULL,
        source TEXT NOT NULL
      )
''');
  }

  Future<Article> create(Article article) async {
    final db = await instance.database;

    final id = await db.insert("articles", article.toJson());
    return article.copy(id: id);
  }

  Future<Article> fetchArticle(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      'articles',
      columns: [
        '_id', 'title', 'description', 'url', 'urlToImage', 'publishedAt', 'content', 'author', 'source'
        ],
      where: '_id = ?',
      whereArgs: ['_id'],
    );

    if (maps.isNotEmpty){
      return Article.fromJson(maps.first);
    } else {
      throw Exception('Article with ID $id not found');
    }
  }

  Future<List<Article>> fetchAllArticles() async {
    final db = await instance.database;

    final result = await db.query("articles", orderBy: 'publishedAt DESC');

    return result.map((e) => Article.fromJson(e)).toList();
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      'articles',
      where: '_id = ?',
      whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
  
}