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
  int perPage = 10;
  int present = 0;

  List<Article> items = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      items = Provider.of<ArticleViewModel>(context, listen: false)
          .articleList
          .getRange(present, present + perPage)
          .toList(growable: true);
      present = present + perPage;
    });
  }

  void loadMore() {
    setState(() {
      if ((present + perPage) >
          Provider.of<ArticleViewModel>(context, listen: false)
              .articleList
              .length) {
        items.addAll(Provider.of<ArticleViewModel>(context, listen: false)
            .articleList
            .getRange(
                present,
                Provider.of<ArticleViewModel>(context, listen: false)
                    .articleList
                    .length));
      } else {
        items.addAll(Provider.of<ArticleViewModel>(context, listen: false)
            .articleList
            .getRange(present, present + perPage));
      }
      present = present + perPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    ArticleViewModel articleViewModel = context.watch<ArticleViewModel>();
    return articleViewModel.loading
        ? const Center(child: CircularProgressIndicator())
        : Container(
            child: Column(children: [
              DropShadowWidget(
                child: Column(
                  children: const [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "NNews",
                        style: TextStyle(
                          fontFamily: 'PlayfairDisplay',
                          fontSize: 40,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "your daily dose of news",
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                height: 0.1,
                opacity: 0.2,
              ),
              _ui(articleViewModel)
            ]),
          );
  }

  _ui(ArticleViewModel articleViewModel) {
    return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            loadMore();
          }
          return false;
        },
        child: Expanded(
          child: ListView.separated(
              itemBuilder: ((context, index) {
                return (index == items.length)
                    ? Container(
                        color: Colors.greenAccent,
                        child: CircularProgressIndicator()
                      )
                    : Container(
                        padding: const EdgeInsets.all(2),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        ShowDetails(article: items[index])));
                          },
                          title: Text(
                            items[index].title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle:
                              Text("Source : " + items[index].source.name),
                          leading: Container(
                            width: MediaQuery.of(context).size.width * .3,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(items[index].urlToImage)),
                            ),
                          ),
                        ),
                      );
              }),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: (present <=
                      Provider.of<ArticleViewModel>(context, listen: false)
                          .articleList
                          .length)
                  ? items.length + 1
                  : items.length),
        ));
  }
}