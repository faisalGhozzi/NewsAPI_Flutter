import 'package:daily_news/view/screens/news_posts.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NewsPosts(); 
  }
}