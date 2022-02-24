import 'package:daily_news/model/article.dart';

class ArticleListModel{
  String status;
  int totalResults;
  List<Article> articles;
  
  ArticleListModel({
    required this.status,
    required this.totalResults,
    required this.articles
  });

  factory ArticleListModel.fromJson(Map<String, dynamic> json) => ArticleListModel(
    status: json["status"],
    totalResults: json["totalResults"],
    articles: List<Article>.from(
      json["articles"].map((x) => Article.fromJson(x)),
    )
  );

}