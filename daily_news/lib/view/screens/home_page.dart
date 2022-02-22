import 'package:daily_news/model/article_model.dart';
import 'package:daily_news/view/screens/show_details.dart';
import 'package:daily_news/view/widgets/drop_shadow_widget.dart';
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
      body: articleViewModel.loading ? const Center(child: CircularProgressIndicator()) : Container(
        child: Column(children: [
          DropShadowWidget(child: Column(
            children: const [
              Align(
                alignment: Alignment.topLeft,
                child: Text("NNews",
                style: TextStyle(
                  fontFamily: 'PlayfairDisplay',
                  fontSize: 40,
                ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text("your daily dose of news",
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 20,
                ),
                ),
              ),
            ],
          ), 
          height: .1,
          opacity: 0.2,),
          _ui(articleViewModel)]),
      ),
    );
  }

  _ui(ArticleViewModel articleViewModel){
    return Expanded(
      child: ListView.separated(
        itemBuilder: ((context, index) {
          Article article = articleViewModel.articleList[index];
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
        itemCount: articleViewModel.articleList.length),
        );
  }
}