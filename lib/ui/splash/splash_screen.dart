import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soft_khata_flutter/navigation/routes_names.dart';
import 'package:soft_khata_flutter/ui/on_boarding/onboarding_screen.dart';
import 'package:soft_khata_flutter/utils/login_preferences.dart';
import 'package:soft_khata_flutter/utils/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return initWidget(context);
  }

  Widget initWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: SvgPicture.asset("assets/icons/logo.svg"),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = Duration(seconds: 3);
    Timer(duration, route);
  }

  route() {
    Preferences.isOnBoardingVisit().then((isVisit) {
        if (isVisit) {
          LoginPreferences.isLoggedIn().then((isLoggedIn) {
            if(isLoggedIn) {
              Navigator.pushReplacementNamed(context, RoutesName.dashboard);
            } else {
              Navigator.pushReplacementNamed(context, RoutesName.auth);
            }
          });
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => OnBoardingScreen(),
          ));
        }
      },
    );
  }
}