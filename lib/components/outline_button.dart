import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OutlineButton extends StatelessWidget {

  final Function onPressed;
  final String text;
  // final Color borderColor;
  // final double borderWidth;


  OutlineButton({
    @required this.onPressed,
    @required this.text
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(
              width: 0.3, color: Theme.of(context).primaryColor
          ),
        ),
        onPressed: onPressed,
        child: Text(text,
          style: TextStyle(
              color: Theme.of(context).primaryColor
          ),
        )
    );
  }
}