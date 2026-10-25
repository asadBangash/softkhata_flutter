
import 'package:flutter/material.dart';
import 'package:soft_khata_flutter/navigation/app_routes.dart';
import 'package:soft_khata_flutter/navigation/routes_names.dart';
import 'package:soft_khata_flutter/theme/ThemeColors.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AuthState();
}

class _AuthState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return initWidget();
  }

  Widget initWidget() {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          _authScreen(),
        ],
      ),
    );
  }

  Widget _authScreen() {
    return Container(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            left: 1,
            right: 1,
            bottom: 1,
            top: 150,
            child: Column(
              children: [
                Image.asset("assets/images/blue_logo.png"),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text(
                    "Soft Khata",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 1,
            left: 1,
            right: 1,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 30, right: 30),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RoutesName.login);
                    },
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      "Login",
                      style: TextStyle(color: ThemeColors.COLOR_WHITE),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 30, right: 30, bottom: 100),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RoutesName.mobileNumber);
                    },
                    child: Text(
                      "Getting Started",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
