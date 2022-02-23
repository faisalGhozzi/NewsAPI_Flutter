import 'source_model.dart';
import 'dart:convert';

List<Article> articleFromJson(String str) =>
  List<Article>.from(json.decode(str).map((x) => Article.fromJson(x)));

String articleToJson(List<Article> data) =>
  json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
class Article {
    int? id;
    Source source;
    String? sourceName;
    String author;
    String title;
    String description;
    String url;
    String urlToImage;
    DateTime publishedAt;
    String content;

    Article({
        this.id,
        required this.source,
        this.sourceName,
        required this.author,
        required this.title,
        required this.description,
        required this.url,
        required this.urlToImage,
        required this.publishedAt,
        required this.content,
    });
    
    factory Article.fromJson(Map<String, dynamic> json) => Article(
        id: json["_id"] as int?,
        source: Source.fromJson(json['source']),
        author: json["author"]?? "Unknown",
        title: json["title"]?? "null",
        description: json["description"]?? "null",
        url: json["url"],
        urlToImage: json["urlToImage"]?? "null",
        publishedAt: DateTime.parse(json["publishedAt"]),
        content: json["content"] ?? "No content available for the moment",
    );
    
    Article copy({
      int? id,
      Source? source,
      String? author,
      String? title,
      String? description,
      String? url,
      String? urlToImage,
      DateTime? publishedAt,
      String? content,
    }) => Article(
      id: id ?? this.id,
      source: source ?? this.source,
      author: author ?? this.author,
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      urlToImage: urlToImage ?? this.urlToImage,
      publishedAt: publishedAt ?? this.publishedAt,
      content: content ?? this.content
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "source": source.name,
        "author": author,
        "title": title,
        "description": description,
        "url": url,
        "urlToImage": urlToImage,
        "publishedAt": publishedAt.toIso8601String(),
        "content": content,
    };
}