import 'package:daily_news/model/article.dart';
import 'package:daily_news/model/services/helper_functions.dart';
import 'package:daily_news/view/screens/home_page.dart';
import 'package:daily_news/view/screens/news_posts.dart';
import 'package:daily_news/view/screens/show_details.dart';
import 'package:daily_news/viewmodel/article_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:loadmore/loadmore.dart';
import 'package:provider/provider.dart';

class SearchForm extends StatefulWidget {
  const SearchForm({ Key? key }) : super(key: key);

  @override
  _SearchFormState createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final _formKey = GlobalKey<FormState>();
  var _autoValidate = AutovalidateMode.disabled;
  var _search;
  TextEditingController search = TextEditingController();

  List<Article> items = [];

  int page = 0;

  void load(String query) {
    if (page <= 5) {
      page += 1;
      
      Provider.of<ArticleViewModel>(context, listen: false)
          .topHeadlinesByContent(query, page);
    }
  }

  @override
  void initState() {
    super.initState();
     Provider.of<ArticleViewModel>(context, listen: false).articles.clear();
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
          child: articleView.articles.isNotEmpty ? _ui(articleView) : const Center(child: Text("")) 
        );
      case LoadingStatus.empty:
      default:
        return const Center(
          child: Text("No results found"),
        );
    }
  }

  _ui(ArticleViewModel articleViewModel) {
    return LoadMore(
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
    );
  }

  Future<bool> _loadMore() async {
    await Future.delayed(const Duration(seconds: 0, milliseconds: 2000));
    load(search.text);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var articleView = Provider.of<ArticleViewModel>(context);
    return Scaffold(
      appBar: AppBar(centerTitle: true,
      leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: (){
        Provider.of<ArticleViewModel>(context, listen: false).articles.clear();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => HomePage()));
      },
      ),
        title: const Text(
                "Search News",
                style: TextStyle(
                  fontFamily: 'PlayfairDisplay',
                  fontSize: 40,
                ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height* 0.01,),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: search,
                onSubmitted: (x) {
                  if (search.text.isNotEmpty) {
                        if(articleView.articles.isNotEmpty){
                          Provider.of<ArticleViewModel>(context, listen: false).articles.clear();
                        }
                        load(x);
                        FocusManager.instance.primaryFocus!.unfocus();
                      } else {
                        setState(() {
                          _autoValidate = AutovalidateMode.always;
                        });
                      }
                },
                decoration: InputDecoration(
                  hintText: 'Enter search',
                  border: const OutlineInputBorder(),
                  filled: true,
                  errorStyle: const TextStyle(fontSize: 15),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      if (search.text.isNotEmpty) {
                        if(articleView.articles.isNotEmpty){
                          Provider.of<ArticleViewModel>(context, listen: false).articles.clear();
                        }
                        load(search.text);
                        FocusManager.instance.primaryFocus!.unfocus();
                      } else {
                        setState(() {
                          _autoValidate = AutovalidateMode.always;
                        });
                      }
                    },
                  ),
                ),
                onChanged: (value) {
                  _search = value;
                },  
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height* 0.05,),
            Expanded(child: _buildList(articleView))
          ],
        ),
      ),
    );
  }
}