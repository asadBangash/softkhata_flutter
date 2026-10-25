import 'package:flutter/material.dart';

class SignUpSteps extends StatelessWidget {

  final int step;

  SignUpSteps({this.step = 1});

  @override
  Widget build(BuildContext context) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 5, right: 5),
            height: 15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: step == 1 ? Theme.of(context).primaryColor
                  : Theme.of(context).accentColor,
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 5, right: 5),
            height: 15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: step == 2 ? Theme.of(context).primaryColor
                  : Theme.of(context).accentColor,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.only(left: 5, right: 5),
            height: 15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: step == 3 ? Theme.of(context).primaryColor
                  : Theme.of(context).accentColor,
            ),
          ),
        ),
      ],
    );
  }

}