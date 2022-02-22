import 'dart:io';

import 'package:daily_news/news_list/data/api_status.dart';
import 'package:daily_news/news_list/models/article_model.dart';
import 'package:dio/dio.dart';
import 'package:daily_news/auth/secret.dart';
import 'dart:convert';

class NewsService{

  final endPoint = "https://newsapi.org/";

  Future<Object> getNews()async{
    var dio = Dio();
    final params = {
      'country' : 'us',
      'apiKey' : apiKey,
    };
    try{
      final uri = Uri.https(endPoint, '/v2/top-headlines', params);
      final response = await dio.get(uri.toString());
      if (response.statusCode == 200){
        Map<String, dynamic> json = jsonDecode(response.data);
        List<dynamic> body = json['articles'];
        List<Article> articles = body.map((dynamic item) => Article.fromJson(item)).toList();
        return Success(code: 200, reponse: articles);
      }
      return Failure(code: 502, reponse: "Invalid Response");
    }on HttpException{
      return Failure(code: 0, reponse: "No Internet Connexion");
    }catch (e){
      return Failure(code: 500, reponse: e.toString());
    }   
  }  
}