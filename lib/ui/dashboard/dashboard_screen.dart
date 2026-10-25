import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soft_khata_flutter/theme/ThemeColors.dart';
import 'package:soft_khata_flutter/ui/home/home_screen.dart';
import 'package:soft_khata_flutter/ui/profile/profile_screen.dart';
import 'package:soft_khata_flutter/ui/settings/settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DashboardState();
}

class _DashboardState extends State<DashboardScreen> {

  int selectedIndex = 0;
  final _screens = [
    HomeScreen(),
    ProfileScreen(),
    SettingsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: ThemeColors.COLOR_GRAY,
        backgroundColor: Color(0xffEEEEEE),
        currentIndex: selectedIndex,
        onTap: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/ic_home.svg",
              color: selectedIndex == 0 ? Theme.of(context).primaryColor : ThemeColors.COLOR_GRAY,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/ic_profile.svg",
              color: selectedIndex == 1 ? Theme.of(context).primaryColor : ThemeColors.COLOR_GRAY,
            ),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/ic_settings.svg",
              color: selectedIndex == 2 ? Theme.of(context).primaryColor : ThemeColors.COLOR_GRAY,
            ),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
