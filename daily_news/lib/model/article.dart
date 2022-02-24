import 'source.dart';
import 'dart:convert';
import 'package:hive/hive.dart';

part 'article.g.dart';


List<Article> articleFromJson(String str) =>
  List<Article>.from(json.decode(str).map((x) => Article.fromJson(x)));

String articleToJson(List<Article> data) =>
  json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@HiveType(typeId: 0)
class Article extends HiveObject{
    @HiveField(0)
    Source source;
    @HiveField(1)
    String author;
    @HiveField(2)
    String title;
    @HiveField(3)
    String description;
    @HiveField(4)
    String url;
    @HiveField(5)
    String urlToImage;
    @HiveField(6)
    DateTime publishedAt;
    @HiveField(7)
    String content;

    Article({
        required this.source,
        required this.author,
        required this.title,
        required this.description,
        required this.url,
        required this.urlToImage,
        required this.publishedAt,
        required this.content,
    });
    
    factory Article.fromJson(Map<String, dynamic> json) => Article(
        source: Source.fromJson(json['source']),
        author: json["author"]?? "Unknown",
        title: json["title"]?? "null",
        description: json["description"]?? "null",
        url: json["url"],
        urlToImage: json["urlToImage"]?? "null",
        publishedAt: DateTime.parse(json["publishedAt"]),
        content: json["content"] ?? "No content available for the moment",
    );
    
    Map<String, dynamic> toJson() => {
        "source": source,
        "author": author,
        "title": title,
        "description": description,
        "url": url,
        "urlToImage": urlToImage,
        "publishedAt": publishedAt.toIso8601String(),
        "content": content,
    };
}