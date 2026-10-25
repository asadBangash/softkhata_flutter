import 'package:flutter/material.dart';
import 'package:soft_khata_flutter/data/models/slider_model.dart';

class OnBoardingPage extends StatelessWidget {
  int index;
  OnBoardingPage({this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Image.asset(
              slider_list[index].image,
              height: 250,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            child: Text(
              slider_list[index].title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 30,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20, left: 10, right: 10),
            child: Text(
              slider_list[index].subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff585d64),
                fontSize: 19,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
