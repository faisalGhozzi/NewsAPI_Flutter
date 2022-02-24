import 'package:daily_news/model/article_list_model.dart';
import 'package:daily_news/model/article.dart';
import 'package:dio/dio.dart';
import 'package:daily_news/auth/secret.dart';

class NewsService {
  final endPoint = "newsapi.org";
  var dio = Dio();

  Future<List<Article>> getNews(String country) async {
    final params = {
      'country': country,
      'apiKey': apiKey,
    };
    try {
      final uri = Uri.https(endPoint, '/v2/top-headlines', params);
      Response response = await dio.get(uri.toString());
      ArticleListModel articleListModel =
          ArticleListModel.fromJson(response.data);
      return cleanArticles(articleListModel);
    } on DioError catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Article>> fetchByContent(String content, int page) async {
    var date = DateTime.now();
    final params = {
      'q': content,
      'from': DateTime(date.year, date.month - 1, date.day).toString(),
      'sortBy': "publishedAt",
      'apiKey': apiKey,
      'page': page.toString()
    };
    final uri = Uri.https(endPoint, '/v2/everything', params);
    final response = await dio.get(uri.toString());
    if (response.statusCode == 200) {
      ArticleListModel articleListModel =
          ArticleListModel.fromJson(response.data);
      return cleanArticles(articleListModel);
    } else {
      throw Exception("Failled to get $content's articles");
    }
  }

  List<Article> cleanArticles(ArticleListModel articleListModel) {
    List<Article> cleanArticlesList = [];
    for (var article in articleListModel.articles) {
      if (article.urlToImage == "null" ||
          article.title == "null" ||
          article.source.name == "null") {
        continue;
      } else {
        cleanArticlesList.add(article);
      }
    }
    return cleanArticlesList;
  }
}