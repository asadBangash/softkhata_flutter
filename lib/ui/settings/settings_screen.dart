import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soft_khata_flutter/navigation/routes_names.dart';
import 'package:soft_khata_flutter/theme/ThemeColors.dart';
import 'package:soft_khata_flutter/utils/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsScreen> {
  var isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "Settings",
          style: TextStyle(
              color: Theme.of(context).primaryColor
          ),
        ),
        elevation: 1.5,
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: SingleChildScrollView(
        child: initScreen(),
      ),
    );
  }

  Widget initScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 30, top: 30),
          child: Text(
            "General Settings",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold
            ),
          ),
        ),

        divider(),

        GestureDetector(
          onTap: () {
            Preferences.setIsLogin(false);
            Navigator.pushNamedAndRemoveUntil(context, RoutesName.login, (route) => false);
          },
          child: Container(
            margin: EdgeInsets.only(top: 25, left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 30),
                  child: SvgPicture.asset(
                    "assets/icons/ic_logout.svg",
                    width: 22,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Text(
                    "Logout",
                    style: TextStyle(
                        fontSize: 19
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        divider(),
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: EdgeInsets.only(top: 25, left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 27),
                  child: SvgPicture.asset(
                    "assets/icons/ic_about_us.svg",
                    width: 22,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 21),
                  child: Text(
                    "About Us",
                    style: TextStyle(
                        fontSize: 19
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        divider(),
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: EdgeInsets.only(top: 25, left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 25),
                  child: SvgPicture.asset(
                    "assets/icons/ic_rate.svg",
                    width: 27,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 19, top: 3),
                  child: Text(
                    "Rate Us",
                    style: TextStyle(
                        fontSize: 19
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // divider(),
        // GestureDetector(
        //   onTap: () {},
        //   child: Container(
        //     margin: EdgeInsets.only(top: 25, left: 20),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Container(
        //           margin: EdgeInsets.only(left: 28),
        //           child: SvgPicture.asset(
        //             "assets/icons/ic_monthly_report.svg",
        //             width: 21,
        //           ),
        //         ),
        //         Container(
        //           margin: EdgeInsets.only(left: 20),
        //           child: Text(
        //             "Monthly Report",
        //             style: TextStyle(
        //                 fontSize: 19
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        // divider(),
        // GestureDetector(
        //   onTap: () {
        //     setState(() {
        //       if(isDarkMode) {
        //         isDarkMode = false;
        //       } else {
        //         isDarkMode = true;
        //       }
        //     });
        //   },
        //   child: Container(
        //     margin: EdgeInsets.only(top: 25, left: 20),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Expanded(
        //           child: Container(
        //             margin: EdgeInsets.only(left: 28),
        //             child: SvgPicture.asset(
        //               "assets/icons/ic_dark_theme.svg",
        //               width: 21,
        //             ),
        //           ),
        //           flex: 0,
        //         ),
        //         Expanded(
        //           flex: 1,
        //           child: Container(
        //             margin: EdgeInsets.only(left: 20),
        //             child: Text(
        //               "Dark Mode",
        //               style: TextStyle(
        //                   fontSize: 19
        //               ),
        //             ),
        //           ),
        //         ),
        //         Container(
        //           height: 25,
        //           margin: EdgeInsets.only(right: 15),
        //           alignment: Alignment.centerRight,
        //           child: Switch(
        //             value: isDarkMode ? true : false,
        //             onChanged: (value) {},
        //             activeColor: Theme.of(context).primaryColor,
        //           ),
        //         )
        //       ],
        //     ),
        //   ),
        // ),
        // divider(),
        Container(
          margin: EdgeInsets.only(top: 20),
          child: Center(
            child: Text(
              "App Version 0.1",
              style: TextStyle(
                color: ThemeColors.COLOR_LIGHT_GRAY
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget settingsRow(String icon, String label, Function onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.only(top: 25, left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 30),
              child: SvgPicture.asset(
                icon,
                width: 22,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 19
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget divider() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: MediaQuery.of(context).size.width,
      height: 0.3,
      color: ThemeColors.COLOR_GRAY,
    );
  }

}