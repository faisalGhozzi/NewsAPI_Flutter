import 'dart:io';

import 'package:daily_news/news_list/data/api_status.dart';
import 'package:daily_news/news_list/models/article_list_model.dart';
import 'package:daily_news/news_list/models/article_model.dart';
import 'package:dio/dio.dart';
import 'package:daily_news/auth/secret.dart';
import 'dart:convert';

class NewsService{

  static Future<List<Article>> getNews()async{
    const endPoint = "newsapi.org";
    var dio = Dio();
    final params = {
      'country' : 'us',
      'apiKey' : apiKey,
    };
    try{
      final uri = Uri.https(endPoint, '/v2/top-headlines', params);
      Response response = await dio.get(uri.toString());
      ArticleListModel articleListModel = ArticleListModel.fromJson(response.data);
      return articleListModel.articles;
    } on DioError catch(e){
      print(e);
    }
    return [];
  }  
}