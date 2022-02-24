import 'package:daily_news/model/article.dart';
import 'package:daily_news/view/screens/show_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_flutter/adapters.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({ Key? key }) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  
  // @override
  // void dispose() {
  //   Hive.box('articles').close();
  //   super.dispose();
  // }

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
            return Container(
              padding: const EdgeInsets.all(2),
                  child: ListTile(
                    onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ShowDetails(article: Article(author: res!.author, content: res.content, description: res.description, publishedAt: res.publishedAt, source: res.source, title: res.title, url: res.url, urlToImage: res.urlToImage))
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
                            image: !urlExtension(res.urlToImage)
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
              );
            }
          );
      }
    )
    );
  }

  Widget _buildListView() {
    return ValueListenableBuilder(
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
            return Container(
              padding: const EdgeInsets.all(2),
                  child: ListTile(
                    onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ShowDetails(article: Article(author: res!.author, content: res.content, description: res.description, publishedAt: res.publishedAt, source: res.source, title: res.title, url: res.url, urlToImage: res.urlToImage))
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
                            image: !urlExtension(res.urlToImage)
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
              );
            }
          );
      }
    );
  }

  bool urlExtension(String s) {
    return s.lastIndexOf('.svg') != -1;
  }
}