import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final Color primary;
  final String text;
  final VoidCallback onPressed;
  final double width;
  const CustomButton({ Key? key, required this.text, required this.primary, required this.onPressed, required this.width }) : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: widget.primary,
                  onPrimary: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)
                  ),
                  minimumSize: Size(widget.width, 40),
                  ),
              onPressed: widget.onPressed,
              child: Text(widget.text),
              );
  }
}