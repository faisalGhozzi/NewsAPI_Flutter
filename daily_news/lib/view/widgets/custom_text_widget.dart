import 'package:flutter/material.dart';

class CustomTextWidget extends StatefulWidget {

  final String text;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final Color color;
  final double fontSize;


  const CustomTextWidget({ Key? key,
  required this.text,
  this.fontSize = 14.0,
  this.fontStyle = FontStyle.normal, 
  this.fontWeight = FontWeight.normal, 
  this.color = Colors.black, 
   }) : super(key: key);

  @override
  _CustomTextWidgetState createState() => _CustomTextWidgetState();
}

class _CustomTextWidgetState extends State<CustomTextWidget> {
  @override
  Widget build(BuildContext context) {
    return Align(alignment: Alignment.topLeft, child: Text(widget.text, style: TextStyle(fontSize: widget.fontSize, fontWeight: widget.fontWeight, fontStyle: widget.fontStyle, color: widget.color)));
  }
}