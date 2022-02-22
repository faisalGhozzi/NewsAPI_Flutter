import 'package:daily_news/model/article_model.dart';
import 'package:daily_news/viewmodel/article_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class HomePage extends StatelessWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ArticleViewModel articleViewModel = context.watch<ArticleViewModel>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Container(
        child: Column(children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Text("NNews",
            style: TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 40,
            ),
            ),
          ),
          const Align(
            alignment: Alignment.topLeft,
            child: Text("your daily dose of news",
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 20,
            ),
            ),
          ),
          _ui(articleViewModel)]),
      ),
    );
  }

  _ui(ArticleViewModel articleViewModel){
    if(articleViewModel.loading){
      return const Center(child: CircularProgressIndicator());
    }
    return Expanded(
      child: ListView.separated(
        itemBuilder: ((context, index) {
          Article article = articleViewModel.articleList[index];
          return Container(
            padding: EdgeInsets.all(2),
            child: ListTile(
              onTap: () {
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (_) => 
                // ))
              },
              title: Text(article.title, maxLines: 1, overflow: TextOverflow.ellipsis,),
              subtitle: Text(article.description, maxLines: 3, overflow: TextOverflow.fade),
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
        itemCount: articleViewModel.articleList.length),
        );
  }
}