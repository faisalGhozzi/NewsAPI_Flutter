import 'package:flutter/material.dart';

class DropShadowWidget extends StatefulWidget {
  final Widget child;
  final double height;
  final double opacity;
  const DropShadowWidget({ Key? key, required this.child, required this.height, required this.opacity }) : super(key: key);

  @override
  _DropShadowWidgetState createState() => _DropShadowWidgetState();
}

class _DropShadowWidgetState extends State<DropShadowWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * widget.height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(widget.opacity),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: widget.child,
      );
  }
}