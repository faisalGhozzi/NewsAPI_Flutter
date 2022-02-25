import 'package:daily_news/model/article.dart';
import 'package:daily_news/model/services/helper_functions.dart';
import 'package:daily_news/view/screens/favorites_page.dart';
import 'package:daily_news/view/widgets/custom_button.dart';
import 'package:daily_news/view/widgets/custom_text_widget.dart';
import 'package:daily_news/view/widgets/drop_shadow_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:hive/hive.dart';

class ShowDetails extends StatefulWidget {
  final int id;
  final Article article;
  final int index;
  const ShowDetails({ Key? key, required this.article, this.id=-1,  this.index=-1 }) : super(key: key);

  @override
  _ShowDetailsState createState() => _ShowDetailsState();
}

class _ShowDetailsState extends State<ShowDetails> {
  late List<Article> articles;
  bool isLoading = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: widget.id == -1 ? GestureDetector(
              onTap: () async {
                final arts = Hive.box<Article>('articles');
                bool exists = false;
                if (arts.length > 0){
                  for (var i = 0; i < arts.length; i++) {
                    if(widget.article.title == arts.getAt(i)!.title){
                      exists = true;
                      break;
                    }
                  } 
                }
                if(exists){
                  const snackBar = SnackBar(
                    content: Text("Article already saved."),                    
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }else{
                  int i = await Hive.box<Article>('articles').add(widget.article);               
                  final snackBar = SnackBar(
                  content: const Text("Article added to favorites."),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      Hive.box<Article>('articles').delete(i);
                    },
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: const Icon(Icons.favorite),
            ) : 
            GestureDetector(
              onTap: () async {
                showDialog(
                  context: context, 
                  builder: (context){
                    return AlertDialog(
                      title: const Text("Warning!"),
                      content: const Text("Are you sure that you want to remove this article from your favorites?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                          Hive.box<Article>('articles').deleteAt(widget.index);
                           Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const FavoritesPage()
                              )
                            );
                          // Navigator.of(context).pop();
                          // Navigator.of(context).pop();
                          }, 
                          child: const Text("Delete", style: TextStyle(color: Colors.red),)),
                        TextButton(
                          onPressed: (){
                            Navigator.of(context).pop(false);
                          }, child: const Text("No"))
                      ],
                    );
                  }
                ); 
              },
              child: const Icon(Icons.delete),
            )
            ,
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
                CustomTextWidget(text: HelperFunctions.titleClean(widget.article.title,), fontSize: 30, fontWeight: FontWeight.bold),
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

  void _onShare(BuildContext context, url) async {
    final box = context.findRenderObject() as RenderBox?;

    if (widget.article.url.isNotEmpty) {
      await Share.share(url,
          subject: "Check out this story",
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    }
  }
}