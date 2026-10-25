import 'package:flutter/material.dart';
import 'package:soft_khata_flutter/components/dot_indicator.dart';
import 'package:soft_khata_flutter/components/on_boarding_page.dart';
import 'package:soft_khata_flutter/data/models/slider_model.dart';
import 'package:soft_khata_flutter/ui/auth/auth_screen.dart';
import 'package:soft_khata_flutter/utils/shared_preferences.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoardingScreen> {
  int _currentPage;
  PageController _controller;

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
  }

  _onPageChanged(int value) {
    setState(() => _currentPage = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: slider_list.length,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, i) => OnBoardingPage(index: i),
            scrollDirection: Axis.horizontal,
            physics: ClampingScrollPhysics(),
          ),
          Stack(
            alignment: AlignmentDirectional.topStart,
            children: <Widget>[
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      for (int i = 0; i < slider_list.length; i++)
                        i == _currentPage
                            ? DotIndicator(true)
                            : DotIndicator(false),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _currentPage == slider_list.length - 1
              ? showDoneButton(true)
              : showDoneButton(false)
        ],
      ),
    );
  }

  showDoneButton(bool isVisible) {
    return Visibility(
      child: Container(
        alignment: AlignmentDirectional.bottomEnd,
        margin: EdgeInsets.only(bottom: 30.0, right: 20.0),
        child: OutlinedButton(
          onPressed: () {
            Preferences.setOnBoardingVisit(true);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => AuthScreen()));
          },
          child: Text("FINISH",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              )),
        ),
      ),
      visible: isVisible,
    );
  }
}
