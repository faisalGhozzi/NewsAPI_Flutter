import 'package:daily_news/model/article.dart';
import 'package:daily_news/view/widgets/custom_button.dart';
import 'package:daily_news/view/widgets/custom_text_widget.dart';
import 'package:daily_news/view/widgets/drop_shadow_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'package:hive/hive.dart';



class ShowDetails extends StatefulWidget {
  
  final Article article;
  const ShowDetails({ Key? key, required this.article }) : super(key: key);


  @override
  _ShowDetailsState createState() => _ShowDetailsState();
}

class _ShowDetailsState extends State<ShowDetails> {
  late List<Article> articles;
  bool isLoading = false;
  String titleClean(String s){
    return (s.lastIndexOf('-') != -1)? s.substring(0, s.lastIndexOf('-')):s;
  }



  void addFavorite(Article article) async {
    final favoritesBox = Hive.box('articles');
    favoritesBox.add(article);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                
                addFavorite(widget.article);
                final snackBar = SnackBar(
                  content: const Text("Article added to favorites."),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {

                    },
                  ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: const Icon(Icons.favorite),
            ),
          ),
        ],
      ),
      body: SizedBox(
        height: double.infinity,
        child: Column(
          children: [
            DropShadowWidget(child: Image.network(widget.article.urlToImage, fit: BoxFit.cover), height: .3, opacity: 0.4,),
            SizedBox(height: MediaQuery.of(context).size.height*.02,),      
            Container(padding: const EdgeInsets.fromLTRB(10, 0, 10, 10) ,
            
            child: Column(
              children: [
                CustomTextWidget(text: titleClean(widget.article.title,), fontSize: 30, fontWeight: FontWeight.bold),
                SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                CustomTextWidget(text: DateFormat.yMd().format(widget.article.publishedAt )+" - "+widget.article.source.name, fontStyle: FontStyle.italic, color: Colors.grey,),
                SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                CustomTextWidget(text: widget.article.content, fontSize: 16,),
                SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                const CustomTextWidget(text: "Written by: ", fontStyle: FontStyle.italic,),
                CustomTextWidget(text: widget.article.author, fontStyle: FontStyle.italic,),
                ],
              )
            ),
          Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(
                          text: "Go To Source", 
                          primary: Colors.red, 
                          onPressed: () async {
                            try{
                              launch(widget.article.url);
                            }catch(e){
                              throw Exception("Couldn't open link : "+e.toString());
                            }
                          }),
                          SizedBox(width: MediaQuery.of(context).size.width*0.1,),
                          CustomButton(
                          text: "Share News", 
                          primary: Colors.blue, 
                          onPressed: () => _onShare(context, widget.article.url)),
                      ],
                    )
                    ),
                  )
          ],
        ),
      )
    );
  }

  /*void addFavorite(Article article){
    final articl = Article(
      author: article.author, 
      content: article.content, 
      description: article.description,
      publishedAt : article.publishedAt,
      source : article.source,
      title : article.title,
      url : article.url,
      urlToImage : article.urlToImage);

      final box = Boxes.getFavorites();
      box.add(articl);
  }*/

  void _onShare(BuildContext context, url) async {
    final box = context.findRenderObject() as RenderBox?;

    if (widget.article.url.isNotEmpty) {
      await Share.share(url,
          subject: "Check out this story",
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    }
  }
}