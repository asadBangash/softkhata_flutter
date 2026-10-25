import 'dart:core';

import 'package:flutter/material.dart';

class EntryDetailsColumn extends StatelessWidget {

  final String label;
  final String value;

  EntryDetailsColumn({@required this.label, @required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 30, top: 30, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children : [
          Container(
            child: Text(
              label,
              style: TextStyle(
                  color: Theme.of(context).primaryColorLight,
                  fontSize: 17
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            child: Text(
              value,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 23
              ),
            ),
          ),
        ]
      ),
    );
  }
}
