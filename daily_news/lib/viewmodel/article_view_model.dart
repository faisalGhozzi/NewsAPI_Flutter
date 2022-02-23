import 'package:daily_news/model/services/news_service.dart';
import 'package:daily_news/model/article_model.dart';
import 'package:flutter/material.dart';

enum LoadingStatus {
  completed,
  searching,
  empty,
}
class ArticleViewModel extends ChangeNotifier{
  LoadingStatus loadingStatus = LoadingStatus.searching;
  List<Article> articles = [];
  
  void topHeadlinesByCountry({String country="us"}) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    List<Article> newsArticles =
        await NewsService().getNews(country);

    articles = newsArticles
        .map((article) => Article(source: article.source, author: article.author, title: article.title, description: article.description, url: article.url, urlToImage: article.urlToImage, publishedAt: article.publishedAt, content: article.content))
        .toList();

    if (articles.isEmpty) {
      loadingStatus = LoadingStatus.empty;
    } else {
      loadingStatus = LoadingStatus.completed;
    }

    notifyListeners();
  }

  void topHeadlinesByContent(String content) async {

    List<Article> newsArticles = await NewsService().fetchByContent(content);
    notifyListeners();

    articles = newsArticles
        .map((article) => Article(source: article.source, author: article.author, title: article.title, description: article.description, url: article.url, urlToImage: article.urlToImage, publishedAt: article.publishedAt, content: article.content))
        .toList();

    if (articles.isEmpty) {
      loadingStatus = LoadingStatus.empty;
    } else {
      loadingStatus = LoadingStatus.completed;
    }

    notifyListeners();
  }
}