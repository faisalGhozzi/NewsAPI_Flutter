import 'package:daily_news/model/article_model.dart';
import 'package:daily_news/view/screens/show_details.dart';
import 'package:daily_news/view/widgets/drop_shadow_widget.dart';
import 'package:daily_news/viewmodel/article_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        .topHeadlinesByContent("apple");
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
    //ArticleViewModel articleViewModel = context.watch<ArticleViewModel>();
    var articleView = Provider.of<ArticleViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              _selectCountry(articleView, value);
              },
              icon: const Icon(Icons.more_vert),
              itemBuilder: (_) {
                return Countries.keys.map((e) => PopupMenuItem(
                  value: e,
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
            const Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                'News',
                style: TextStyle(fontSize: 50),
              ),
            ),
            const Divider(
              height: 40,
              color: Color(0xffFF8A30),
              thickness: 8,
              indent: 30,
              endIndent: 20,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30, top: 15, bottom: 15),
              child: Text(
                'Headline',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Expanded(
              child: _buildList(articleView),
            ),
          ],
        ),
      )
    );
  }

  static const Map<String, String> Countries = {
    "English" : "us",
    "French" : "fr",
  };

  _ui(ArticleViewModel articleViewModel){
    return Expanded(
      child: ListView.separated(
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
                  image: DecorationImage(image: NetworkImage(article.urlToImage)),
                ),
              ),
              ),
          );
        }), 
        separatorBuilder: (context, index) => const Divider(), 
        itemCount: articleViewModel.articles.length),
        );
  }
}