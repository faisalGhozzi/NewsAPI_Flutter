import 'source_model.dart';
import 'dart:convert';

List<Article> articleFromJson(String str) =>
  List<Article>.from(json.decode(str).map((x) => Article.fromJson(x)));

String articleToJson(List<Article> data) =>
  json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
class Article {
    Source source;
    String author;
    String title;
    String description;
    String url;
    String urlToImage;
    DateTime publishedAt;
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
        "source": source.toJson(),
        "author": author,
        "title": title,
        "description": description,
        "url": url,
        "urlToImage": urlToImage,
        "publishedAt": publishedAt.toIso8601String(),
        "content": content,
    };
}