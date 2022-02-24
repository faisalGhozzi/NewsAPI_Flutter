import 'package:daily_news/model/article.dart';
import 'package:daily_news/view/screens/favorites_page.dart';
// import 'package:daily_news/view/screens/search_form.dart';
import 'package:daily_news/view/screens/show_details.dart';
import 'package:daily_news/view/widgets/drop_shadow_widget.dart';
import 'package:daily_news/viewmodel/article_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:daily_news/model/services/helper_functions.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:loadmore/loadmore.dart';
class NewsPosts extends StatefulWidget {
  const NewsPosts({Key? key}) : super(key: key);

  @override
  _NewsPostsState createState() => _NewsPostsState();
}

class _NewsPostsState extends State<NewsPosts> {
  List<Article> items = [];

  int page = 1;

  @override
  void initState() {
    super.initState();
    Provider.of<ArticleViewModel>(context, listen: false)
        .topHeadlinesByContent("apple", page);
  }

  void load() {
    if (page <= 5) {
      page += 1;
      Provider.of<ArticleViewModel>(context, listen: false)
          .topHeadlinesByContent("apple", page);
    }
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

  void _selectCountry(ArticleViewModel articleViewModel, String country, page){
    articleViewModel.topHeadlinesByCountry(country: country, page: page);
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
              _selectCountry(articleView, value, page);
              },
              icon: const Icon(Icons.language),
              itemBuilder: (_) {
                return Countries.keys.map((e) => PopupMenuItem(
                  value: Countries[e],
                  child: Text(e)
                  )
                ).toList();
              },
            ),
          IconButton(
            onPressed: () {
              // Navigator.push(
              //   context, 
              //   MaterialPageRoute(
              //     builder: (_) => SearchForm()
              //     )
              //     );
            }, 
            icon: const Icon(Icons.search))
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
            Navigator.push(context, MaterialPageRoute(
                  builder: (_) => FavoritesPage()
                ));
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

  _ui(ArticleViewModel articleViewModel) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: LoadMore(
        isFinish: page == 5,
        onLoadMore: _loadMore,
        whenEmptyLoad: false,
        delegate: const DefaultLoadMoreDelegate(),
        textBuilder: DefaultLoadMoreTextBuilder.english,
        child: ListView.separated(
            itemBuilder: ((context, index) {
              Article article = articleViewModel.articles[index];
              return Container(
                padding: const EdgeInsets.all(2),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ShowDetails(article: article)));
                  },
                  title: Text(
                    article.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text("Source : " + article.source.name),
                  leading: Container(
                    width: MediaQuery.of(context).size.width * .3,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: !HelperFunctions.urlExtension(article.urlToImage)
                            ? Image.network(
                                article.urlToImage,
                                frameBuilder: (context, child, frame,
                                    wasSynchronouslyLoaded) {
                                  return const CircularProgressIndicator();
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Text("Image unavailable");
                                },
                              ).image
                            : Svg(
                                article.urlToImage,
                                source: SvgSource.network,
                              ),
                      ),
                    ),
                  ),
                ),
              );
            }),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: articleViewModel.articles.length),
      ),
    );
  }

  Future<bool> _loadMore() async {
    print("onLoadMore");
    await Future.delayed(const Duration(seconds: 0, milliseconds: 2000));
    load();
    return true;
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 0, milliseconds: 2000));
    page = 1;
    Provider.of<ArticleViewModel>(context, listen: false).articles.clear();
    load();
  }
}