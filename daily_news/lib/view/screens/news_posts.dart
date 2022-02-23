import 'package:daily_news/model/article_model.dart';
import 'package:daily_news/view/screens/show_details.dart';
import 'package:daily_news/view/widgets/drop_shadow_widget.dart';
import 'package:daily_news/viewmodel/article_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NewsPosts extends StatefulWidget {
  const NewsPosts({Key? key}) : super(key: key);

  @override
  _NewsPostsState createState() => _NewsPostsState();
}

class _NewsPostsState extends State<NewsPosts> {
  @override
  void initState() {
    super.initState();
    Provider.of<ArticleViewModel>(context, listen: false)
        .topHeadlinesByCountry();
  }

  Widget _buildList(ArticleViewModel articleView) {
    switch (articleView.loadingStatus) {
      case LoadingStatus.searching:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case LoadingStatus.completed:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: _ui(articleView) 
        );
      case LoadingStatus.empty:
      default:
        return const Center(
          child: Text("No results found"),
        );
    }
  }

  void _selectCountry(ArticleViewModel articleViewModel, String country){
    articleViewModel.topHeadlinesByCountry(country: country);
  }

  @override
  Widget build(BuildContext context) {
    var articleView = Provider.of<ArticleViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
                "NewsFeed",
                style: TextStyle(
                  fontFamily: 'PlayfairDisplay',
                  fontSize: 40,
                ),
        ),
        actions: [
          PopupMenuButton<String>(
            tooltip: "Article language",
            onSelected: (value) {
              _selectCountry(articleView, value);
              },
              icon: const Icon(Icons.language),
              itemBuilder: (_) {
                return Countries.keys.map((e) => PopupMenuItem(
                  value: Countries[e],
                  child: Text(e)
                  )
                ).toList();
              },
            )
          ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: _buildList(articleView),
            ),
          ],
        ),
      ),
      
      floatingActionButton: Tooltip(
        richMessage: const TextSpan(text: 'Saved articles'),
        child: FloatingActionButton(
          onPressed: () {
      
          },
          backgroundColor: Colors.red,
          child:  const Icon(Icons.favorite),
        ),
      )
    );
  }

  static const Map<String, String> Countries = {
    "English" : "us",
    "French" : "fr",
  };

  _ui(ArticleViewModel articleViewModel){
    return ListView.separated(
        itemBuilder: ((context, index) {
          Article article = articleViewModel.articles[index];
          return Container(
            padding: const EdgeInsets.all(2),
            child: ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => ShowDetails(article: article)
                ));
              },
              title: Text(article.title, maxLines: 1, overflow: TextOverflow.ellipsis,),
              subtitle: Text("Source : "+article.source.name),
              leading: Container(
                width: MediaQuery.of(context).size.width* .3,
                decoration: BoxDecoration(
                  image: DecorationImage(image: CachedNetworkImageProvider(
                    article.urlToImage
                    ),
                ),
              ),
              ),
          ));
        }), 
        separatorBuilder: (context, index) => const Divider(), 
        itemCount: articleViewModel.articles.length);
  }
}