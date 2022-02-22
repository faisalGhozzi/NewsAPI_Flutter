import 'package:daily_news/model/article_model.dart';
import 'package:daily_news/view/widgets/custom_text_widget.dart';
import 'package:daily_news/view/widgets/drop_shadow_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';


class ShowDetails extends StatefulWidget {
  
  final Article article;

  const ShowDetails({ Key? key, required this.article }) : super(key: key);


  @override
  _ShowDetailsState createState() => _ShowDetailsState();
}

class _ShowDetailsState extends State<ShowDetails> {

  String titleClean(String s){
    return (s.lastIndexOf('-') != -1)? s.substring(0, s.lastIndexOf('-')):s;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          onPrimary: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)
                          ),
                          minimumSize: Size(100, 40),
                          ),
                      onPressed: () async {
                        try{
                          launch(widget.article.url);
                        }catch(e){
                          print(e);
                        }
                      },
                      child: const Text("Go to Source"),
                      ),
                    ),
                  )
          ],
        ),
      )
    );
  }
}