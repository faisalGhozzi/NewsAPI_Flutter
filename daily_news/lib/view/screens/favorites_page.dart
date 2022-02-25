import 'package:daily_news/model/article.dart';
import 'package:daily_news/model/services/helper_functions.dart';
import 'package:daily_news/view/screens/show_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_flutter/adapters.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({ Key? key }) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
                "Favorites",
                style: TextStyle(
                  fontFamily: 'PlayfairDisplay',
                  fontSize: 40,
                ),
        )
    ),
      body: ValueListenableBuilder(
      valueListenable : Hive.box<Article>('articles').listenable(),
      builder: (context, Box<Article> box, _) {
        if(box.values.isEmpty){
          return const Center(
            child: Text("You have no saved articles yet"),
          );
        }
        return ListView.builder(
          itemCount: box.values.length,
          itemBuilder: (context, index) {
            Article? res = box.getAt(index);
            return Dismissible(
              direction: DismissDirection.startToEnd,
              background: Container(
                color: Colors.red,
                padding: const EdgeInsets.only(left: 20),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(Icons.delete, color: Colors.white,)
                  ),
                ),
              key: UniqueKey(),
              onDismissed: (direction) {
                res!.delete();
              },
              child: Container(
                padding: const EdgeInsets.all(2),
                    child: ListTile(
                      onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ShowDetails(article: Article(author: res!.author, content: res.content, description: res.description, publishedAt: res.publishedAt, source: res.source, title: res.title, url: res.url, urlToImage: res.urlToImage), id: res.key,index: index,)
                              )
                            );
                        },
                        title: Text(
                        res!.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,),
                        subtitle: Text("Source : " + res.source.name),
                        leading: Container(
                          width: MediaQuery.of(context).size.width * .3,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: !HelperFunctions.urlExtension(res.urlToImage)
                                  ? Image.network(
                                      res.urlToImage,
                                      frameBuilder: (context, child, frame,
                                          wasSynchronouslyLoaded) {
                                        return const CircularProgressIndicator();
                                      },
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Text("Image unavailable");
                                      },
                                    ).image
                                  : Svg(
                                      res.urlToImage,
                                      source: SvgSource.network,
                                    ),
                            ),
                          ),           
                        )
                      )
                ),
            );
            }
          );
      }
    )
    );
  }
}